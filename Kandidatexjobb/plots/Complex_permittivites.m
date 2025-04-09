clear all; 
global eps0
eps0 = 8.8541878128e-12;    % vacuum permittivity


function [omega,eps_an] = eps_func(freq_an, tissue)

omega = freq_an*2*pi;
eps_an = permittivity_tissue(omega, tissue); 


end


%% 

materials = {"Dura", "Bone (Cancellous)", "Cerebro Spinal Fluid"};

% 



%{

Materials:
"Skin (Dry)");
"Bone (Cortical)");
"Bone (Cancellous)");
"Dura");
"Fat (Average Infiltrated)");
"Cerebro Spinal Fluid");
"Brain (White Matter)");
"Brain (Grey Matter)");

Material Lables:
{'White Matter', 'Grey Matter', 'Cerebro Spinal Fluid', ...
         'Dura', 'Cancellous Bone', 'Cortical Bone', 'Fat', 'Skin'}, ...
%}

material_labels = {'Dura', 'Cancellous Bone', 'Cerebro Spinal Fluid'};
clf;

freq_an = logspace(2, 11, 1000);

lw = 1.8;   % line width of plot line
fs = 14;    % font size of plot texts
blue = [0 0.4470 0.7410];       % RBG for blue
red = [0.8500 0.3250 0.0980];   % RBG for blue

figure();

% set latex as default interpreter

grid on;

hold on;
plot_handles = []; % Store plot handles for legend
legend_labels = {}; % Store legend text

for ind = 1:length(materials)
    disp(materials(ind))

    tissue = materials{ind};
    color = hex2rgb(tissue_colour(material_labels{ind}));

    [omega, eps_an] = eps_func(freq_an, tissue);
   

    h1 = plot(freq_an, real(eps_an), 'color', color, 'Linewidth', lw);
    h2 = plot(freq_an, imag(eps_an), 'color', color, 'Linewidth', lw, 'LineStyle', '--');

    plot_handles = [plot_handles, h1, h2];
    legend_labels = [legend_labels, [tissue, ' - Real'], [tissue, ' - Imag']];
end


set(gca, 'XScale', 'log');
set(gca, 'YScale', 'log');
xlabel("Frequency (Hz)", 'fontsize', fs);
ylabel("$\epsilon_m$", 'fontsize', fs);


legend(plot_handles, legend_labels, 'fontsize', fs, 'TextColor', 'black');

set_standard_plot_style();


%% 

function rgb = hex2rgb(hex)
    if hex(1) == '#'
        hex = hex(2:end); % Remove '#'
    end
    rgb = [hex2dec(hex(1:2)), hex2dec(hex(3:4)), hex2dec(hex(5:6))] / 255;
end
