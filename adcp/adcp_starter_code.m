%% CEWA590 Homework 4 - ADCP, Starter Code

% This code is meant as a guide to some of the initial steps needed to
% complete the first two questions of the homework- specifically, with
% loading the data, calculating ensemble averages, and plotting the data.
% This will probably be most useful to Matlab users, but the commented text
% still might be useful as a general guide for Python, etc. users.

% Suneil Iyer, 2022



%load from mat file
load('/Users/suneiliyer/Dropbox/cewa590/T3_NodulePoint_May2010_ADCP_cleaned.mat');

%OR, load data from netcdf file
ncname='T3_NodulePoint_May2010_ADCP_cleaned.nc'; %should be your path/file name

    %load variables using ncread, e.g.,
    time=ncread(ncname,'time');
    horizontalvel=ncread(ncname,'horizontalvel');
    z=ncread(ncname,'z');


%% Q1

%plot horizontal velocity as a function of both time and depth with pcolor
pcolor(time,z,horizontalvel);
%remove grid lines
shading('interp');
%change colorbar scale
caxis([0 3]);
%show actual dates/times on the x axis rather than "datenum" values
datetick('x');

%% Q2

%An example for using 8 second bins for the first (z=3.21 m) bin...

binleng=16; %2 Hz data, so 16 points = 8 seconds
for i=1:binleng:length(horizontalvel)-binleng %loop through and get every 16th point 
    count=((i-1)/binleng)+1; %bin number
    ix1=i; %starting index of bin
    ix2=i+(binleng-1); %ending index of bin
    hv08(count)=nanmean(horizontalvel(1,ix1:ix2)); %8 sec binned average horizontal velocity
    time08(count)=nanmean(time(ix1:ix2)); %8 sec binned average time
    dir08(count)=nanmean(direction(1,ix1:ix2)); %8 sec binned average direction
    stdev08(count) = nanstd(horizontalvel(1,ix1:ix2)); %calculate standard deviation
    stder08(count) = stdev08(count)/sqrt(binleng); %calculate standard error from standard deviation
end

%Do the same for 3 other bin lengths...

%Now plot the data. The below example plots horizontal velocity
figure;
subplot(2,2,1);
plot(time08,hv08);
datetick('x');
title('8s');
ylabel('Horizontal velocity [m s^{-1}]');

%Similarly, plot the other parameters...