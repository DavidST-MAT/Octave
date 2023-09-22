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


% read data from csv-file
try
    data = csvread(csv_filename, 23, 0);
catch
    error('Error reading data from CSV file.');
end


% Extract time and acceleration data
time = data(:, 1);
acceleration_channel_5 = data(:, 6);

% Define signal processing parameters (CFC60)
num_samples = 10041; % Number of samples
fs = 2000;
duration = num_samples / fs; % Calculate the duration
t = 0:(1/fs):(duration - 1/fs); % Create the time vector
order = 2; %Filter Order
f_cutoff = 100; %Cutoff Frequency

% Butterworth Filter
[b, a] = butter(order, f_cutoff/(fs/2));


% zero-phase filtering with filtfilt
try
    filtered_signal_zerophase = filtfilt(b, a, acceleration_channel_5);
catch
    error('Error applying Butterworth filter.');
end


% RAW-Signal plotten
figure;

plot(time, acceleration_channel_5);
grid on;
title('Raw');
xlabel('time[s]');
ylabel('acceleration[g]');

% save RAW as png
outputFolderPath = 'C:\Users\DavidStrucken\Desktop\SalontaFinal\ModulRig_AluWabe2\Output\';
outputFileName = 'ModulRig_AluWabe2_Acceleration_Raw.png';
outputFilePath = fullfile(outputFolderPath, outputFileName);
saveas(gcf, outputFilePath, 'png')

% save RAW as csv
outputFolderPath_csv = 'C:\Users\DavidStrucken\Desktop\SalontaFinal\ModulRig_AluWabe2\Output\';
outputFileName_csv = 'ModulRig_AluWabe2_Acceleration_Raw.csv';
outputFilePath_csv = fullfile(outputFolderPath_csv, outputFileName_csv)


acceleration_csv = [time, acceleration_channel_5];
header = {'time[h]', 'acceleration[g]'};
header = strjoin(header, ',');
dlmwrite(outputFilePath_csv, header, 'delimiter', '');
dlmwrite(outputFilePath_csv , acceleration_csv, '-append', 'delimiter', ',');



% CFC60-Signal plotten
figure;
plot(time, filtered_signal_zerophase);
grid on;
title('Filtered (CFC 60)');
xlabel('time[s]');
ylabel('acceleration[g]');


% save CFC60 as png
outputFolderPath = 'C:\Users\DavidStrucken\Desktop\SalontaFinal\ModulRig_AluWabe2\Output\';
outputFileName = 'ModulRig_AluWabe2_Acceleration_CFC60.png';
outputFilePath = fullfile(outputFolderPath, outputFileName);
saveas(gcf, outputFilePath, 'png')

% save CFC60 as csv
outputFolderPath_csv = 'C:\Users\DavidStrucken\Desktop\SalontaFinal\ModulRig_AluWabe2\Output\';
outputFileName_csv = 'ModulRig_AluWabe2_Acceleration_CFC60.csv';
outputFilePath_csv = fullfile(outputFolderPath_csv, outputFileName_csv)

acceleration_csv = [time, filtered_signal_zerophase];
header = {'time[h]', 'acceleration[g]'};
header = strjoin(header, ',');
dlmwrite(outputFilePath_csv, header, 'delimiter', '');
dlmwrite(outputFilePath_csv , acceleration_csv, '-append', 'delimiter', ',');
