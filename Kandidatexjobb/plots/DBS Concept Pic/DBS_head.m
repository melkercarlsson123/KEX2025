% Head taken from 
%https://www.thingiverse.com/thing:172348/files
% with license

head_model = stlread('human-head.stl'); 

faces = head_model.ConnectivityList;

% 8 för GIGACHAD, 1 för vanliga
scaling_factor = 1;
vertices = head_model.Points*scaling_factor;

% Bara för GIGACHAD
%{

vertices(:,1) = vertices(:,1)-70;
vertices(:,2) = vertices(:,2)-70;
vertices(:,3) = vertices(:,3)-110;



z_cutoff = 0; 

vertices = all(vertices.Points(fv.ConnectivityList,3) > z_cutoff, 2);

%}




figure;

mod_set_standard_plot_style();

% #A86F4F
patch('Faces', faces, 'Vertices', vertices, ...
    'FaceColor', hex2rgb('#C49A75'), 'EdgeColor', 'none');
axis equal;


material dull;
view(30, 30);


light('Position', [0 -5 3], 'Style', 'infinite');



no_of_points = 42;
points = fibonacci_sphere(no_of_points);
radius = 135;
M = 10^(-9);

points = points * radius;
deep_red_purple = [0, 0, 0];

hold on; 


[xe, ye, ze] = sphere(10);  


sphere_radius = 1.5;
xe = xe * sphere_radius;
ye = ye * sphere_radius;
ze = ze * sphere_radius;

for ind=1:length(points(:,1))
 surf(xe + points(ind, 1), ye + points(ind, 2), ze + points(ind, 3), ...
        'FaceColor', [1, 0, 0], 'EdgeColor', 'k', 'FaceLighting', 'gouraud', 'LineWidth', 1.5);

end

function pts = fibonacci_sphere(N)
  
    phi = (1 + sqrt(5)) / 2; 
    theta = 2 * pi * (0:N-1) / phi; 
    z = linspace(1 - 1/N, -1 + 1/N, N); 
    r = sqrt(1 - z.^2); 
  
    x = r .* cos(theta);
    y = r .* sin(theta);
    
    pts = [x(:), y(:), z(:)];
end


shadow_vertices = vertices;
shadow_vertices(:, 3) = -150;
shadow_vertices(:, 2) = shadow_vertices(:, 2) + 50;

hold on;
shadow_faces = faces;
patch('Faces', shadow_faces, 'Vertices', shadow_vertices, ...
    'FaceColor', [0.2 0.2 0.2], 'FaceAlpha', 0.2, 'EdgeColor', 'none', 'FaceLighting', 'gouraud'); 



xlabel('X');
ylabel('Y');
zlabel('Z');


hold on;


[x, y, z] = sphere(50);  
radius = 150;
x = radius * x;
y = radius * y;
z = radius * z;

ml_colour = [0.4, 0.9, 0.3];

surf(x, y, z, ...
    'FaceAlpha', 0.2, ...          
    'EdgeColor', 'none', ...      
    'FaceColor', ml_colour);   

xlabel('X'); ylabel('Y'); zlabel('Z');

light; lighting gouraud;

function rgb = hex2rgb(hex)
    if hex(1) == '#'
        hex = hex(2:end);
    end
    rgb = [hex2dec(hex(1:2)), hex2dec(hex(3:4)), hex2dec(hex(5:6))] / 255;
end