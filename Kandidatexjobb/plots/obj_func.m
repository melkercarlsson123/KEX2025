clf;

a = 98;
b = 76;
c = 116;

lengths_mm = [16.9, 41.0, 3.9, 2.1, 1.6, 2.6, 2.1, 2.6, 2.1, 1.1]; 
material_labels = {'Grey Matter', 'White Matter', 'Grey Matter', 'Cerebro Spinal Fluid', 'Dura', 'Cortical Bone', 'Cancellous Bone', 'Cortical Bone', 'Fat', 'Skin'}; 

labels_temp = flip(material_labels);

cumulative_b = [0, cumsum(flip(lengths_mm))];

hold on; axis equal;
xlabel('Y [mm]'); ylabel('Z [mm]');


for ind = 1:length(cumulative_b)-1

    b1 = b - cumulative_b(ind);
    c1 = c - cumulative_b(ind);
    a1 = a - cumulative_b(ind);

    disp(tissue_colour(material_labels{ind}))

    [x, y] = ellipse(a1, c1);
    fill(x, y, hex2gray(tissue_colour(labels_temp{ind})), 'EdgeColor', 'none');
    %set(h, 'FaceAlpha', 0.7);  % Adjust alpha (0 = fully transparent, 1 = solid)

    
    hold on;
end



    
[x, y] = ellipse(a, c);
h = fill(x, y, [1, 1, 1], 'EdgeColor', 'none');
set(h, 'FaceAlpha', 0.3);  % Adjust alpha (0 = fully transparent, 1 = solid)




[xc, yc] = circle(10);
circle_colour = [0.75, 0.05, 0.1];

fill(xc, yc, circle_colour, 'EdgeColor', 'k', 'LineWidth', 2);


[xe, ye] = ellipse(a, c);
plot(xe, ye, 'k', 'LineWidth', 2); 

hold on; axis equal;
xlabel('X [mm]'); ylabel('Z [mm]');



set_standard_plot_style();


%% 

function rgb = hex2rgb(hex)
    % Ensure the input is a valid hex color string
    if hex(1) == '#'
        hex = hex(2:end); % Remove '#'
    end
    % Convert hex to decimal and scale to [0,1] range
    rgb = [hex2dec(hex(1:2)), hex2dec(hex(3:4)), hex2dec(hex(5:6))] / 255;
end

function gray = hex2gray(hex)
    rgb = hex2rgb(hex);

    val = mean(rgb);

    gray = rgb * (val)^(0.3);
end


function [x,y] =  ellipse(a, b)

angles = linspace(0, 2*pi, 100);

x = a * cos(angles);
y = b * sin(angles);

end

function [x, y] = circle(a)

angles = linspace(0, 2*pi, 100);

x = a * cos(angles);
y = a * sin(angles);

end


