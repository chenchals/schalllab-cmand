sourceDrive_data = 'T:';
source_dataProcessed = 'E:/Dropbox/SCHALL_preProcessingData';
% 
%% Parameters for Translation
sessionBaseDir = [sourceDrive_data '/data/Joule/cmanding/ephys/TESTDATA/In-Situ'];
baseSaveDir = [source_dataProcessed '/dataProcessed/Joule/cmanding/ephys/TESTDATA/In-Situ'];
% mkdir(baseSaveDir)  % Ensure baseSaveDir is already created.
sessionDirs = dir(fullfile(sessionBaseDir,'Joule-190827-13460*')); % replace the last digit of the single directlry name with a *

for s= 1:size(sessionDirs,1)
sessName = sessionDirs(s).name;
sessionDir = fullfile(sessionDirs(s).folder,sessName);

if exist(fullfile(sessionDir,'Events.mat'), 'file')...
   && exist(fullfile(sessionDir,'Eyes.mat'), 'file')
   fprintf('***Translated session [%s] already present! Continuing with next session\n',sessName);
   continue;
end
fprintf('Translating session [%s]...',sessName)
procLibDir = fullfile(sessionDir,'ProcLib');
eventDefFile = fullfile(procLibDir,'CMD/EVENTDEF.PRO');
infosDefFile = fullfile(procLibDir,'CMD/INFOS.PRO');
% set it up in TranslateTDT
opts.sessionDir = sessionDir;
opts.baseSaveDir = baseSaveDir;
opts.eventDefFile = eventDefFile;
opts.infosDefFile = infosDefFile; 
opts.useTaskStartEndCodes = true;
opts.dropNaNTrialStartTrials = false;
opts.dropEventAllTrialsNaN = false;
% Offset for Info Code values_
opts.infosOffsetValue = 3000;
opts.infosHasNegativeValues = true;
opts.infosNegativeValueOffset = 32768;
% Eye data
opts.splitEyeIntoTrials = false;
opts.hasEdfDataFile = 0;
% opts.edf.useEye = 'X';
% opts.edf.voltRange = [-5 5];
% opts.edf.signalRange = [-0.2 1.2];
% opts.edf.pixelRange = [0 1024];


ZZ = TDTTranslator(opts);
try
[Task, TaskInfos, TrialEyes, EventCodec, InfosCodec, SessionInfo] = ZZ.translate(0);
fprintf('Done!\n')
catch me
    fprintf('***Failed translation for session [%s]\n',sessName);
   fprintf('Exception\n: %s\n', evalc('[disp(me)]'));
    
end

end

