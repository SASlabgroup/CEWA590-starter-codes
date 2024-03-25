%% CEWA590 Cruise data starter code

% This code is meant as a guide to some of the steps needed to load the
% data that we collected on the R/V Carson. 
% This will probably be most useful to Matlab users, but the commented text
% still might be useful as a general guide for Python, etc. users.

% Suneil Iyer, 2022

clear all;

%Path name to RV Carson data - modify as needed to your folder with the
%data and the cruise day that you want to analyze data from
folder = './3May2022/';
% if you are working on 5May2022, change the path above
% ** and also find-and-replace "20220503" for "20220505" in the rest of this script **

%% SWIFT

%load SWIFT data- it's easiest to just load the mat file
%containing all of the data (this is for one drifter, SWIFT 20, only - repeat this
%procedure to also load data from SWIFT 21)
load([folder 'SWIFTs/SWIFT20_03May2022/SWIFT20_03May2022.mat']); %loads as structure 'SWIFT'


%extract data from a structure
time=extractfield(SWIFT,'time'); %time
airtemp=extractfield(SWIFT,'airtemp'); %air temperature
%and continue to use the same procedure for all of the other variables of
%interest...


%% WireWalker

%CTD data
WW_CTD=importdata([folder 'WireWalker/WireWalker_CTD_03May2022_data.txt']);
%see the 'metadata' text file for information on what the columns are
%measurements of

%Nortek Signature data
WW_Sig=load([folder 'WireWalker/WireWalker_Sig1000_03May2022_file3.mat']);
%and do the same for other data files (one per hour, I think)


%% RV Carson ship

% Navigational
NAV=importdata([folder '/CarsonData/NAV/Primary-GGA_20220503-150533.Raw']);

%Position
LAT=importdata([folder '/CarsonData/NAV/DD-LAT-VALUE-DRV_20220503-150533.Raw']);
LON=importdata([folder '/CarsonData/NAV/DD-LONG-DRV-DRV_20220503-150533.Raw']);

%wind speed and direction 
WIND=importdata([folder '/CarsonData/MET/TRU-DRV_20220503-150533.Raw']);

%air temp, relative humidity, and air pressure
TRHP=importdata([folder '/CarsonData/MET/Primary-MET-XDR_20220503-150533.Raw']);

% air temperature in C and F
TEMP=importdata([folder '/CarsonData/MET/Primary-XDR-temp-C-to-F-DRV_20220503-150533.Raw']);

%TSG data from the ship (temperature, conductivity, salinity)
TSG=importdata([folder '/CarsonData/TSG/TSG-RAW_20220503-150533.Raw']);

%CTD data from rosette

%the raw data are stored in ".hex" files. Requires additional processing as
%per the Seabird website to decode these in a format readable by Matlab

%ADCP data

%depth bins
Z=load([folder 'CarsonData/ADCP/proc/wh300/contour/allbins_depth.mat']);
%u and v velocities
U=load([folder 'CarsonData/ADCP/proc/wh300/contour/allbins_u.mat']);
V=load([folder 'CarsonData/ADCP/proc/wh300/contour/allbins_v.mat']);


%Note: some of the above raw data are structured as one column cell arrays. We can use
%'strsplit' to split and a loop to extract data. An example for relative humidity:

%split the cell array based on the delimiter ","
TRHP_2 = cellfun(@(x) strsplit(x, ','), TRHP, 'UniformOutput', false);

RH=[]; %initialize variable
for i=1:1:length(TRHP_2) %loop through the length of the array
    RH(i)= str2double(TRHP_2{i, 1}{1, 9}); %define RH at each point using the 9th cell (we can see this by looking closer at the new array 'TRHP_2'
end
%and do the same for other variables of interest...

%we can use the same procedure to get times from the cell array. We can
%define the date base on the datestring in the data, e.g.,
%for the first column
MATLABdatenumber=datenum([TRHP_2{1, 1}{1, 1} ' ' TRHP_2{1, 1}{1, 2}],'mm/dd/yyyy HH:MM:SS.fff');
%and then loop through like the RH example...

