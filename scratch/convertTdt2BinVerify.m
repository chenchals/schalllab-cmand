monk = 'Cajal/';
session = 'Cajal-190315-104808';
%Session Cajal-190127-100227 --> minmax = [-0.00815744 0.00300563]
%Session Cajal-190127-111956 --> minmax = [-0.03991181 0.17693886], minDiff
%= [0.000000015832] dataSize: [32 403226608]
%Session Cajal-190315-104808 --> minmax = [-25.19417191 26.14355087],
%minDiff = [0.000015735626] dataSize: [36 535041070]
%Session Darwin-190724-094624 --> minmax = [-1.21864104 0.75560415],
%minDiff = [0.000000000029] dataSize: [32 443281408]


wavOrRsn = '*RSn1_*';%'*Wav1_*';%'*RSn1_*';
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
try
    fracSize = 1.0;
    sampleWindow = ceil(maxSamples*fracSize);
    sevData = T.readRaw(nChan,max(sampleWindow));
    sevDatMinMax = [min(min(sevData)) max(max(sevData))];
    d = abs(diff(sevData,1,1));
    minDiff = min(d(d>0));
catch me
    % Requested 32x403226608 (96.1GB) array exceeds maximum array size
    % preference. Creation of arrays greater than this limit ... error
    fprintf('\nLarge array requested... doing doing min-max for each channel\n');
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
end    

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






