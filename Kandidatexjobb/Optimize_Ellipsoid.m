
clear all;
import com.comsol.model.*
import com.comsol.model.util.*
model1 = mphopen("harid_head_dupe.mph");

%% LAUNCH
% mphlaunch: Öppnar ett COMSOL fönster

mphlaunch(model1)

%% Set Param: 


freq = 1*10^(9);
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

function create_magnetic_moment(model, x, y, z, theta, phi, M, alpha)
    global dipole_count  % Access global variable
    
    geom = model.component('comp1').geom('geom1');
    physics = model.component('comp1').physics('emw');

    dipole_count = dipole_count + 1;

    p_tag = ['p' num2str(dipole_count)];
    dipole_tag = ['mpd' num2str(dipole_count)];
    theta_tag = ['theta' num2str(dipole_count)];
    phi_tag = ['phi' num2str(dipole_count)];
    alpha_tag = ['alpha' num2str(dipole_count)];
    %magn_tag = ['magn' num2str(dipole_count) ];


    model.param.set(theta_tag, theta);
    model.param.set(phi_tag, phi);
    %model.param.set(magn_tag, M);
    model.param.set(alpha_tag, alpha);

    p1 = geom.create(p_tag, 'Point');
    p1.set('p', [x, y, z]);

    model.component('comp1').geom('geom1').run();

    p1.set('selresult', true);
    
    dipole = model.component('comp1').physics('emw').create(dipole_tag, 'MagneticPointDipole', 0);

    dipole.set('normm', [num2str(M) '*exp(-j*', alpha_tag, ')']);
    %dipole.set('normm', M);

    dipole.set('enm', {['sin(' theta_tag ')*' 'cos(' phi_tag ')'], ['sin(' theta_tag ')*' 'sin(' phi_tag ')' ], ['cos(' theta_tag ')']});
    dipole.selection.named(['geom1_' p_tag '_pnt']);
    
end


function [xr,yr,zr] = rotate_around_Z_axis(x,y,z, angle)
rotation_matrix = [cos(angle), -sin(angle), 0; ...
                   sin(angle),  cos(angle), 0; ...
                       0     ,       0    , 1];
rotate_me = [x; y; z];
rotated = rotation_matrix * rotate_me;
xr = rotated(1);
yr = rotated(2);
zr = rotated(3);
end

function pts = fibonacci_sphere(N)
    % Generate N approximately equidistant points on a sphere
    phi = (1 + sqrt(5)) / 2; % Golden ratio
    theta = 2 * pi * (0:N-1) / phi; % Azimuthal angles
    z = linspace(1 - 1/N, -1 + 1/N, N); % Uniformly spaced z-coordinates
    r = sqrt(1 - z.^2); % Compute radii
    
    % Convert to Cartesian coordinates
    x = r .* cos(theta);
    y = r .* sin(theta);
    
    pts = [x(:), y(:), z(:)];
end





%% Place Dipoles

no_of_points = 32;
points = fibonacci_sphere(no_of_points);

% 0.13 för ellipsoid
radius = 0.06;

M = 10^(-9);

points = points * radius;

for ind=1:length(points(:,1))

    x = points(ind,1);
    y = points(ind,2);
    z = points(ind,3);

    theta_temp = 2*pi*rand;
    phi_temp = pi*rand;
    alpha_temp = 2*pi*rand;

    create_magnetic_moment(model1, x, y, z, theta_temp, phi_temp, M, alpha_temp)

end


%% Thoughts

% 0.6 Ghz - runt 30 ml_er, inte så nice. 1.5 cm radie inner sphere
% 0.8 Ghz - runt 20 ml_er. 1cm radie inner sphere

%% Read paramaters

