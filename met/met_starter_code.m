%{
The following code assumes the data have been copied from the UW Atmospheric
Sciences website and converted to plain text (.txt).  This can be done as
follows:

1. Navigate to https://atmos.washington.edu/cgi-bin/list_uw.cgi, choose a
   day, and click "Data".
2. Select **all** of the text (`Cmd + A` on Mac or `Ctrl + A` on Windows).
   This includes the header with the date.
3. Paste the text into an editor and save it as plain text (`.txt`)
   - On Mac: Open TextEdit. By default, TextEdit creates Rich-Text Format
     files (.rtf). To create plain-text, click `Format > Make Plain Text`
     before saving the file as a `.txt`.
   - On Windows: Open Notepad. Plain text should be the default.
  
First, update the variable `MET_DATA_PATH` with the path to your data.

This procedure omits units.  Refer to the original file for varibale units.
%}

MET_DATA_PATH = './data/met_data.txt';  %TODO: your path here

% Specify the input options to readtable: DataLines is the start of the
% data and VariableNamesLine is the line containing the names.
opts = detectImportOptions(MET_DATA_PATH);
opts.DataLines = 7;
opts.VariableNamesLine = 4;
opts.Whitespace = ' ';
metData = readtable(MET_DATA_PATH, opts);

% Add a column which represents seconds since the start of the day.
metData.Seconds = seconds(metData.Time);

% Plot wind speed versus time as a line plot.
figure
plot(metData.Time, metData.Speed, 'color', 'k')
xlabel('Hour of UTC day')
ylabel('Wind speed (knot)')
ylim([0 20])
% uncomment below to save or from window select: File > Save As...
% saveas(gcf, 'wind_speed_plot.png')

% Or, as a scatter plot (line plots can be misleading, since gaps in data
% are connected).
figure
scatter(metData.Time, metData.Speed, 10, 'k', 'filled')
xlabel('Hour of UTC day')
ylabel('Wind speed (knot)')
ylim([0 20])
% uncomment below to save or from window select: File > Save As...
% saveas(gcf, 'wind_speed_scatter.png')

% MATLAB has a very useful groupsummary function which allows us to collect
% data into groups and aggregate them using a summary statistic.  This
% example groups the 'Time' column by hour. For more information, see:
% https://www.mathworks.com/help/matlab/matlab_prog/grouped-calculations-in-tables-and-timetables.html
statistic = 'mean';  % try median?
metDataHourly = groupsummary(metData, 'Time', 'hour', statistic);

% Convert the mean seconds back to a duration.
metDataHourly.mean_Time = duration(0, 0, metDataHourly.mean_Seconds);

% Plot wind speed versus time with hourly averages
figure
plot(metData.Time, metData.Speed, 'color', 'k')
hold on
plot(metDataHourly.mean_Time, metDataHourly.mean_Speed, 'color', 'r', 'LineWidth', 2)
xlabel('Hour of UTC day')
ylabel('Wind speed (knot)')
ylim([0 20])
legend('raw data', 'hourly mean')
% uncomment below to save or from window select: File > Save As...
% saveas(gcf, 'wind_speed_hourly_means.png')  

