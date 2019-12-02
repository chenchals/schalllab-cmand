
ops.dataDir = 'ksData/Darwin/Darwin-190724-094624';
ops.tdtFilePattern='*Wav1_*.sev';
ops.fbinary = 'ksDataProcessed/Darwin/Darwin-190724-094624/Darwin-190724-094624.bin';
%% Convert TDT 2 bin
%convertTdt2Bin(ops)


%% read TDT wave files
fileSuffix = ops.tdtFilePattern; %'*Wav1_*.sev';
ds = fullfile(ops.dataDir,fileSuffix);
fprintf('Using files with pattern : %s\n',fileSuffix);
T = interface.IDataAdapter.newDataAdapter('sev',ds,'rawDataScaleFactor',1);

%% read converted Binary file
B = memmapfile(ops.fbinary,'Format','int16');

%% verify
nChan = T.nChannelsTotal;
maxSamples = T.dataSize(2);
sampleWindow = [1 1000];

sevData = T.readRaw(nChan,max(sampleWindow));

binData = reshape(B.Data,nChan,[]);

%% read bin data from Kaleb
fn = 'C:/scratch/subravcr/ksData/Darwin/Darwin-190724-094624_bin/Chan1.bin';

K = memmapfile(fn,'Format','int16');

binDataK = K.Data(1:1000);








