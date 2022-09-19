%% Organize the results
clear
HFOResultsFolder = 'D:\13.2.Zilin_HFO_anat_rPET\HFOResults';
SourceFolder     = 'D:\13.2.Zilin_HFO_anat_rPET\4.PET-HFO-lat-corr';
addpath(genpath('C:\Users\THIENC\Desktop\HFO_AI_Detector-master'))
addpath(genpath('C:\Users\THIENC\Desktop\PET_SEEG'))
%% Organize the data to the seperate folders
cd(SourceFolder)
HFOmatF = dir('*.mat');
for i = 1:length(HFOmatF)
    tempTrial = [];
    tempTrial = HFOmatF(i).name(1:end-4);
    tgtFolder = ['D:\13.2.Zilin_HFO_anat_rPET\3.PET-HFO-rate-corr',filesep,tempTrial];
    copyfile(HFOmatF(i).name,tgtFolder)
end

%% Make the final channel selection mask
clear
cd('D:\13.2.Zilin_HFO_anat_rPET\5.HFO_results')
subFolders = GetFolders(pwd);
for i = 1:length(subFolders)
   cd(subFolders{i})
   disp(subFolders{i})
   HFOrate = [];
   load HFOrate.mat
   msk1 = HFOrate.awake1.chanInclusion;
   msk2 = HFOrate.awake2.chanInclusion;
   msk3 = HFOrate.sleep1.chanInclusion;
   msk4 = HFOrate.sleep2.chanInclusion;
   
   finalChanMask = and(and(and(msk1,msk2),msk3),msk4);
   assert(length(finalChanMask) == length(HFOrate.awake1.chanLabels))
   HFOchannels = HFOrate.awake1.chanLabels;
   save('GrayNonArtChanMsk.mat','finalChanMask','HFOchannels')
end

%% Distribute those channel masks
clear
cd('D:\13.2.Zilin_HFO_anat_rPET\5.HFO_results')
subFolders = GetFolders(pwd);
cd('D:\13.2.Zilin_HFO_anat_rPET\3.PET-HFO-rate-corr')
trialFolders = GetFolders(pwd);

for i = 1:length(subFolders)
    cd(subFolders{i})
    disp(subFolders{i})
    tempOnsetIndx  = (i - 1) * 4 + 1;
    tempOffsetIndx = (i - 1) * 4 + 4;
    for s = tempOnsetIndx:tempOffsetIndx
        copyfile('GrayNonArtChanMsk.mat',trialFolders{s})
    end
end

%% Build the latency matrix: 1.screening validate channel data
% run the fixHFOmat in the script folder to match the channels in each
% trial
clear
cd('D:\13.2.Zilin_HFO_anat_rPET\3.PET-HFO-rate-corr')
trialFolders = GetFolders(pwd);
for s = 1:length(trialFolders)
    cd(trialFolders{s})
    disp(trialFolders{s})
    if exist('qHFOtimeStamp.mat')
        continue
    end
    
    matF = [];
    matF = dir('*awake*.mat');
    if isempty(matF)
        matF = dir('*sleep*.mat');
    end
    assert(~isempty(matF))
    
    load(matF.name)
    
    % Match the qHFO counts to validate the channel names
    HFOexcel = [];
    HFOexcel    = dir('*.xlsx');
    HFOResults  = [];
    ChanLabels  = [];
    
    [HFOResults,ChanLabels,~] = xlsread(HFOexcel.name);
    
    assert(~isempty(HFOResults))
    assert(~isempty(ChanLabels))
    
    ChanLabels    = ChanLabels(2:end,1);
    
    qHFO          = [];
    qHFO          = HFOResults(:,3);
    
    % match the HFO counts to validate the channel labels
    assert(all(HFO.qualityHFOsCounts == qHFO))
    assert(length(HFO.qualityHFOsCounts) == length(qHFO))   
    
    ExcludeEventType1 = 'Artifacts';
    ExcludeEventType2 = 'Others';
    
    quanlityTag = [];
    for i = 1:length(HFO.CandidateHFOsFinalEventsLabels)
        tempTag = [];
        tempTag = HFO.CandidateHFOsFinalEventsLabels{i};
        if isempty(tempTag)
            quanlityTag{i,1} = [];
        else
            for j = 1:length(tempTag)
                if strcmp(tempTag{j},ExcludeEventType1) || strcmp(tempTag{j},ExcludeEventType2)
                    quanlityTag{i,1}(j,1) = 0;
                else
                    quanlityTag{i,1}(j,1) = 1;
                end
            end
        end
    end
    
    % find qualityHFO time stamp, exclude bad trials
    qualityHFOsFinalEventsTimeStamps = cell(size(HFO.CandidateHFOsFinalEventsTimeStamps));
    for ii = 1 : length(HFO.CandidateHFOsFinalEventsTimeStamps)
        for jj = 1 : size(HFO.CandidateHFOsFinalEventsTimeStamps{ii},1)
            if quanlityTag{ii}(jj) == 1
                qualityHFOsFinalEventsTimeStamps{ii} = [qualityHFOsFinalEventsTimeStamps{ii};HFO.CandidateHFOsFinalEventsTimeStamps{ii}(jj,:)];
            end
        end
    end
    
    % Exclude bad channels
    load('GrayNonArtChanMsk.mat')
    for k = 1:length(finalChanMask)
        if ~finalChanMask(k)
            qualityHFOsFinalEventsTimeStamps{k} = [];
        end
    end
    
    % save the results for latency calculation
    save('qHFOtimeStamp.mat','qualityHFOsFinalEventsTimeStamps','HFOchannels')
    
