%codesDir = '/Volumes/schalllab/Users/Chenchal/Tempo_NewCode/Joule-190312-162436/ProcLib/CMD';

baseDir = '/Volumes/schalllab';
%sessionBaseDir = fullfile(baseDir,'Users/Chenchal/Tempo_NewCode/Joule');
sessionBaseDir = fullfile(baseDir,'data/Joule/cmanding/beh/tdtRaw');

baseSaveDir = fullfile(baseDir,'data/Joule/cmanding/beh/tdtMatlab');
sessName = 'Joule-190508-123152';
procLibDir =fullfile(sessionBaseDir, sessName, 'ProcLib');
eventDefFile = fullfile(procLibDir,'CMD/EVENTDEF.PRO');
infosDefFile = fullfile(procLibDir,'CMD/INFOS.PRO');

% setup options to translate TDT datafile

opts.sessionDir = fullfile(sessionBaseDir,sessName);
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


[Task, TaskInfos, TrialEyes, EventCodec, InfosCodec, SessionInfo] = ZZ.translate(0);



