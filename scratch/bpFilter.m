function [filtData] = bpFilter(inData)
%BPFILTER Summary of this function goes here
hpc     = 5000;             % high pass cutoff
lpc     = 300;              % low pass cutoff
fo      = 6;                % filter order
fs      = 24414.0625;       % sampling frequency
%data in colFormat (samples x channels)
% transpose row to cols
dat = double(inData)';
hWn = hpc / (fs/2);
[ bwb, bwa ] = butter( fo, hWn, 'high' );
filtData = filtfilt( bwb, bwa, dat );
lWn = lpc / (fs/2);
[ bwb, bwa ] = butter( fo, lWn, 'low' );
filtData = filtfilt( bwb, bwa, filtData);
filtData = filtData';

end

