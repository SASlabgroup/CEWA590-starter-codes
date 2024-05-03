%% CEWA590 Homework 4 - ADCP, Starter Code

% This code is meant as a guide to some of the initial steps needed to
% complete the first two questions of the homework- specifically, with
% loading the data, calculating ensemble averages, and plotting the data.
% This will probably be most useful to Matlab users, but the commented text
% still might be useful as a general guide for Python, etc. users.

% Suneil Iyer, 2022
% J. Thomson, Apr 2024: update variable names and add tidal plots

clear all, close all

%load from mat file
load('~/Downloads/T3_NodulePoint_May2010_ADCP_cleaned.mat');


%% Q1

figure(1)
%plot horizontal speed as a function of both time and depth with pcolor
pcolor(time, height_above_seafloor, speed);
%remove grid lines
shading('interp');
%change colorbar scale
caxis([0 2]);
%show actual dates/times on the x axis rather than "datenum" values
datetick('x');
hold on
% add the water depth to show the tidal signal above the instrument
plot(time, waterdepth, 'k-','linewidth',2)
set(gca,'YLim',[0 25])
ylabel('Height above seafloor [m]')

%% Q2

%An example for using 8 second bins for the first (z=3.21 m) bin...

binleng=16; %2 Hz data, so 16 points = 8 seconds
for i=1:binleng:length(speed)-binleng %loop through and get every 16th point 
    count=((i-1)/binleng)+1; %bin number
    ix1=i; %starting index of bin
    ix2=i+(binleng-1); %ending index of bin
    hv08(count)=nanmean(speed(1,ix1:ix2)); %8 sec binned average horizontal velocity
    time08(count)=nanmean(time(ix1:ix2)); %8 sec binned average time
    dir08(count)=nanmean(direction(1,ix1:ix2)); %8 sec binned average direction
    stdev08(count) = nanstd(speed(1,ix1:ix2)); %calculate standard deviation
    stder08(count) = stdev08(count)/sqrt(binleng); %calculate standard error from standard deviation
end

%Do the same for 3 other bin lengths...

%Now plot the data. The below example plots horizontal velocity
figure(2)
subplot(2,2,1);
plot(time08,hv08);
datetick('x');
title('8s');
ylabel('Horizontal speed [m s^{-1}]');

%Similarly, plot the other parameters...