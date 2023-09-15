% Empty Diagram
figure;

% Define the path to the folder containing CSV files
aktuelles_verzeichnis = fileparts(mfilename('fullpath'));
ordnerpfad = fullfile(aktuelles_verzeichnis, '');

% List all CSV files in the folder
dateiliste = dir(fullfile(ordnerpfad, '*.csv'));

% Check if the folder is empty
if isempty(dateiliste)
    error('No csv-files found in the current folder.');
end


% Initialize variables
alle_daten = [];
leg = {};
spalten_ueberschriften = {};
zeitstempel_raw_combined = [];

% Define current time
current_time = now;

% Loop through each CSV file
for i = 1:length(dateiliste)
  try
      temp = [];
      clear zeitstempel_formatiert;
      clear value_hours_alle;
      clear gueltige_zeitstempel;
      gueltige_zeitstempel = [];


      % Name der Datei
      dateiname = fullfile(ordnerpfad, dateiliste(i).name);

      % CSV-Datei einlesen (mit textscan, ansonsten falsche Formatierung des Datums)
      daten = textscan(fopen(dateiname), '%s %s %f %s', 'Delimiter', ',');

      % Lesen der Temperaturwerte
      temperature = daten{3};
      zeitstempel_raw = daten{1};

      % Bestimme Anzahl der Elemente im Array für die Zeit
      anzahl_datensaetze_alle = numel(zeitstempel_raw);

      for j = 1:anzahl_datensaetze_alle
          zeitstempel_formatiert = datenum(zeitstempel_raw{j}, 'yyyy-mm-dd-HH:MM:SS:FFF');
          time_difference_hours = abs(current_time - zeitstempel_formatiert) * 24;

          if time_difference_hours >= 4

              disp('Die maximale Zeitdifferenz beträgt mindestens 4 Stunden.');
          else
              gueltige_zeitstempel = [gueltige_zeitstempel, time_difference_hours];
              temp = [temp, temperature(j)];

              disp('Die maximale Zeitdifferenz beträgt weniger als 4 Stunden.');
          end
      end


      % Y-Achse von -150 bis 250
      ytick_locations = [-40, -20, 0, 20, 40, 60, 80, 100, 120];
      ylim([min(ytick_locations), max(ytick_locations)]);
      yticks(ytick_locations);


      % Define the desired X-axis tick locations
      xtick_locations = [-4, -3.5, -3, -2.5, -2, -1.5, -1, -0.5, 0];

      % Set the X-axis limits
      xlim([min(xtick_locations), max(xtick_locations)]);

      % Set the X-axis ticks to the desired locations
      xticks(xtick_locations);

      % Achsenbeschriftungen
      xlabel('Hours');
      ylabel('°C');


      if isempty(temp)
          disp('The variable is empty.');
      else

          % Finde Indizes der Zeilen, die die Bedingung an die Temperatur erfüllen
          valid_temperature = find(temp >= -100 & temp <= 200);

          % Behalte nur die Zeilen, die die Bedingung erfüllen
          sorted_temperatur = temp(valid_temperature);


          sorted_time = gueltige_zeitstempel(valid_temperature);
          disp(gueltige_zeitstempel);
          disp(sorted_time);

          % Fügen Sie "zeitstempel_raw" zum kombinierten Array hinzu
          if isempty(zeitstempel_raw_combined)
            zeitstempel_raw_combined = {-gueltige_zeitstempel};
            disp(zeitstempel_raw_combined);
          end

          temp(temp < -100 | temp > 200) = NaN;

          % Füge die Temperaturdaten zur Gesamtdatenmatrix hinzu
          %alle_daten{i} = temperatur;
          sorted_time = -sorted_time;
          plot(sorted_time, sorted_temperatur);
          % Add grid lines
          grid on;


          try
            alle_daten = [alle_daten; temp];
          catch
              fprintf("An error occurred.\n");
          end



           % Aktuellen Dateinamen bearbeiten für Legende und Überschrift der neuen csv-Tabelle
          [~, dateiname_ohne_erweiterung, ~] = fileparts(dateiname);
          parts = strsplit(dateiname_ohne_erweiterung, '_');
          desiredParts = parts(end-1:end);



          % Add the legend label
          desiredString = strjoin(desiredParts, "_");
          leg = [leg; desiredString];


          % Add the column header
          desiredString = [desiredString "[°C]"];
          spalten_ueberschriften = [spalten_ueberschriften, desiredString];

      end

      hold on;
      disp('!!!!!!!!!!!!!!')

    catch
        fprintf('Error processing data from file %s.\n', dateiliste(i).name);
    end
 end


hold off;

legend(leg);

umgewandelte_daten = transpose(alle_daten);
disp(umgewandelte_daten);

gueltige_zeitstempel = -gueltige_zeitstempel;
umgewandelte_zeit = transpose(gueltige_zeitstempel);
disp(umgewandelte_zeit);

umgewandelte_daten = [umgewandelte_zeit, umgewandelte_daten];


% Write the temperature data to the png-file
%outputFolder = 'C:/Users/MAT-Solutions/Documents/Videoware/Results/';
outputFolder = 'C:\Users\DavidStrucken\Desktop\SalontaFinal\TemperatureLog\Output';
outputFileName = 'TemperatureLog.png';
outputFullPath = fullfile(outputFolder, outputFileName);

% Save diagram as png
saveas(gcf, outputFullPath, 'png');
%print(outputFullPath, '-dpng');




outputCSVFolder  = 'C:\Users\DavidStrucken\Desktop\SalontaFinal\TemperatureLog\Output';
outputCSVFileName  = 'TemperatureLog.csv';
outputCSVFullPath  = fullfile(outputCSVFolder, outputCSVFileName);

header = ['Time[h]', spalten_ueberschriften]
header = strjoin(header, ',');
dlmwrite(outputCSVFullPath, header, 'delimiter', '');
%dlmwrite(outputCSVFullPath, zeitstempel_raw_combined, '-append', 'delimiter', ',');
dlmwrite(outputCSVFullPath , umgewandelte_daten, '-append', 'delimiter', ',');
