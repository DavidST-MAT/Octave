% Modul for Butterworth Filter
pkg load signal

% Path for test and production folder
% path = 'ModulTest.csv'
% path= 'C:\DTS\SLICEWare\1.08.0868\Data\ModulTest\'
% path= 'C:\Users\DavidStrucken\Desktop\SalontaFinal\ModulRig_AluWabe2'

% actual path
ordner_pfad = 'C:\Users\DavidStrucken\Desktop\SalontaFinal\ModulRig_AluWabe2';

% list all files in actual folder
dateien = dir([ordner_pfad, '/*.csv']);

% Check, if folder is empty
if isempty(dateien)
    error('Keine CSV-Dateien im aktuellen Ordner gefunden.');
end

% read name of csv-file
csv_datei = dateien(1).name;

% read data from csv-file
data = csvread(csv_datei, 23, 0);


%Channel Description,Force-01,Force-02,Force-03
time = data(:, 1);
force1_channel_1 = data(:, 2);
force2_channel_2 = data(:, 3);
force3_channel_3 = data(:, 4);


% Force_res
sum_force = force1_channel_1 + force2_channel_2 + force3_channel_3;



% Signal plotten
figure;

% Divide the graphic into 2x2 subgraphs, first subgraph
subplot(2, 2, 1);
plot(time, force1_channel_1);
title('Force 1');
xlabel('Time(s)');
ylabel('Amplitude');

subplot(2, 2, 2);  % second  subgraph
plot(time, force2_channel_2);
title('Force 2');
xlabel('Time(s)');
ylabel('Amplitude');

subplot(2, 2, 3);  % third Untergrafik
plot(time, force3_channel_3);
title('Force 3');
xlabel('Time(s)');
ylabel('Amplitude');

subplot(2, 2, 4);  % fourth subgraph
plot(time, sum_force);
title('Overall result');
xlabel('Time(s)');
ylabel('Amplitude');



% save diagram as png
saveas(gcf, "Output/sum_force.png", 'png');