end

%% Build the latency matrix: 1.screening validate channel data with FR
% run the fixHFOmat in the script folder to match the channels in each
% trial
clear
cd('D:\13.2.Zilin_HFO_anat_rPET\3.PET-HFO-rate-corr')
trialFolders = GetFolders(pwd);
for s = 1:length(trialFolders)
    cd(trialFolders{s})
    disp(trialFolders{s})
    if exist('qHFOtimeStamp.mat')
        continue
    end
    
    matF = [];
    matF = dir('*awake*.mat');
    if isempty(matF)
        matF = dir('*sleep*.mat');
    end
    assert(~isempty(matF))
    
    load(matF.name)
    
    % Match the qHFO counts to validate the channel names
    HFOexcel = [];
    HFOexcel    = dir('*.xlsx');
    HFOResults  = [];
    ChanLabels  = [];
    
    [HFOResults,ChanLabels,~] = xlsread(HFOexcel.name);
    
    assert(~isempty(HFOResults))
    assert(~isempty(ChanLabels))
    
    ChanLabels    = ChanLabels(2:end,1);
    
    qHFO          = [];
    qHFO          = HFOResults(:,3);
    
    % match the HFO counts to validate the channel labels
    assert(all(HFO.qualityHFOsCounts == qHFO))
    assert(length(HFO.qualityHFOsCounts) == length(qHFO))   
    
    ExcludeEventType1 = 'Artifacts';
    ExcludeEventType2 = 'Others';
    IncludeEventType = 'FastRipple';
    
    quanlityTag = [];
    for i = 1:length(HFO.CandidateHFOsFinalEventsLabels)
        tempTag = [];
        tempTag = HFO.CandidateHFOsFinalEventsLabels{i};
        if isempty(tempTag)
            quanlityTag{i,1} = [];
        else
            for j = 1:length(tempTag)
                if strcmp(tempTag{j},ExcludeEventType1) || strcmp(tempTag{j},ExcludeEventType2)
                    quanlityTag{i,1}(j,1) = 0;
                elseif contains(tempTag{j},IncludeEventType)
                    quanlityTag{i,1}(j,1) = 1;
                end
            end
        end
    end
    
    % find qualityHFO time stamp, exclude bad trials
    qualityHFOsFinalEventsTimeStamps = cell(size(HFO.CandidateHFOsFinalEventsTimeStamps));
    for ii = 1 : length(HFO.CandidateHFOsFinalEventsTimeStamps)
        for jj = 1 : size(HFO.CandidateHFOsFinalEventsTimeStamps{ii},1)
            if quanlityTag{ii}(jj) == 1
                qualityHFOsFinalEventsTimeStamps{ii} = [qualityHFOsFinalEventsTimeStamps{ii};HFO.CandidateHFOsFinalEventsTimeStamps{ii}(jj,:)];
            end
        end
    end
    
    % Exclude bad channels
    load('GrayNonArtChanMsk.mat')
    for k = 1:length(finalChanMask)
        if ~finalChanMask(k)
            qualityHFOsFinalEventsTimeStamps{k} = [];
        end
    end
    
    % save the results for latency calculation
    save('qHFOtimeStamp.mat','qualityHFOsFinalEventsTimeStamps','HFOchannels')
    
