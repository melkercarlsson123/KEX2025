
a = 98;
b = 76;
c = 116;

[x, y, z] = ellipsoid(0, 0, 0, a, b, c, 50);  

figure
h = surf(x, y, z);
axis equal;  
xlabel('X (mm)');
ylabel('Y (mm)');
zlabel('Z (mm)');

% Skin from previous: 

%[178, 24, 43] (Deep Red)
% [33, 102, 172] (Dark Blue)

set(h, 'FaceColor', [0.05, 0.05, 0.05]); 


set(h, 'EdgeColor', 'none');  
shading flat; 
colormap gray;  

view(30, 30);  





no_of_points = 42;
points = fibonacci_sphere(no_of_points);
radius = 130;
M = 10^(-9);

points = points * radius;
deep_red_purple = [0, 0, 0];

hold on; 
%plot3(points(:,1), points(:,2), points(:,3), 'o', 'MarkerFaceColor', deep_red_purple, 'MarkerEdgeColor', deep_red_purple, 'MarkerSize', 4);

[xe, ye, ze] = sphere(10);  


sphere_radius = 1.5;
xe = xe * sphere_radius;
ye = ye * sphere_radius;
ze = ze * sphere_radius;

for ind=1:length(points(:,1))
 surf(xe + points(ind, 1), ye + points(ind, 2), ze + points(ind, 3), ...
        'FaceColor', [1, 0, 0], 'EdgeColor', 'k', 'FaceLighting', 'gouraud', 'LineWidth', 1.5);

end

lighting gouraud; 
material shiny;  

light('Position', [-20 -70 0], 'Style', 'infinite');  
set_standard_plot_style();


%%


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



%% Plot 

figure; 
hold on;  
axis equal; 
view(3); 
grid on;

no_of_points = 42;
points = fibonacci_sphere(no_of_points);
radius = 130;
M = 10^(-9);

points = points * radius;

[xe, ye, ze] = sphere(10);  
sphere_radius = 1.5;
xe = xe * sphere_radius;
ye = ye * sphere_radius;
ze = ze * sphere_radius;

for ind = 1:no_of_points
    surf(xe + points(ind, 1), ye + points(ind, 2), ze + points(ind, 3), ...
        'FaceColor', [1, 0, 0], 'EdgeColor', 'k', 'FaceLighting', 'gouraud', 'LineWidth', 1.5);
end

lighting gouraud; 
material shiny;  
light('Position', [-20 -70 0], 'Style', 'infinite');  

% Try commenting this out if it's causing issues
% set_standard_plot_style();  

