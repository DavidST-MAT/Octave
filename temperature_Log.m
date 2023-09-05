% Leeres Diagramm erstellen
figure;

% Verzeichnis von Skript und CSV-Dateien
aktuelles_verzeichnis = fileparts(mfilename('fullpath'));
ordnerpfad = fullfile(aktuelles_verzeichnis, '');

% Liste der CSV-Dateien im Ordner
dateiliste = dir(fullfile(ordnerpfad, '*.csv'));

% Legende für Diagramm mit Dateinamen vorbereiten
legende = cell(length(dateiliste), 1);

% Überschrift für csv-Datei vorbereiten
spalten_ueberschriften = cell(1, length(dateiliste));

% Initialisiere eine leere Matrix für die Daten
alle_daten = [];


% Schleife durch jede CSV-Datei
for i = 1:length(dateiliste)
    % Name der Datei
    dateiname = fullfile(ordnerpfad, dateiliste(i).name);

    % CSV-Datei einlesen (mit textscan ansonsten flasche Formatierung des Datums)
    daten = textscan(fopen(dateiname), '%s %s %f %s', 'Delimiter', ',');

    % Lesen der Temperaturwerte
    temperature = daten{3};

    % Finde Indizes der Zeilen, die die Bedingung an die Temperatur erfüllen
    valid_temperature = find(temperature >= -100 & temperature <= 200);

    % Behalte nur die Zeilen, die die Bedingung erfüllen
    temperatur = temperature(valid_temperature);
    zeitstempel_raw = daten{1};
    zeiti = zeitstempel_raw(valid_temperature);

    % Gib die gültigen Daten aus
    fprintf('Gültige Temperaturdaten aus Datei %s:\n', dateiname);
    disp(temperatur);
    fprintf('Zugehörige Zeitstempel aus Datei %s:\n', dateiname);
    disp(zeiti);

    % Bestimme Anzahl der Elemente im Array für die Zeit
    anzahl_datensaetze = numel(zeiti);

    % Die Zeitstempel formatieren
    for j = 1:anzahl_datensaetze
        zeitstempel_formatiert{j} = datestr(datenum(zeiti{j}, 'yyyy-mm-dd-HH:MM:SS:FFF'), 'HH:MM:SS');
    end
    disp(zeitstempel_formatiert);

    % Füge die Temperaturdaten zur Gesamtdatenmatrix hinzu
    alle_daten = [alle_daten, temperatur];

    % Aktuelle Zeit erfassen und formatieren
    current_time = now;
    current_str = datestr(current_time, 'HH:MM:SS');

    % Differenz der aktuellen Zeit mit den Zeitstempeln errechnen.
    d2s = 24*60;
    zeitstempel  = d2s*datenum(zeitstempel_formatiert);
    current  = d2s*datenum(current_str);
    value_time = current-zeitstempel;

    % Differenz in Stunden umwandeln für x-Achse
    value_hours = - (value_time / 60);

    % Y-Achse von -150 bis 250
    ylim([-150 250]);

    % X-Achse von -4 bis 0 Stunden
    xlim([-4 0]);

    % Achsenbeschriftungen
    xlabel('Hours');
    ylabel('°C');

    % Temperaturmesswert hinzufügen und Legende speichern
    plot(value_hours, temperatur);

    % Aktuellen Dateinamen bearbeiten für Legende und Überschrift der neuen csv-Tabelle
    [~, dateiname_ohne_erweiterung, ~] = fileparts(dateiname);
    parts = strsplit(dateiname_ohne_erweiterung, '_');
    desiredParts = parts(end-1:end);

    % Bearbeiteter Dateiname als Legende
    desiredString = strjoin(desiredParts, "_");
    legende{i} = desiredString;

    % Bearbeiteter Dateiname als Überschrift
    desiredString = [desiredString "[°C]"];
    spalten_ueberschriften{i} = desiredString;
    hold on;
end

% Diagramm ist fertig und Legende einfügen
hold off;
legend(legende);

% Speicherpfad und Dateiname für die PNG-Datei
%outputFolder = 'C:/Users/MAT-Solutions/Documents/Videoware/Results/';
outputFolder = 'C:/Users/DavidStrucken/Desktop/SalontaOuput/Temperatur/';
outputFileName = 'TemperatureLog.png';
outputFullPath = fullfile(outputFolder, outputFileName);

% Diagramm als PNG speichern
saveas(gcf, outputFullPath, 'png');

% Speicherpfad und Dateiname für die CSV-Datei
%outputCSVFolder = 'C:/Users/MAT-Solutions/Documents/Videoware/Results/';
outputCSVFolder = 'C:/Users/DavidStrucken/Desktop/SalontaOuput/Temperatur/';
outputCSVFileName = 'TemperatureData.csv';
outputCSVFullPath = fullfile(outputCSVFolder, outputCSVFileName);

% Schreiben Sie die Datenmatrix und Spaltenüberschriften in die CSV-Datei
header_row = strjoin(spalten_ueberschriften, ',');
dlmwrite(outputCSVFullPath, header_row, 'delimiter', '');
dlmwrite(outputCSVFullPath, alle_daten, '-append', 'delimiter', ',');
