function [roi] = readRawROI(obj, rows, cols)
%READRAW Summary of this function goes here
    roi = zeros(rows, cols);
    channels = (1:rows) + obj.channelOffset;
    if ~obj.rawIsOpen
        obj.openRaw();
    end
    p = gcp('nocreate');
    try
        if obj.lastSampleRead == obj.nSamplesPerChannel
            roi = [];
            return;
        end
        sampleStart = obj.lastSampleRead + 1;
        sampleEnd = obj.lastSampleRead + cols;
        sampleEnd = min(sampleEnd, obj.nSamplesPerChannel);
        memFiles = obj.memmapDataFiles;
        if isempty(p)
            temp = arrayfun(@(ch) memFiles{ch}.Data(sampleStart:sampleEnd),channels,'UniformOutput',false);
        else
            parfor ii = 1:rows
                ch = channels(ii);
                temp{ii} = memFiles{ch}.Data(sampleStart:sampleEnd); %#ok<PFBNS>
            end
        end
        roi = cell2mat(temp)';
        obj.lastSampleRead = sampleEnd;
    catch EX
        fprintf('Exception in readRaw...\n');
        fprintf('Trying to read from: [%d], to [%d]\n',...
            sampleStart,sampleEnd);
        obj.dataSize
        disp(EX);
    end
end

