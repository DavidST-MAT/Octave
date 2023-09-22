% Modul for signal processing package
pkg load signal

% Argumente abrufen
args = argv();
if length(args) < 1
    error("CSV-Dateiname als Argument erforderlich.");
end

% CSV-Datei einlesen (erstes Argument)
%csv_filename = args{1};
csv_filename = 'ModulTest.csv';
%csv_filename = 'test.csv';

% Read data from csv-file
try
    data = csvread(csv_filename, 23, 0);
catch
    error('Error reading data from CSV file.');
end


% Extract time and angle data
time = data(:, 1);
angle_channel_4 = data(:, 5);


% Calculation of angular velocity (Δα/Δt)
try
    delta_t = diff(time);
    delta_alpha = diff(angle_channel_4);
    omega = delta_alpha ./ delta_t;
catch
    error('Error calculating angular velocity.');
end

clear kinetic_energy_values;


% Mass for AluWabe2 in kg
mass = 0.256;

% Calculate kinetic energy
for i = 1:length(omega)
    omega_rad = deg2rad(omega(i))
    kinetic_energy_values(i) = (1/2) * mass * omega_rad^2;
end

kinetic_test = transpose(kinetic_energy_values);
disp(kinetic_test);

% Define signal processing parameters (CFC60)
num_samples = 10041; % Number of samples
fs = 2000;
duration = num_samples / fs; % Calculate the duration
t = 0:(1/fs):(duration - 1/fs); % Create the time vector;
order = 2; %Filter Order
f_cutoff = 100; %Cutoff Frequency


% Butterworth Filter
[b, a] = butter(order, f_cutoff/(fs/2));

% Zero-phase filtering with filtfilt
try
    filtered_signal_zerophase = filtfilt(b, a, kinetic_energy_values);
catch
    error('Error applying Butterworth filter.');
end



% Signal plotten
figure;

plot(time(2:end), omega);
grid on;
title('angular velocity');
xlabel('time[s]');
ylabel('angular velocity[deg/s]');

% save RAW as png
outputFolderPath = 'C:\Users\DavidStrucken\Desktop\SalontaFinal\ModulRig_AluWabe2\Output\';
outputFileName = 'ModulRig_AluWabe2_AngularVelocity_Raw.png';
outputFilePath = fullfile(outputFolderPath, outputFileName);
saveas(gcf, outputFilePath, 'png');

% save RAW as csv
outputFolderPath_csv = 'C:\Users\DavidStrucken\Desktop\SalontaFinal\ModulRig_AluWabe2\Output\';
outputFileName_csv = 'ModulRig_AluWabe2_AngularVelocity_Raw.csv';
outputFilePath_csv = fullfile(outputFolderPath_csv, outputFileName_csv)


omega_csv = [time(2:end), omega];
header = {'time[h]', 'angular velocity[deg/s]'};
header = strjoin(header, ',');
dlmwrite(outputFilePath_csv, header, 'delimiter', '');
dlmwrite(outputFilePath_csv , omega_csv, '-append', 'delimiter', ',');



% Signal plotten
figure;

ax1 = gca; % Get the current axes
h1 = plot(time(2:end), kinetic_energy_values, 'g', time(2:end), filtered_signal_zerophase, "r--");
xlabel(ax1, 'time[s]');
ylabel(ax1, 'energy[J]');

ax2 = axes('Position', get(ax1, 'Position'), 'XAxisLocation', 'bottom', 'YAxisLocation', 'right', 'Color', 'none');
h2 = line(time, angle_channel_4, 'Parent', ax2, 'Color', 'b');
ylabel(ax2, 'angle[deg]');
grid on;
title('Raw');

legend([h1(1), h1(2), h2], {'raw', 'CFC60', 'angle'}, 'Location', 'east');
legend boxoff;


% save RAW as png
outputFolderPath = 'C:\Users\DavidStrucken\Desktop\SalontaFinal\ModulRig_AluWabe2\Output\';
outputFileName = 'ModulRig_AluWabe2_Energy_Raw.png';
outputFilePath = fullfile(outputFolderPath, outputFileName);
saveas(gcf, outputFilePath, 'png');

% save RAW as csv
outputFolderPath_csv = 'C:\Users\DavidStrucken\Desktop\SalontaFinal\ModulRig_AluWabe2\Output\';
outputFileName_csv = 'ModulRig_AluWabe2_Energy_Raw.csv';
outputFilePath_csv = fullfile(outputFolderPath_csv, outputFileName_csv)


kinetic_energy_values_trans = transpose(kinetic_energy_values);
filtered_signal_zerophase_trans = transpose(filtered_signal_zerophase);
energy_csv = [time(2:end), kinetic_energy_values_trans, angle_channel_4(2:end), filtered_signal_zerophase_trans];
header = {'time[h]', 'energy[J]', 'angle[deg]', 'filtered CFC60 [J]'};
header = strjoin(header, ',');
dlmwrite(outputFilePath_csv, header, 'delimiter', '');
dlmwrite(outputFilePath_csv , energy_csv, '-append', 'delimiter', ',');





figure;

% Left-axis object for energy
ax1 = gca; % Get the current axes
plot(ax1, time(2:end), filtered_signal_zerophase, 'r');
grid on;
title('Filtered (CFC 60)');
xlabel(ax1, 'time[s]');
ylabel(ax1, 'energy[J]', 'Color', 'r');

% Right-axis object for angle
ax2 = axes('Position', get(ax1, 'Position'), 'XAxisLocation', 'bottom', 'YAxisLocation', 'right', 'Color', 'none');
line(time, angle_channel_4, 'Parent', ax2, 'Color', 'b');
ylabel(ax2, 'angle[deg]', 'Color', 'b');


% Save CFC60 as png
outputFolderPath = 'C:\Users\DavidStrucken\Desktop\SalontaFinal\ModulRig_AluWabe2\Output\';
outputFileName = 'ModulRig_AluWabe2_Energy_CFC60.png';
outputFilePath = fullfile(outputFolderPath, outputFileName);
saveas(gcf, outputFilePath, 'png');

% save CFC60 as csv
outputFolderPath_csv = 'C:\Users\DavidStrucken\Desktop\SalontaFinal\ModulRig_AluWabe2\Output\';
outputFileName_csv = 'ModulRig_AluWabe2_Energy_CFC60.csv';
outputFilePath_csv = fullfile(outputFolderPath_csv, outputFileName_csv)

filtered_signal_zerophase_trans = transpose(filtered_signal_zerophase);
filtered_signal = [time(2:end), filtered_signal_zerophase_trans, angle_channel_4(2:end)];
header = {'time[h]', 'energy[J]', 'angle[deg]'};
header = strjoin(header, ',');
dlmwrite(outputFilePath_csv, header, 'delimiter', '');
dlmwrite(outputFilePath_csv , filtered_signal, '-append', 'delimiter', ',');
