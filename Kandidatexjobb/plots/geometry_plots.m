% % a = 98 (mm), b = 76 (mm), c = 116 (mm)
% a - x, b -y, c -z, 

freq = 0.8*10^(9);
omega = 2*pi*freq;
skin_er = permittivity_tissue(omega, "Skin (Dry)");
cortical_er = permittivity_tissue(omega, "Bone (Cortical)");
cancellous_er = permittivity_tissue(omega, "Bone (Cancellous)");
dura_er = permittivity_tissue(omega, "Dura");
fat_er = permittivity_tissue(omega, "Fat (Average Infiltrated)");
CSF_er = permittivity_tissue(omega, "Cerebro Spinal Fluid");
white_matter_er = permittivity_tissue(omega, "Brain (White Matter)");
grey_matter_er = permittivity_tissue(omega, "Brain (Grey Matter)");

% i (mm)
lengths = [16.9, 41.0, 3.9, 2.1, 1.6, 2.6, 2.1, 2.6, 2.1, 1.1]/1000;
materials = [grey_matter_er, white_matter_er, grey_matter_er, CSF_er, dura_er, cortical_er, cancellous_er, cortical_er, fat_er, skin_er];

%% Material plot

material_lengths = [0;cumsum(lengths(:))];
material_labels = {'Grey Matter', 'White Matter', 'Grey Matter', 'Cerebro Spinal Fluid', 'Dura', 'Cortical Bone', 'Cancellous Bone', 'Cortical Bone', 'Fat', 'Skin'}; 

colors = lines(length(materials)); 


figure;
hold on;


for ind = 1:(length(material_lengths)-1)
    x0 = material_lengths(ind);
    x1 = lengths(ind);
    yline(material_lengths(ind), '--', 'Color', 'Black', 'LineWidth', 1);
    color = tissue_colour(material_labels{ind});
    rectangle('Position', [-0.01, x0,0.06 , x1 ], 'FaceColor', color, 'EdgeColor', 'none');
end


set_standard_plot_style();
ylim([0 0.076])
xlim([0 0.05])


set(gca, 'YTick', []);  
title('Radial Distances along Y-axis in Ellipsoidal Brain Model [mm]');
grid on;
ax = gca;
ax.YAxis.FontSize = 9;

xticks([]);
xticklabels([]);

yticks(material_lengths);  % Set x-ticks to be at material boundaries
yticklabels(material_lengths * 1000); 
set(gca, 'XTickLabelRotation', 90);

%% 

function [x,y] =  ellipse(a, b)

angles = linspace(0, 2*pi, 100);

x = a * cos(angles);
y = b * sin(angles);

end

a = 98;
b = 76;
c = 116;

lengths_mm = [16.9, 41.0, 3.9, 2.1, 1.6, 2.6, 2.1, 2.6, 2.1, 1.1]; 
material_labels = {'Grey Matter', 'White Matter', 'Grey Matter', 'Cerebro Spinal Fluid', 'Dura', 'Cortical Bone', 'Cancellous Bone', 'Cortical Bone', 'Fat', 'Skin'}; 

labels_temp = flip(material_labels);

cumulative_b = [0, cumsum(flip(lengths_mm))];

figure; hold on; axis equal;
xlabel('Y [mm]'); ylabel('Z [mm]');


for ind = 1:length(cumulative_b)-1

    b1 = b - cumulative_b(ind);
    c1 = c - cumulative_b(ind);
    a1 = a - cumulative_b(ind);

    disp(tissue_colour(material_labels{ind}))

    [x, y] = ellipse(b1, c1);
    fill(x, y, hex2rgb(tissue_colour(labels_temp{ind})), 'EdgeColor', 'k', 'LineWidth', 1.5);
    
    hold on;
end

set_standard_plot_style();


%% Color legend 

% Define material labels
material_labels = {'Grey Matter', 'White Matter', 'Grey Matter', 'Cerebro Spinal Fluid', 'Dura', 'Cortical Bone', 'Cancellous Bone', 'Cortical Bone', 'Fat', 'Skin'}; 

% Create figure for legend
figure;
hold on;
axis off; % Remove axes for a clean legend look

% Number of materials
num_materials = length(material_labels);

% Loop through materials and create color boxes with labels
for ind = 1:num_materials
    color = tissue_colour(material_labels{ind});  % Get color for the material
    
    % Draw color box
    rectangle('Position', [0, num_materials - ind, 1, 1], 'FaceColor', color, 'EdgeColor', 'black');

    % Add text label

    mat_label = sprintf('%s (%.1f)', material_labels{ind}, lengths(ind) * 1000);



    text(1.2, num_materials - ind + 0.5,mat_label, 'FontSize', 16, 'VerticalAlignment', 'middle');
end

% Adjust plot limits
xlim([-0.5, 3]);
ylim([-1, num_materials]);

title('Material Legend', 'FontSize', 14);


function rgb = hex2rgb(hex)
    % Ensure the input is a valid hex color string
    if hex(1) == '#'
        hex = hex(2:end); % Remove '#'
    end
    % Convert hex to decimal and scale to [0,1] range
    rgb = [hex2dec(hex(1:2)), hex2dec(hex(3:4)), hex2dec(hex(5:6))] / 255;
end


%% TM - wave pic 


lengths = [1, 1, 1, 1];
material_lengths = [0;cumsum(lengths(:))];
material_labels =  {'White Matter', 'Cortical Bone', 'Grey Matter', 'Fat'};

colors = lines(length(materials)); 


figure;
hold on;


for ind = 1:(length(material_lengths)-1)
    x0 = material_lengths(ind);
    x1 = lengths(ind);
    xline(material_lengths(ind), 'Color', 'Black', 'LineWidth', 0.8);
    color = tissue_colour(material_labels{ind});
    rectangle('Position', [x0, 0 ,x1, 2 ], 'FaceColor', color, 'EdgeColor', 'none');
end


set_standard_plot_style();

%ylim([0 0.076])
%xlim([0 0.05])


set(gca, 'YTick', []);  
grid on;
ax = gca;
ax.YAxis.FontSize = 9;

xticks([]);
xticklabels([]);

%yticks(material_lengths);  % Set x-ticks to be at material boundaries
%yticklabels(material_lengths * 1000); 
%set(gca, 'XTickLabelRotation', 90);

%% 