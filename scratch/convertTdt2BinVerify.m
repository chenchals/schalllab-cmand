monk = 'Darwin/';
session = 'Darwin-190828-100527';
%Session Cajal-190127-100227 --> minmax = [-0.00815744 0.00300563]
%Session Cajal-190127-111956 --> minmax = [-0.03991181 0.17693886], minDiff
%= [0.000000015832] dataSize: [32 403226608]
%Session Cajal-190315-104808 --> minmax = [-25.19417191 26.14355087],
%minDiff = [0.000015735626] dataSize: [36 535041070]
%Session Darwin-190724-094624 --> minmax = [-1.21864104 0.75560415],
%minDiff = [0.000000000029] dataSize: [32 443281408]


%/scratch/subravcr/ksData/Darwin/Darwin-190828-100527/RSn1/*RSn1_ch1.sev
%Session Darwin-190828-100527/RSn1 --> minmax = [-0.00620832 0.01620482],
%minDiff = [0.000000015949] 
%Session Darwin-190828-100527 --> minmax = [-2.28813696 5.78291225],
%minDiff = [0.000000000015] 

wavOrRsn = '*Wav1_*';%'*Wav1_*';%'*RSn1_*';
ops.dataDir = ['ksData/' monk session]; 
ops.tdtFilePattern=[wavOrRsn '.sev'];
ops.fbinary = ['ksDataProcessed/' monk session '/' session '.bin'];

%% read TDT wave files
fileSuffix = ops.tdtFilePattern; %'*Wav1_*.sev';
ds = fullfile(ops.dataDir,fileSuffix);
fprintf('Using files with pattern : %s\n',fileSuffix);
T = interface.IDataAdapter.newDataAdapter('sev',ds,'rawDataScaleFactor',1)

%% verify
nChan = T.nChannelsTotal;
maxSamples = T.dataSize(2);
sevDatMinMax = [];
minDiff =[];
tempMinMax = [];
tempMinDiff =[];

fprintf (' Doing channel No ...');
for ii = 1:nChan
    fprintf(repmat('\b', 1, 3));
    fprintf(' %02d',ii)
    sevData = T.readChannel(ii);
    tempMinMax(ii,:) = [min(min(sevData)) max(max(sevData))];
    d = abs(diff(sevData));
    tempMinDiff(ii,1) = min(d(d>0));
end
fprintf('\n');
sevDatMinMax = [min(min(tempMinMax)) max(max(tempMinMax))];
minDiff = min(min(tempMinDiff));


fprintf('Session %s --> minmax = [%0.8f %0.8f], minDiff = [%0.12f]\n',session,sevDatMinMax(1), sevDatMinMax(2),minDiff);

%% Convert TDT 2 bin
%convertTdt2Bin(ops,32)


%% read converted Binary file
nChan = T.nChannelsTotal;

B = memmapfile(ops.fbinary,'Format','int16');
binData = reshape(B.Data,nChan,[]);

chanNo = 12;
nSamples = 1000;
bData = binData(chanNo,1:nSamples);

sData = T.readChannel(chanNo);


%% Verify Kaleb's bin files with the sev files
klSev10 = 'ksData/Darwin/Darwin-190724-094624/SchallLab1-160315-114049_Darwin-190724-094624_Wav1_Ch10.sev';
klBin10 = 'ksData/Darwin/Darwin-190724-094624_bin/Chan10.bin';
klBin10Mem = memmapfile(klBin10,'Format','int16')

klSev10Mem = memmapfile(klSev10,'Offset', 40,'Format','single')

%% Verify wav and RSn file data....
fs = 24414.0625;
wavCh11 = 'ksData/Darwin/Darwin-190828-100527/SchallLab1-160315-114049_Darwin-190828-100527_Wav1_Ch1.sev';
rsnCh11 = 'ksData/Darwin/Darwin-190828-100527/RSn1/Unnamed_RSn1_ch11.sev';
wavMemFile = memmapfile(wavCh11,'Offset', 40, 'Format','single');
rsnMemFile = memmapfile(rsnCh11,'Offset', 40, 'Format','single');

rsnFlitZ = doFilter(rsnMemFile.Data(1:10000));

figure
yyaxis('left')
plot(wavMemFile.Data(1:10000))
yyaxis('right')
plot(rsnMemFile.Data(1:10000))
set(gcf,'Name','Wav(left) and Rsn(right) raw data')

figure
yyaxis('left')
plot(rsnMemFile.Data(1:10000))
yyaxis('right')
plot(rsnFlitZ(1:10000))
set(gcf,'Name','Rsn raw(left) and Rsn filtered(right) data')



plotPowerSpectrum(wavMemFile.Data(1:10000),fs)
set(gcf,'Name','Wav Data')
plotPowerSpectrum(rsnMemFile.Data(1:10000),fs)
set(gcf,'Name','RSn Data')
plotPowerSpectrum(rsnMemFile.Data(1:10000),fs)
set(gcf,'Name','RSn Filtered Data')



