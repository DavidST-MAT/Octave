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
gueltige_zeitstempel = [];

% Define current time
current_time = now;

% Loop through each CSV file
for i = 1:length(dateiliste)
  try
      temp = [];
      clear zeitstempel_formatiert;
      clear value_hours_alle;


      % file name
      dateiname = fullfile(ordnerpfad, dateiliste(i).name);

      % Read CSV file (using textscan, otherwise incorrect date formatting).
      daten = textscan(fopen(dateiname), '%s %s %f %s', 'Delimiter', ',');

      % "Reading the temperature values
      temperature = daten{3};
      zeitstempel_raw = daten{1};

      % Determine the number of elements in the array for time
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


      % Y-axis from -150 to 250
      ytick_locations = [-40, -20, 0, 20, 40, 60, 80, 100, 120];
      ylim([min(ytick_locations), max(ytick_locations)]);
      yticks(ytick_locations);


      % Define the desired X-axis tick locations
      xtick_locations = [-4, -3.5, -3, -2.5, -2, -1.5, -1, -0.5, 0];

      % Set the X-axis limits
      xlim([min(xtick_locations), max(xtick_locations)]);

      % Set the X-axis ticks to the desired locations
      xticks(xtick_locations);

      % Axis labels
      xlabel('Hours');
      ylabel('°C');


      if isempty(temp)
          disp('The variable is empty.');
      else

          % Find indices of the rows that satisfy the condition on temperature
          valid_temperature = find(temp >= -100 & temp <= 200);

          % Keep only the rows that satisfy the condition
          sorted_temperatur = temp(valid_temperature);


          sorted_time = gueltige_zeitstempel(valid_temperature);
          disp(gueltige_zeitstempel);
          disp(sorted_time);

          if isempty(zeitstempel_raw_combined)
            zeitstempel_raw_combined = -gueltige_zeitstempel;
          end

          temp(temp < -100 | temp > 200) = NaN;

          % Add the temperature data to the overall data matrix
          sorted_time = -sorted_time;
          plot(sorted_time, sorted_temperatur);

          % Add grid lines
          grid on;


          try
            alle_daten = [alle_daten; temp];
          catch
              fprintf("An error occurred.\n");
          end



           % Edit the current file name for the legend and header of the new CSV table
          [~, dateiname_ohne_erweiterung, ~] = fileparts(dateiname);
          parts = strsplit(dateiname_ohne_erweiterung, '_');
          desiredParts = parts(end-1:end);



          % Add the legend label
          desiredString = strjoin(desiredParts, "_");
          leg = [leg; desiredString];


          % Add the column header
          desiredString = [desiredString '[°C]'];
          spalten_ueberschriften = [spalten_ueberschriften, desiredString];

      end

      hold on;

    catch
        fprintf('Error processing data from file %s.\n', dateiliste(i).name);
    end
 end


hold off;

legend(leg);

umgewandelte_daten = transpose(alle_daten);

umgewandelte_zeit = transpose(zeitstempel_raw_combined);

umgewandelte_daten = [umgewandelte_zeit, umgewandelte_daten];


% Write the temperature data to the png-file
%outputFolder = 'C:/Users/MAT-Solutions/Documents/Videoware/Results/';
outputFolder = 'C:\Users\DavidStrucken\Desktop\SalontaFinal\TemperatureLog\Output';
outputFileName = 'TemperatureLog.png';
outputFullPath = fullfile(outputFolder, outputFileName);

% Save diagram as png
saveas(gcf, outputFullPath, 'png');
%print(outputFullPath, '-dpng');



%outputCSVFolder = 'C:/Users/MAT-Solutions/Documents/Videoware/Results/';
outputCSVFolder  = 'C:\Users\DavidStrucken\Desktop\SalontaFinal\TemperatureLog\Output';
outputCSVFileName  = 'TemperatureLog.csv';
outputCSVFullPath  = fullfile(outputCSVFolder, outputCSVFileName);

header = ['Time[h]', spalten_ueberschriften]
header = strjoin(header, ',');
fid = fopen(outputCSVFullPath, "w", "n", "windows-1252");
dlmwrite(fid, header, 'delimiter', '');
dlmwrite(fid , umgewandelte_daten, '-append', 'delimiter', ',');
fclose(fid);
