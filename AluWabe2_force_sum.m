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


% Extract time and force data
time = data(:, 1);
force1_channel_1 = data(:, 2);
force2_channel_2 = data(:, 3);
force3_channel_3 = data(:, 4);


% Force_res
total_force = force1_channel_1 + force2_channel_2 + force3_channel_3;

% Signal plotten
figure;

plot(time, total_force);
grid on;
title('Sum Force');
xlabel('time[s]');
ylabel('force[kN]');


% save diagram as png
outputFolderPath = 'C:\Users\DavidStrucken\Desktop\SalontaFinal\ModulRig_AluWabe2\Output\';
outputFileName = 'ModulRig_AluWabe2_SumForce_Raw.png';
outputFilePath = fullfile(outputFolderPath, outputFileName);
saveas(gcf, outputFilePath, 'png');


% save diagram as csv
outputFolderPath_csv = 'C:\Users\DavidStrucken\Desktop\SalontaFinal\ModulRig_AluWabe2\Output\';
outputFileName_csv = 'ModulRig_AluWabe2_SumForce_Raw.csv';
outputFilePath_csv = fullfile(outputFolderPath_csv, outputFileName_csv)

sum_force_csv = [time, total_force];
header = {'time[h]', 'force[kN]'};
header = strjoin(header, ',');
dlmwrite(outputFilePath_csv, header, 'delimiter', '');
dlmwrite(outputFilePath_csv , sum_force_csv, '-append', 'delimiter', ',');
