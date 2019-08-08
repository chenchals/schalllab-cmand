loadDir = 'dataProcessed/Joule/cmanding/ephys/TESTDATA/In-Situ/Joule-190731-121704';
load([loadDir '/Spikes.mat'])
load([loadDir '/Events.mat'])


TaskInfos = struct2table(TaskInfos);
taskInfoVars=TaskInfos.Properties.VariableNames';

taskVars = fieldnames(Task);
% Find spikes that happen in the window around specic times

%% SDFs all trials where target is ON
trlIdx = find(~isnan(Task.Target_));

selTrls = struct();
selTrls.allTrlsTargOn = trlIdx;
evtName ='Target_';
outAllTrls.(evtName) = plotAligned(selTrls, Task,evtName,DSP01a);

%% Low vs Hi Reward for all trials
trlsHiRwdLogical = TaskInfos.UseRwrdDuration==320;
trlsLoRwdLogical = TaskInfos.UseRwrdDuration==80;

%% Low vs Hi Reward for GoCorrectTrials
trlsHiRwdGoCorrectIdx = find(trlsHiRwdLogical==1 & TaskInfos.IsGoCorrect==1);
trlsLoRwdGoCorrectIdx = find(trlsLoRwdLogical==1 & TaskInfos.IsGoCorrect==1);

%% Low vs Hi Reward aligned on Saccade_
events2Align = {'Target_','Saccade_','AudioStart_','JuiceStart_'};
selTrls = struct();
selTrls.hiReward = trlsHiRwdGoCorrectIdx;
selTrls.loReward = trlsLoRwdGoCorrectIdx;
for ii = 1: numel(events2Align)
    evtName = events2Align{ii};
    out.(evtName) = plotAligned(selTrls, Task,evtName,DSP01a);
end

%% Cancelled trials are STOP trials that are CORRECT
selTrls = struct();
cancelTrls = find(TaskInfos.IsCancel==1);
selTrls.cancelled = cancelTrls;
for ii = 1: numel(events2Align)
    evtName = events2Align{ii};
    out3.(evtName) = plotAligned(selTrls,Task,evtName,DSP01a);
end

%% Low vs Hi Reward for STOP trials (Saccade_ ==> NogoEarlySaccade_, NogoSaccadePreSsd_,NogoSaccadePostSsd_, NogoLateSaccade_, 

trlsHiRwdNogoIdx = find(trlsHiRwdLogical==1 & TaskInfos.TrialType==1 );% & isnan(Task.JuiceEnd_));
trlsLoRwdNogoIdx = find(trlsLoRwdLogical==1 & TaskInfos.TrialType==1);% & isnan(Task.JuiceEnd_));

events2Align = {'Target_','NogoEarlySaccade_', 'NogoSaccadePreSsd_','NogoSaccadePostSsd_', 'NogoLateSaccade_','AudioStart_','JuiceStart_'};
selTrls = struct();
selTrls.hiRewardNogo = trlsHiRwdNogoIdx;
selTrls.loRewardNogo = trlsLoRwdNogoIdx;
for ii = 1: numel(events2Align)
    evtName = events2Align{ii};
    out.(evtName) = plotAligned(selTrls, Task,evtName,DSP01a);
end

uniqUserSSDs = unique(TaskInfos.UseSsdVrCount(TaskInfos.TrialType==1));
figure
histogram((Task.StopSignal_ -Task.Target_),100)
figure
histogram(TaskInfos.StopSignalDuration(Task.StopSignal_>0),100)

%% draw Waveforms for selection
selTrls = struct();
conditions = {'hiReward','loReward'};
condColor = {'b','r'};
selTrls.(conditions{1}) = trlsHiRwdGoCorrectIdx;
selTrls.(conditions{2}) = trlsLoRwdGoCorrectIdx;

events2Align = {'Target_','Saccade_','AudioStart_','JuiceStart_'};

evtName = events2Align{3};
condName = conditions{2};
wavColor = condColor{2};
alignWin = [18 22]; %in window 315-325 ms after alignment(hiReward-juice aligned)

cellId = 'DSP01a';
wavId = 'WAV01a';

eval(['spkT = ' cellId ';']);
eval(['wav = ' wavId ';']);

evtTimes = Task.(evtName)(selTrls.(condName));
spkTimesIdxInWin = cell2mat(arrayfun(@(x) find(spkT >= x+alignWin(1) & spkT < x+alignWin(2)),...
                            evtTimes,'UniformOutput',false));
% Plot selected waveforms
selWaves = wav(spkTimesIdxInWin,:);
nPoints = size(selWaves,2);
nWaves = size(selWaves,1);
% make a y vector
yVals = selWaves;
yVals(:,end+1) = nan(nWaves,1);
yVals = yVals'; yVals = yVals(:);
% make a x vector
xVals = repmat([1:nPoints NaN],1,nWaves);
figure
plot(xVals,yVals,wavColor)
title({sprintf('Waveforms for cellId [%s], waveformId [%s] aligned on [%s]',cellId,wavId,evtName)
       sprintf('Reward [%s] In aligned time window [%s] nWaveforms [%i]',condName,num2str(alignWin,'%i '),nWaves)},...
       'Interpreter', 'none','color',wavColor)


                        
%%
% verify if you have already run the plot above and saved the variable to
% out 
nSpksInWin = numel(spkTimesIdxInWin);
at = cell2mat(out.(evtName).(condName).spkTimesAligned')';
mSpksInWin = sum(at>=alignWin(1) & at<alignWin(2));
assert(nSpksInWin==mSpksInWin,sprintf('No of spikes are different [%i, / %i]', nSpksInWin,mSpksInWin));

%% Error trials SDFs
events2Align = {'Target_','Saccade_','AudioStart_','JuiceStart_'};
selTrls = struct();
isNonCancelNoBrk = find(TaskInfos.IsNonCancelledNoBrk==1);
selTrls.errorTrls = errTrls;
for ii = 1: numel(events2Align)
    evtName = events2Align{ii};
    out5.(evtName) = plotAligned(selTrls,Task,evtName,DSP01a);
end

%%