%{

Paramaters can be pasted from COMSOLs "Objective probe table" into a .txt
file. Include headers. 

Expected format: 


alpha1	alpha10	alpha11	alpha12	alpha13	alpha14	alpha15	alpha16	alpha17	alpha18	alpha19	alpha2	alpha20	alpha21	alpha22	alpha23	alpha24	alpha25	alpha26	alpha27	alpha28	alpha29	alpha3	alpha30	alpha31	alpha32	alpha33	alpha34	alpha35	alpha36	alpha37	alpha38	alpha39	alpha4	alpha40	alpha41	alpha42	alpha5	alpha6	alpha7	alpha8	alpha9	phi1	phi10	phi11	phi12	phi13	phi14	phi15	phi16	phi17	phi18	phi19	phi2	phi20	phi21	phi22	phi23	phi24	phi25	phi26	phi27	phi28	phi29	phi3	phi30	phi31	phi32	phi33	phi34	phi35	phi36	phi37	phi38	phi39	phi4	phi40	phi41	phi42	phi5	phi6	phi7	phi8	phi9	theta1	theta10	theta11	theta12	theta13	theta14	theta15	theta16	theta17	theta18	theta19	theta2	theta20	theta21	theta22	theta23	theta24	theta25	theta26	theta27	theta28	theta29	theta3	theta30	theta31	theta32	theta33	theta34	theta35	theta36	theta37	theta38	theta39	theta4	theta40	theta41	theta42	theta5	theta6	theta7	theta8	theta9	Objective
8.6821E-1	5.6253E-1	9.3321E-1	4.5163E0	6.9143E0	7.4429E-1	9.4020E-1	4.1735E0	1.7500E0	5.7531E-1	7.2327E0	1.2069E-1	1.0976E0	1.8455E0	6.5791E0	8.2032E-1	1.0974E0	4.4375E0	8.2442E-1	3.6185E0	4.0399E0	5.7752E0	6.7831E0	3.7502E0	3.6834E0	4.6318E-1	1.1231E0	5.5566E0	1.7909E-1	3.7275E0	3.4927E0	6.7761E0	3.1959E0	5.7804E0	3.2615E0	-1.7525E-1	5.8511E0	4.3920E0	6.8479E0	3.9003E0	6.2125E0	4.2171E0	2.4388E0	1.9544E0	5.0713E-1	2.2448E-1	1.0621E0	1.6239E0	1.8926E0	1.0345E0	2.8354E0	1.9248E0	1.7528E0	8.6275E-1	1.3066E0	9.7896E-1	3.5868E0	4.8149E-1	2.1912E0	8.1481E-1	6.1482E-2	1.3725E0	1.1763E0	1.6406E0	2.8767E0	1.1595E0	1.4295E-1	4.0437E0	1.4804E0	1.0782E0	1.0085E0	6.3911E-1	1.5215E0	1.2162E0	3.2821E0	1.4714E0	1.1518E0	2.4935E0	3.6656E0	1.4352E0	1.5367E0	4.2202E0	2.6990E0	2.4364E0	6.2329E0	3.4930E0	5.4921E0	-3.4618E-1	4.5058E0	1.9309E-1	3.6432E0	2.5378E0	4.2070E0	3.8198E0	3.4351E-1	4.9249E0	2.8850E0	4.8072E0	5.1518E0	3.0722E0	4.5888E-1	5.6377E0	2.9876E0	3.8591E0	5.9700E0	5.3879E0	4.9581E-1	4.5500E0	-3.2564E-1	5.7869E0	2.6759E0	1.6261E0	1.1889E0	4.9875E0	4.6470E0	1.3970E0	1.0239E0	5.1121E0	4.8779E0	8.3377E-2	4.9830E0	6.5778E0	2.5042E-1	5.5048E0	2.9724E-1	4.6927E0	5.2507E-1

%}

data = readcell('ml_er25_42Dipoles_0.8Ghz.txt', 'Delimiter', '\t');
num_params = size(data, 2);

for ind=1:num_params

    opt_tag = data{1, ind};
    opt_val = data{2, ind};

    if ~strcmp(opt_tag, 'Objective')
        model1.param.set(opt_tag, opt_val);
    end

end
