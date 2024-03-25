%% CEWA590 HW6 - ADV starter code

% This code is meant as a guide to some of the steps needed to load and 
% process the ADV data
% This will probably be most useful to Matlab users, but the commented text
% still might be useful as a general guide for Python, etc. users.

% Suneil Iyer, 2022

%% Q1 - loading and plotting

% load data from mat file
load(['/Users/suneiliyer/Dropbox/cewa590/TTT_ADV_Feb2011_phasedespiked.mat']);
%change path name to your folder with the data

%or, use 'ncread' to load the data from NetCDF files

%time in seconds
t=(1:1:length(u))/32; %32Hz obs - so this is time in sec

% plot the raw velocity data as a function of time in hours

figure;
subplot(3,1,1);
plot(t/3600,u); %u velocities (I divide by 3600 to get time in hours) 
% and the same for v and w...

xlabel('hour');

%% Q2 - ensemble averaging and Q3 - calculating turbulent spectra and Q4 - verify Parseval's theorem

seconds=[1]; %number of seconds you want your ensemble length to be *CHANGE THIS
ensleng=32*seconds; %32 Hz data, so 32*'seconds' is approximately a 'seconds' length ensemble
%%YOU NEED TO CHANGE THE ABOVE VALUE to whatever ensemble length you feel is
%appropriate for these data. The value I initially include here corresponds to a
%1-second ensemble, which is way too short to be reasonable!

%initialize variables
u_eavg=[]; t_eavg=[]; U_PSD=[];

for i=1:1:length(t)/ensleng %loop through and get every ensemble
    ix1=((i-1)*ensleng)+1; %define starting index of ensemble
    ix2=i*ensleng; %define ending index of ensemble
    u_eavg(i)=nanmean(u(ix1:ix2)); %ensemble average u (east-west) velocity
    % and do the same for v and w
    t_eavg(i)=nanmean(t(ix1:ix2)); %ensemble average time vector
    
    u_stdev(i) = nanstd(u(ix1:ix2)); %calculate standard deviation (for Q4)
    

    %calculate a turbulent spectrum for each ensemble of u, v, and w using pwelch
    
    %For the u component...
    [U_pxx,f] = pwelch(u(ix1:ix2),[],[],[],32); %32 Hz data
    %the three "blank" fields in the above line correspond to the window
    %length of the spectrum, the overlap between segments, and the number
    %of Fourier transform points. You may need to specify these fields if appropriate
    %Type "help pwelch" to learn about the default values.
    
    U_PSD(:,i) = U_pxx;
    
    
    %To integrate for question 4, you can use the "trapz" function, a
    %trapezoidal integration approximation - an example is below.
    %If you want to use this, you need to uncomment the below three lines
    %AND specify the starting and ending indices to not include
    %noise/non-sensible data
    
%     startix=[];
%     endix=[];
%     integ_u(i)=trapz(f(startix:endix),U_pxx(startix:endix));

    %And now do the same data processing for the v and w components...
end


%% plotting

%plot the raw and ensemble averaged data
figure;
subplot(3,1,1);
hold;
plot(t/3600,u); %raw data (hours vs velocity)
plot(t_eavg/3600,u_eavg,'linewidth',2); %ensemble averaged data
hold off;
xlabel('hour');

% plot the turbulent spectra
figure;
subplot(3,1,1);
hold;
for i=1:1:width(U_PSD) %loop through each spectrum defined in the previous section
    plot(f,U_PSD(:,i)); %plot power spectral density as a function of frequency
end
hold off;
xlabel('frequency [Hz]');
ylabel('PSD [m^2 s^{-2} Hz^{-1}]');
title('U');
set(gca,'Yscale','log'); %use a log scale - this is how spectra are typically presented
set(gca,'Xscale','log');
