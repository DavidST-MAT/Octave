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

% Divide the graphic into 2x2 subgraphs, first subgraph
subplot(2, 2, 1);
plot(time, force1_channel_1);
title('Force 1');
xlabel('Time(s)');
ylabel('Force(kN)');

subplot(2, 2, 2);  % second  subgraph
plot(time, force2_channel_2);
title('Force 2');
xlabel('Time(s)');
ylabel('Force(kN)');

subplot(2, 2, 3);  % third Untergrafik
plot(time, force3_channel_3);
title('Force 3');
xlabel('Time(s)');
ylabel('Force(kN)');

subplot(2, 2, 4);  % fourth subgraph
plot(time, total_force);
title('Overall result');
xlabel('Time(s)');
ylabel('Force(kN)');



% save diagram as png
outputFolderPath = 'C:\Users\DavidStrucken\Desktop\SalontaFinal\ModulRig_AluWabe2\Output\';
outputFileName = 'AluWabe2_force.png';
outputFilePath = fullfile(outputFolderPath, outputFileName);
saveas(gcf, outputFilePath, 'png');
