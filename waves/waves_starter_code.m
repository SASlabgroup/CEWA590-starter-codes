%% CEWA590 HW7 - Wave Data starter code

% This code is meant as a guide to some of the steps needed to load, plot, 
% and process the wave data
% This will probably be most useful to Matlab users, but the commented text
% still might be useful as a general guide for Python, etc. users.

% Suneil Iyer, 2022

%% Extracting the relevant data

%first, download data from the CDIP site. You can download in any format
%you want, but I downloaded a NetCDF file from the "HTTPServer" (note that
%this downloads way more data than we actually need, so I truncated before
%doing the analysis.

%path name to the file that you downloaded - you need to change this to
%your folder and file name
ncname='/Users/suneiliyer/Dropbox/cewa590/179p1_xy.nc';

% Type "ncdisp(ncname)" into the command line to see what data we have in
%the netcdf file, learn what the variable names mean, and to view the metadata.

%load some of the relevant variables
starttime=ncread(ncname,'xyzStartTime'); %'seconds since 1970-01-01 00:00:00 UTC'
samplerate=ncread(ncname,'xyzSampleRate'); %in hertz

Z=ncread(ncname,'xyzZDisplacement'); %vertical displacement; see metadata for details
N=ncread(ncname,'xyzXDisplacement'); %north displacement; see metadata for details
W=ncread(ncname,'xyzYDisplacement'); %west displacement; see metadata for details

full_length=length(Z); %full length of the time segment (saving this for the purpose of computing a time series

%%%%%
%depending on what data you loaded, the above may contain much more data
%than you need... so, I am truncating and just taking the most recent 30 minutes (you can take
%any 30 minute segment you want). 

%If you just downloaded 30 minutes of data, you can comment these lines

%number of points/indices we want
points=round(1800*samplerate); %number of seconds in 30min * Hz

ix= full_length-points:1:full_length; %get indices corresponding to the last 30 minutes of data

Z=Z(ix); %only retain data for those indices
N=N(ix);
W=W(ix);
%%%%%

%we have the start time and sample rate, so we can make a time vector
%this makes a vector in matlab time ('time') and number of seconds
%('seconds')
time=[]; seconds=[]; %initialize
for i=1:1:length(Z)
    time(i)=datenum(1970,1,1,0,0,starttime) + datenum(0,0,0,0,0,ix(1)/samplerate) + datenum(0,0,0,0,0,i/samplerate); %starttime + sample rate*count
    seconds(i)=i/samplerate; %sample rate*count
end

%% Q1 plot the raw data

figure;

%a time series of vertical displacement

plot(time,Z);
datetick('x');
ylabel('m');

%You should also plot horizontal displacement!!!

%using the plot, you can make a guess of what the significant wave height
%is

%% Q2 calculate SWH

%calculate the significant wave height from standard deviation

%Use the function 'std' in Matlab to calculate

%% Q3 calculate wave spectra

%We can use pwelch to calculate the spectra. As with the ADV assignment,
%the three "blank" fields in the below line correspond to the window
%length of the spectrum, the overlap between segments, and the number
%of Fourier transform points. You may need to specify these fields if
%appropriate, or the defaults might be reasonable.
%Type "help pwelch" to learn about the default values.

%Note that we only have a 30 minute segment of data, so not long enough that
%we would need to do ensemble averaging like we did in the ADCP assignment. 
%Though, we still divide into windows for statistical robustness.

[pxx,f] = pwelch(Z,[],[],[],samplerate); %'samplerate' Hz data
%pxx is PSD
%f is frequency

%Now plot the spectra. It's generally easier to show spectra in log
%space...
plot(f,pxx);
set(gca,'Yscale','log');
set(gca,'Xscale','log');
%and add axis labels and units...

%% Q4 Calculating SWH from integral

%To integrate for question 4, you can use the "trapz" function, a
%trapezoidal integration approximation - an example is below.
%You could change the starting and ending indices if you have unrealistic 
%data, but that may not be necessary here...
    
startix=[1];
endix=[length(pxx)];
integral=trapz(f(startix:endix),pxx(startix:endix));

%And calculate SWH from 'integral'

%% Q5 Spectra of horizontal components and check factor

%Calculate spectra for the two horizontal components as done for the vertical component above
%If using this code, this might just involve cutting and pasting some of
%the above, but be careful with variable names...

%%%%%

%Once you have all of the spectra, calculate the "check factor". This is 
%simply the ratio of horizontal to vertical displacement spectra...

%So if 'pxx' is your vertical spectrum and 'pxx_N' and 'pxx_E' are your horizontal
%spectrum, then checkfactor=(pxx_N + pxx_E)./(pxx);

