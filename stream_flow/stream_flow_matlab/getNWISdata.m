% matlab starter code to scrape USGS stream gage data from NWIS server
%
% J. Thomson, Apr 2024

gageno='12200500'; % Skagit
%gageno='12061500'; % Skykomish

OUTFILENAME = websave('streamdata.csv',['https://waterdata.usgs.gov/nwis/measurements?site_no=' gageno '&agency_cd=USGS&format=rdb_expanded']);


%% read data, dealing with timestamps that may or may not have hh:mm:ss included

headerlines = 17;
linenum = 0;
counter = 0;
tline = 0;

fid = fopen(OUTFILENAME);

while tline~=-1
    tline = fgetl(fid);
    linenum = linenum + 1;
    if length(tline)>6 && linenum > headerlines
        counter = counter+1;
        thisdata = textscan(tline,'%s%s%s%s%s%s%s%s%s%s%s%s$s$s');%,'delimiter','\t');
        datestring = char(thisdata{4});
        if length(char(thisdata{5}))~=8% all(char(thisdata{5}) == 'Yes') | all(char(thisdata{5}) == 'No')  % no hh:mm:ss, so columns are shifted
            timestring = '00:00:00';
            if ~isempty(str2num(char(thisdata{8})))
                gageheight(counter) = str2num(char(thisdata{8}));
            else
                gageheight(counter) = NaN;
            end
            if ~isempty(str2num(char(thisdata{9})))
                discharge(counter) = str2num(char(thisdata{9}));
            else
                discharge(counter) = NaN;
            end
        else
            timestring = char(thisdata{5});
            if ~isempty(str2num(char(thisdata{10})))
                gageheight(counter) = str2num(char(thisdata{10}));
            else
                gageheight(counter) = NaN;
            end
            if ~isempty(str2num(char(thisdata{10})))
                discharge(counter) = str2num(char(thisdata{11}));
            else
                discharge(counter) = NaN;
            end
        end
        timestamp(counter) = datenum(str2num(datestring(1:4)), str2num(datestring(6:7)), str2num(datestring(9:10)), ...
                str2num(timestring(1:2)), str2num(timestring(4:5)),str2num(timestring(7:8)) );
    end
end

fclose(fid)

%% Quality control

gageheight (gageheight > 50 ) = NaN;

%% Save output
save(['MatlabData_gage' gageno '.mat'],'gageheight','discharge','timestamp')

%% time series plot

figure(1)
subplot(2,1,1)
plot(timestamp, gageheight), datetick
ylabel('Gage Height (units?)')
title(gageno)

subplot(2,1,2)
plot(timestamp, discharge), datetick
ylabel('Discharge (units?)')

print('-dpng',['Timeseries_' gageno '.png'])

%% scatter plot

[year month day hour minute second] = datevec(timestamp);

figure(2), clf
scatter(gageheight, discharge, 10, year,'filled')
axis([0 inf 0 inf])
title(gageno)
ylabel('Discharge (units?)')
xlabel('Gage Height (units?)')
cbar = colorbar; cb.Label.String = 'year';

%% rating curve, latking the log of each side to enable a linear fit

gooddata = find( gageheight>0 & discharge>0);
offset = 0;

P = polyfit( log( gageheight(gooddata) - offset ), log(discharge(gooddata)), 1 );  % first order polynomial fit... y = mx + b

G = linspace(0,max(gageheight),10);
Q = exp(P(2)) .* (G - offset ).^P(1);

hold on % continue with previous figure
ratingcurve = plot(G,Q,'k','linewidth',2)

print('-dpng',['RatingCurve_' gageno '.png'])
