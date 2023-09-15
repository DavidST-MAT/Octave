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
    kinetic_energy_values(i) = (1/2) * mass * omega(i)^2;
end


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

% Left-axis object for energy
ax1 = gca; % Get the current axes
plot(ax1, time(2:end), kinetic_energy_values, 'b');
xlabel(ax1, 'Time(s)');
ylabel(ax1, 'Energy(J)', 'Color', 'b');

% Right-axis object for angle
ax2 = axes('Position', get(ax1, 'Position'), 'XAxisLocation', 'top', 'YAxisLocation', 'right', 'Color', 'none');
line(time, angle_channel_4, 'Parent', ax2, 'Color', 'r');
ylabel(ax2, 'Angle(°)', 'Color', 'r');

% Legende hinzufügen (optional)
%legend(ax1, 'Energy', 'Location', 'northwest');
%legend(ax2, 'Angle', 'Location', 'northeast');

% save diagram as png
outputFolderPath = 'C:\Users\DavidStrucken\Desktop\SalontaFinal\ModulRig_AluWabe2\Output\';
outputFileName = 'ModulRig_AluWabe2_Raw.png';
outputFilePath = fullfile(outputFolderPath, outputFileName);
saveas(gcf, outputFilePath, 'png');



% Plot the filtered signal
figure;
plot(time(2:end), filtered_signal_zerophase, 'g--');
title('Zero-Phase Filtered Signal CFC60');
xlabel('Time(s)');
ylabel('Energy(J)');

% Save diagram as png
outputFolderPath = 'C:\Users\DavidStrucken\Desktop\SalontaFinal\ModulRig_AluWabe2\Output\';
outputFileName = 'ModulRig_AluWabe2_CFC60.png';
outputFilePath = fullfile(outputFolderPath, outputFileName);
saveas(gcf, outputFilePath, 'png');
