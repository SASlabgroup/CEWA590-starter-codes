% matlab starter code to scrape USGS stream gage data from NWIS server
%
% J. Thomson, Apr 2024

gageno='12200500';

OUTFILENAME = websave('streamdata.csv',['https://waterdata.usgs.gov/nwis/measurements?site_no=' gageno '&agency_cd=USGS&format=rdb_expanded'])

data = importdata(OUTFILENAME);