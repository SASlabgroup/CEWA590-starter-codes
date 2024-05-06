%% CEWA590 Cruise data starter code

% This code is meant as a guide to some of the steps needed to load the
% data that we collected on the R/V Carson. 
% This will probably be most useful to Matlab users, but the commented text
% still might be useful as a general guide for Python, etc. users.

% Suneil Iyer, 2022
% J. Thomson 2024

clear all;

%Path name to RV Carson data - modify as needed to your folder with the
%data and the cruise day that you want to analyze data from
folder = './';


%% RV Carson winds
%wind speed and direction (true, derived winds)
WIND = importdata([folder '/SCS/SAMOS/TRU-DRV_20240501-144327.Raw']);
for i=1:length(WIND.textdata)
    TrueWind(i).time = datenum([WIND.textdata{i,1} ' ' WIND.textdata{i,2}]);
    TrueWind(i).speed = WIND.data(i,1);
    TrueWind(i).direction = WIND.data(i,2);
end

figure, 
subplot(2,1,1)
plot([TrueWind.time ], [TrueWind.speed ])
datetick
ylabel('Wind Speed')
subplot(2,1,2)
plot([TrueWind.time ], [TrueWind.direction ])
datetick
ylabel('Wind Direction')



%% RV Carson ship

% % Navigational
% NAV=importdata([folder '/CarsonData/NAV/Primary-GGA_20220503-150533.Raw']);
% 
% %Position
% LAT=importdata([folder '/CarsonData/NAV/DD-LAT-VALUE-DRV_20220503-150533.Raw']);
% LON=importdata([folder '/CarsonData/NAV/DD-LONG-DRV-DRV_20220503-150533.Raw']);
% 
% %air temp, relative humidity, and air pressure
% TRHP=importdata([folder '/CarsonData/MET/Primary-MET-XDR_20220503-150533.Raw']);
% 
% % air temperature in C and F
% TEMP=importdata([folder '/CarsonData/MET/Primary-XDR-temp-C-to-F-DRV_20220503-150533.Raw']);
% 
% %TSG data from the ship (temperature, conductivity, salinity)
% TSG=importdata([folder '/CarsonData/TSG/TSG-RAW_20220503-150533.Raw']);
% 
% %CTD data from rosette
% 
% %the raw data are stored in ".hex" files. Requires additional processing as
% %per the Seabird website to decode these in a format readable by Matlab
% 
% %ADCP data
% 
% %depth bins
% Z=load([folder 'CarsonData/ADCP/proc/wh300/contour/allbins_depth.mat']);
% %u and v velocities
% U=load([folder 'CarsonData/ADCP/proc/wh300/contour/allbins_u.mat']);
% V=load([folder 'CarsonData/ADCP/proc/wh300/contour/allbins_v.mat']);
% 
% 
% %Note: some of the above raw data are structured as one column cell arrays. We can use
% %'strsplit' to split and a loop to extract data. An example for relative humidity:
% 
% %split the cell array based on the delimiter ","
% TRHP_2 = cellfun(@(x) strsplit(x, ','), TRHP, 'UniformOutput', false);
% 
% RH=[]; %initialize variable
% for i=1:1:length(TRHP_2) %loop through the length of the array
%     RH(i)= str2double(TRHP_2{i, 1}{1, 9}); %define RH at each point using the 9th cell (we can see this by looking closer at the new array 'TRHP_2'
% end
% %and do the same for other variables of interest...
% 
% %we can use the same procedure to get times from the cell array. We can
% %define the date base on the datestring in the data, e.g.,
% %for the first column
% MATLABdatenumber=datenum([TRHP_2{1, 1}{1, 1} ' ' TRHP_2{1, 1}{1, 2}],'mm/dd/yyyy HH:MM:SS.fff');
% %and then loop through like the RH example...