end

%% Build the latency matrix: 2.Extract the latency matrix
clear
cd('D:\13.2.Zilin_HFO_anat_rPET\3.PET-HFO-rate-corr')
trialFolders = GetFolders(pwd);
for s = 1:length(trialFolders)
    cd(trialFolders{s})
    disp(trialFolders{s})
%     if exist('HFOlat.mat')
%         continue
%     end
    % compute time lag in every epoch
    % set epoch length
    load('qHFOtimeStamp.mat')
    epochLength = 0.1;
    TimeLagMatrix = nan(600/epochLength,length(HFOchannels),length(HFOchannels));
    
    for t = 1 : size(TimeLagMatrix,1) % time window loop
        TimeLagVector = nan(length(qualityHFOsFinalEventsTimeStamps),1);
        for ii = 1 : length(qualityHFOsFinalEventsTimeStamps) % channel loop
            if ~isempty(qualityHFOsFinalEventsTimeStamps{ii,1})
                winOnset  = 2000*epochLength*(t-1)+1;
                winOffset = 2000*epochLength*t;
                tempIndx1 = find(qualityHFOsFinalEventsTimeStamps{ii, 1}(:,2) >= winOnset);
                tempIndx2 = find(qualityHFOsFinalEventsTimeStamps{ii, 1}(:,2) <= winOffset);
                TempTimeTagPosIdx = intersect(tempIndx1,tempIndx2);
                % Take the first HFO peak in the time window in each
                % channel
                if ~isempty(TempTimeTagPosIdx)
                    TempTimeTagPosIdx = TempTimeTagPosIdx(1);
                    TimeLagVector(ii) = qualityHFOsFinalEventsTimeStamps{ii, 1}(TempTimeTagPosIdx,2);
                else
                    TimeLagVector(ii) = NaN;
                end
            else
                TimeLagVector(ii) = NaN;
            end
        end
        TimeLagMatrixSingle = nan(length(qualityHFOsFinalEventsTimeStamps));
        for a = 1 : length(TimeLagVector)
            for b = 1 : length(TimeLagVector)
                TimeLagMatrixSingle(a,b) = TimeLagVector(b) - TimeLagVector(a);
            end
        end
        TimeLagMatrix(t,:,:) = TimeLagMatrixSingle;
    end
    
    % Take the mean ignoring nan
   TimeLagMatrixAvg = squeeze(nanmean(TimeLagMatrix));
       
    % set diagonal line as white
    for u = 1 : size(TimeLagMatrixAvg,1)
        TimeLagMatrixAvg(u,u) = NaN;
    end
    
%     % validate
%     if exist('HFOlat.mat')
%         PrevM = load('HFOlat.mat');
%         TimeLagMatrixAvg2 = PrevM.TimeLagMatrixAvg;
%         TimeLagMatrixAvg2(isnan(TimeLagMatrixAvg2)) = [];
%         TimeLagMatrixAvgNew = TimeLagMatrixAvg;
%         TimeLagMatrixAvgNew(isnan(TimeLagMatrixAvgNew)) = [];
%         assert(all(TimeLagMatrixAvg2==TimeLagMatrixAvgNew))
%     end
    
