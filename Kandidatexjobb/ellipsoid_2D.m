clear all;
import com.comsol.model.*
import com.comsol.model.util.*
model1 = mphopen("ellipsoid_2D");

%% LAUNCH
% mphlaunch: Öppnar ett COMSOL fönster

mphlaunch(model1)

%% Set Param: 

freq = 0.9*10^(9);
omega = 2*pi*freq;
skin_er = permittivity_tissue(omega, "Skin (Dry)");
cortical_er = permittivity_tissue(omega, "Bone (Cortical)");
cancellous_er = permittivity_tissue(omega, "Bone (Cancellous)");
dura_er = permittivity_tissue(omega, "Dura");
fat_er = permittivity_tissue(omega, "Fat (Average Infiltrated)");
CSF_er = permittivity_tissue(omega, "Cerebro Spinal Fluid");
white_matter_er = permittivity_tissue(omega, "Brain (White Matter)");
grey_matter_er = permittivity_tissue(omega, "Brain (Grey Matter)");
 
% TAGS:
 
skin_tag = "skin_er";
cortical_tag = "cortical_er";
CSF_tag = "CSF_er";
white_matter_tag = "white_matter_er";
grey_matter_tag = "grey_matter_er";
cancellous_tag = "cancellous_er";
dura_tag = "dura_er";
fat_tag = "fat_er";
 
model1.param.set(skin_tag, num2str(skin_er));
model1.param.set(cortical_tag, num2str(cortical_er));
model1.param.set(CSF_tag, num2str(CSF_er));
model1.param.set(white_matter_tag, num2str(white_matter_er));
model1.param.set(grey_matter_tag, num2str(grey_matter_er));
model1.param.set(cancellous_tag, cancellous_er);
model1.param.set(dura_tag, dura_er);
model1.param.set(fat_tag, fat_er);
model1.param.set("frekvens", freq);

global dipole_count
dipole_count = 0;


%% Func
function create_magnetic_dipole2D(model, x, y, M, theta, alpha)

      global dipole_count 

      geom = model.component('comp1').geom('geom1');
      physics = model.component('comp1').physics('emw');
      dipole_count = dipole_count + 1;

      p_tag = ['p' num2str(dipole_count)];
      dipole_tag = ['mpd' num2str(dipole_count)];
      angle_tag = ['theta' num2str(dipole_count)];
      alpha_tag = ['alpha' num2str(dipole_count)];

      model.param.set(angle_tag, theta);
      model.param.set(alpha_tag, alpha);

      p1 = geom.create(p_tag, 'Point');
      p1.set('p', [x, y]);

      model.component('comp1').geom('geom1').run();
      p1.set('selresult', true);
      dipole = model.component('comp1').physics('emw').create(dipole_tag, 'MagneticPointDipole', 0);

      dipole.set('normm', [num2str(M), '*exp(-j*', alpha_tag, ')']);    
      dipole.set('enm', {['cos(' angle_tag ')'], ['sin(' angle_tag ')'], '0'});

      dipole.selection.named(['geom1_' p_tag '_pnt']);

end

%%

no_of_dipoles = 10;
radius = 0.13;
start_angle = pi/(2*no_of_dipoles);
step_angle = pi/no_of_dipoles;

positions = zeros(1, no_of_dipoles);
positions(1) = start_angle;
M = 10^(-9);

dipoles = zeros(no_of_dipoles*2, 4);


for ind=1:no_of_dipoles-1
    pos_angle = start_angle + ind*step_angle;
    positions(ind + 1) = pos_angle;
end



for ind=1:no_of_dipoles

    % 0.08022222 skalan på x
    % 0.12244438 skalan på y

    a = 0.08022222;
    b = 0.12244438;


    x = (a + 0.02) * cos(positions(ind));
    y = (b + 0.02) * sin(positions(ind));

    dipoles(ind, 1) = x;
    dipoles(ind, 2) = y;
    dipoles(ind, 3) = M;
    dipoles(ind, 4) = 0;

    dipoles(ind + no_of_dipoles, 1) = x;
    dipoles(ind + no_of_dipoles, 2) = -y;
    dipoles(ind + no_of_dipoles, 3) = M;
    dipoles(ind + no_of_dipoles, 4) = 0;

end

%% Place Dipoles


for ind = 1: length(dipoles(:, 1))
    temp_ang = 2 * pi * rand();
    temp_phase = 2 * pi * rand();
    create_magnetic_dipole2D(model1, dipoles(ind, 1), dipoles(ind, 2), dipoles(ind, 3), temp_ang, temp_phase)

end


%% 

function obj_func = obj_func(X,Y, mx, my, sx, sy, scale)

obj_func = scale*exp(-((X - mx).^2 / (2*sx^2) + (Y - my).^2 / (2*sy^2)));

end

r = 0.2; 
num_points = 100; 

theta = linspace(0, 2*pi, num_points);
rho = linspace(0, r, num_points);
[Theta, Rho] = meshgrid(theta, rho);

X = Rho .* cos(Theta);
Y = Rho .* sin(Theta);

mx = 0.0; my = 0.0; sx = 0.015; sy = 0.015; scale = 10^(-5);

Z = obj_func(X, Y, mx, my, sx, sy, scale);

data = [X(:), Y(:), Z(:)]; 
writematrix(data, 'objective_function.txt', 'Delimiter', ';');

disp('Data saved to output.txt')

%% Reshuffle initial values:

for ind=1:20

angle_tag = ['theta' num2str(dipole_count)];
alpha_tag = ['alpha' num2str(dipole_count)];

temp_ang = 2 * pi * rand();
temp_phase = 2 * pi * rand();

model1.param.set(angle_tag, temp_ang);
model1.param.set(alpha_tag, temp_phase);


end
