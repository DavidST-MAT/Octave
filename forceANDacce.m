%file_path = 'miniTest.csv';
file_path = 'ModulTest.csv'

% Modul für Butterworth Filter
pkg load signal

% Daten ab Zeile 24 einlesen
data = csvread(file_path, 23, 0);

%Channel Description,Force-01,Force-02,Force-03,Angle-04,Acceleration-05,
time = data(:, 1);
force1_channel_1 = data(:, 2);
force2_channel_2 = data(:, 3);
force3_channel_3 = data(:, 4);
angle_channel_4 = data(:, 5);
acceleration_channel_5 = data(:, 6);


% STEP 1 - F_res
sum_force = force1_channel_1 + force2_channel_2 + force3_channel_3;


% Signal plotten
figure;

subplot(2, 2, 1);  % Teile die Grafik in 2x2 Untergrafiken auf, erste Untergrafik
plot(time, force1_channel_1);
title('Force 1');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2, 2, 2);  % Zweite Untergrafik
plot(time, force2_channel_2);
title('Force 2');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2, 2, 3);  % Dritte Untergrafik
plot(time, force3_channel_3);
title('Force 3');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2, 2, 4);  % Vierte Untergrafik
plot(time, sum_force);
title('Overall result');
xlabel('Time (s)');
ylabel('Amplitude');


% Save as png
save("Output/sum_force.png", "sum_force", "-ascii");
% Diagramm als PNG speichern
saveas(gcf, "Output/sum_force.png", 'png');





% STEP 2 - Acceleration
fs = 2000;
t = 0:1/fs:1;
order = 2;
f_cutoff = 60;

% Butterworth Filter
[b, a] = butter(order, f_cutoff/(fs/2));

% Zero-phase filtern mit filtfilt
filtered_signal_zerophase = filtfilt(b, a, acceleration_channel_5);

% Signal plotten
figure;

subplot(2,1,1);
plot(time, acceleration_channel_5);
title('Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2,1,2);
plot(time, filtered_signal_zerophase);
title('Zero-Phase Filtered Signal');
xlabel('Time (s)');
ylabel('Amplitude');


% Save as png
save("Output/acceleration.png", "sum_force", "-ascii");
% Diagramm als PNG speichern
saveas(gcf, "Output/acceleration.png", 'png');