%     % plot figure
%     figure
%     h = imagesc(TimeLagMatrixAvg);
%     set(h,'alphadata',~isnan(TimeLagMatrixAvg))
%     axis square
%     xticks([1:length(TimeLagMatrixAvg)])
%     xticklabels(HFOchannels)
%     yticks([1:length(TimeLagMatrixAvg)])
%     yticklabels(HFOchannels)
%     set(gca,'XTickLabelRotation',90)
%     colormap(linspecer)
%     colorbar
%     
%     set(gcf,'Position',[100 100 1200 900])
%     print('HFOlatencyMatrix','-dpng')
%     close
    % save the data
    save('HFOlat.mat','TimeLagMatrixAvg','HFOchannels','epochLength')
end

%% Collect the latency results
clear
cd('D:\13.2.Zilin_HFO_anat_rPET\3.PET-HFO-rate-corr')
subHFO = GetFolders(pwd);
HFOResultsDir = 'D:\13.2.Zilin_HFO_anat_rPET\5.HFO_results';

for i = 1:36
    tempOnsetIndx  = (i - 1) * 4 + 1;
    tempOffsetIndx = (i - 1) * 4 + 4;
    HFOlatency = [];
    for s = tempOnsetIndx:tempOffsetIndx
        cd(subHFO{s})
        disp(subHFO{s})
        
        tempSubName = [];
        [~,tempSubName] = fileparts(subHFO{s});
        tempSubName = extractBefore(tempSubName,'_');
        
        tempSubState = [];
        [~,tempSubState] = fileparts(subHFO{s});
        tempSubState = extractAfter(tempSubState,'_');
        
        tgtDirResults = [];
        tgtDirResults = [HFOResultsDir,filesep,tempSubName];
        if ~exist(tgtDirResults)
            mkdir(tgtDirResults)
        end
        
        HFOchannels      = [];
        epochLength      = [];
        TimeLagMatrixAvg = [];
        
        load HFOlat.mat
        
        switch tempSubState
            case 'awake1'
                HFOlatency.awake1.chanLabels  = HFOchannels;
                HFOlatency.awake1.epochL      = epochLength;
                HFOlatency.awake1.TimeLagM    = TimeLagMatrixAvg;
              % HFOlatency.awake1.LatIndx     = nanmean(TimeLagMatrixAvg);
                HFOlatency.awake1.LatIndx     = nanmax(TimeLagMatrixAvg);
            case 'awake2'
                HFOlatency.awake2.chanLabels  = HFOchannels;
                HFOlatency.awake2.epochL      = epochLength;
                HFOlatency.awake2.TimeLagM    = TimeLagMatrixAvg;
              % HFOlatency.awake2.LatIndx     = nanmean(TimeLagMatrixAvg);
                HFOlatency.awake2.LatIndx     = nanmax(TimeLagMatrixAvg);
            case 'sleep1'
                HFOlatency.sleep1.chanLabels  = HFOchannels;
                HFOlatency.sleep1.epochL      = epochLength;
                HFOlatency.sleep1.TimeLagM    = TimeLagMatrixAvg;
              % HFOlatency.sleep1.LatIndx     = nanmean(TimeLagMatrixAvg);
                HFOlatency.sleep1.LatIndx     = nanmax(TimeLagMatrixAvg);
            case 'sleep2'
                HFOlatency.sleep2.chanLabels  = HFOchannels;
                HFOlatency.sleep2.epochL      = epochLength;
                HFOlatency.sleep2.TimeLagM    = TimeLagMatrixAvg;
              % HFOlatency.sleep2.LatIndx     = nanmean(TimeLagMatrixAvg);
                HFOlatency.sleep2.LatIndx     = nanmax(TimeLagMatrixAvg);
        end
    end
    assert(~isempty(HFOlatency))
    cd(tgtDirResults)
    save('HFOlatency.mat','HFOlatency')
end
%% remove the deleted dir
clear
cd('D:\13.2.Zilin_HFO_anat_rPET\5.HFO_results')
rmdir('D:\13.2.Zilin_HFO_anat_rPET\5.HFO_results\10HuoChen', 's')
rmdir('D:\13.2.Zilin_HFO_anat_rPET\5.HFO_results\15WangRuyi', 's')
rmdir('D:\13.2.Zilin_HFO_anat_rPET\5.HFO_results\27SongHanrui', 's')
rmdir('D:\13.2.Zilin_HFO_anat_rPET\5.HFO_results\36GuoXuehong', 's')
%%






