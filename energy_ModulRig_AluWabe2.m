%file_path = 'miniTest.csv';
file_path = 'ModulTest.csv'

% Modul für Butterworth Filter
pkg load signal

% Daten ab Zeile 24 einlesen
data = csvread(file_path, 23, 0);

%Channel Description,Force-01,Force-02,Force-03,Angle-04,Acceleration-05,
time = data(:, 1);
angle_channel_4 = data(:, 5);


% Berechnung der Winkelgeschwindigkeit (Δα/Δt)
delta_t = diff(time);  % Zeitdifferenzen zwischen den Datenpunkten
delta_alpha = diff(angle_channel_4);  % Differenzen zwischen den Winkelsignalen
omega = delta_alpha ./ delta_t;  % Winkelgeschwindigkeit

clear kinetic_energy_values;

% Beispielwert für m
mass = 0.256;         % Mass in kilograms
% Schleife über die Werte von omega und berechnen der kinetischen Energie
for i = 1:length(omega)
    disp(omega(i));
    kinetic_energy_values(i) = (1/2) * mass * omega(i)^2;

end




% Generate Signal
fs = 2000; %Sampling Frequency
t = 0:1/fs:1; 
order = 2; %Filter Order
f_cutoff = 60; %Cutoff Frequency


% Butterworth Filter
[b, a] = butter(order, f_cutoff/(fs/2));

% Zero-phase filtern mit filtfilt
filtered_signal_zerophase = filtfilt(b, a, kinetic_energy_values);



% Signal plotten
figure;

%subplot(2, 1, 1);
%plot(time(2:end), kinetic_energy_values);
%hold on;
%plot(time, data);
%title('Energy');
%xlabel('Time (s)');
%ylabel('Amplitude');

%legend('Enery', 'Angle');

%subplot(2,1,2);
%plot(time(2:end), filtered_signal_zerophase);
%title('Zero-Phase Filtered Signal');
%xlabel('Time (s)');
%ylabel('Amplitude');


% Linkes Achsenobjekt für die Energie
ax1 = subplot(2, 1, 1);
plot(ax1, time(2:end), kinetic_energy_values, 'b');
xlabel(ax1, 'Time(s)');
ylabel(ax1, 'Energy', 'Color', 'b');

% Rechtes Achsenobjekt für den Winkel
ax2 = axes('Position', get(ax1, 'Position'), 'XAxisLocation', 'top', 'YAxisLocation', 'right', 'Color', 'none');
line(time, angle_channel_4, 'Parent', ax2, 'Color', 'r');
ylabel(ax2, 'Angle', 'Color', 'r');

% Legende hinzufügen (optional)
%legend(ax1, 'Energie', 'Location', 'northwest');
%legend(ax2, 'Winkel', 'Location', 'northeast');


subplot(2,1,2);
plot(time(2:end), filtered_signal_zerophase, 'g--');
title('Zero-Phase Filtered Signal');
xlabel('Time(s)');
ylabel('Amplitude');


% Diagramm als PNG speichern
saveas(gcf, "Output/ModulRig_AluWabe2.png", 'png');
