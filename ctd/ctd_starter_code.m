%{
CEWA 590 CTD assignment starter code.

Requires the TEOS-10 Gibbs SeaWater toolbox available at:
https://www.teos-10.org/software.htm#1

%}

% Add TEOS-10 Gibbs SeaWater toolbox folder to path.  Update as needed.
addpath('gsw_matlab_v3_06_16')

% Read the CSV.
% WATER_QUALITY_FILE_PATH = 'your path here';  % e.g. './data/EIMContinuousDepthSeriesData_2024Apr08_229519.csv'
WATER_QUALITY_FILE_PATH = './data/EIMContinuousDepthSeriesData_2024Apr08_229519.csv';
ctd_all_data = readtable(WATER_QUALITY_FILE_PATH);

% Convert the Field_Collection_Date_Time to a UTC datetime.
ctd_all_data.Field_Collection_Date_Time = datetime( ...
    ctd_all_data.Field_Collection_Date_Time, ...
    'InputFormat','%m/%d/%Y %I:%M:%S %p', ...
    'TimeZone','UTC' ...
); 

% Convert table to a timetable. Cast text-based columns to strings.
ctd_all_data = table2timetable(ctd_all_data,'RowTimes', 'Field_Collection_Date_Time');
ctd_all_data.Result_Parameter_Name = string(ctd_all_data.Result_Parameter_Name);
ctd_all_data.Result_Value_Units = string(ctd_all_data.Result_Value_Units);
ctd_all_data.Depth_Value_Units = string(ctd_all_data.Depth_Value_Units);

% Get the station coordinates.
station_latitude = ctd_all_data.Calculated_Latitude_Decimal_Degrees_NAD83HARN(1);
station_longitude = ctd_all_data.Calculated_Longitude_Decimal_Degrees_NAD83HARN(1);

% Define start and end times to filter data. Update these as needed.
startTime = datetime('2017-01-01 00:00:00', 'TimeZone', 'UTC');
endTime = datetime('2017-12-31 00:00:00', 'TimeZone', 'UTC');

% Subset a year of data.
ctd_subset = ctd_all_data(timerange(startTime, endTime), :);

%% Example: plot salinity profile and color by month.

% Extract salinity from the dataset.
salinity = ctd_subset(ctd_subset.Result_Parameter_Name == 'Salinity', :);

figure
colormap(parula)
scatter( ...
    salinity.Result_Value, ...
    -salinity.Depth_Value, ...
    25,  ...
    month(salinity.Field_Collection_Date_Time), ...
    'filled' ...
)
cBar = colorbar;
cBar.Label.String = 'Month';
ylabel('Depth (' + salinity.Depth_Value_Units(1) + ')')
xlabel('Salinity (' + salinity.Result_Value_Units(1) + ')')

%% Example: usage of TEOS-10 GSW toolbox.
salinity.Reference_Salinity = gsw_SR_from_SP(salinity.Result_Value);

figure
colormap(parula)
scatter( ...
    salinity.Reference_Salinity, ...
    -salinity.Depth_Value, ...
    25,  ...
    month(salinity.Field_Collection_Date_Time), ...
    'filled' ...
)
cBar = colorbar;
cBar.Label.String = 'Month';
ylabel('Depth (' + salinity.Depth_Value_Units(1) + ')')
xlabel('Reference Salinity (g/kg)')
