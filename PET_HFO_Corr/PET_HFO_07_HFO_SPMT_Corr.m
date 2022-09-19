%% Path
clear
addpath(genpath('C:\Users\THIENC\Desktop\HFO_AI_Detector-master'))
addpath(genpath('C:\Users\THIENC\Desktop\PET_SEEG'))

%% Move the PET result to the HFO folder
clear
PETResultF = 'D:\13.2.Zilin_HFO_anat_rPET\2.SPM_PET_Results';
HFOresultF = 'D:\13.2.Zilin_HFO_anat_rPET\5.HFO_results';
cd(PETResultF)
subNames = GetFolders(pwd);
for i = 1:length(subNames)
        cd(subNames{i})
        disp(subNames{i})
        
        tempSubName = [];
        [~,tempSubName] = fileparts(subNames{i});
        tgtDirResults = [];
        tgtDirResults = [HFOresultF,filesep,tempSubName];
        
        copyfile('chanPETtVal.mat',tgtDirResults)
end

%% Fix 03yintao
clear
cd('D:\13.2.Zilin_HFO_anat_rPET\5.HFO_results\03YinTao')
load('GrayNonArtChanMsk.mat')
finalChanMask(54) = 0;
save('GrayNonArtChanMsk.mat','finalChanMask','HFOchannels')

%% 1) PET value between HFO and nonHFO channel qHFO
clear
cd('D:\13.2.Zilin_HFO_anat_rPET\5.HFO_results')
statF = 'D:\13.2.Zilin_HFO_anat_rPET\6.StatisticData';
% match the channel first
subNames = GetFolders(pwd);
% Parameters
HFOvsNonHFO     = [];
PETincludedFull = [];
HFOincludedFull = [];
for i = 1:length(subNames)
    cd(subNames{i})
    disp(subNames{i})
    
    load chanPETtVal.mat
    load HFOrate.mat
    load GrayNonArtChanMsk.mat
    
    % match the channel first
    assert(all(strcmp(HFOrate.awake1.chanLabels,HFOchannels)))
    assert(length(HFOchannels) == length(ChanNames))
    for j = 1:length(HFOchannels)
        tempHFOChan = [];
        tempHFOChan = HFOchannels{j};
        tempIdx = find(contains(ChanNames,tempHFOChan));
        assert(~isempty(tempIdx))
    end
    
    % 4 trial combined
    qHFO4T = HFOrate.awake1.qHFO + ...
             HFOrate.awake2.qHFO + ...
             HFOrate.sleep1.qHFO + ...
             HFOrate.sleep2.qHFO;
    qHFOthreshDist = qHFO4T;
    qHFOthreshDist(finalChanMask) = [];
    HFOcountsThresh = median(qHFOthreshDist);
    
    T4HFOmsk    = (qHFO4T > HFOcountsThresh);
    T4nonHFOmsk = ~T4HFOmsk;
    T4HFOmsk    = and(finalChanMask,T4HFOmsk);
    T4nonHFOmsk = and(finalChanMask,T4nonHFOmsk);
    
    T4HFOchan    = HFOchannels(T4HFOmsk);
    T4nonHFOchan = HFOchannels(T4nonHFOmsk);
    
    % Take the SPM T values between groups
    SPMTHFO = [];
    for t1 = 1:length(T4HFOchan)
        tempChan = T4HFOchan{t1};
        tempPETval = [];
        tempPETvalIndex = find(contains(ChanNames,tempChan));
        assert(~isempty(tempPETvalIndex))
        tempPETval = nSUVRaw(tempPETvalIndex);
        SPMTHFO(t1) = tempPETval;
    end
    HFOvsNonHFO.T4.HFOPET(i,1) = mean(SPMTHFO);
    
    SPMTnonHFO = [];
    for t2 = 1:length(T4nonHFOchan)
        tempChan = T4nonHFOchan{t2};
        tempPETval = [];
        tempPETvalIndex = find(contains(ChanNames,tempChan));
        assert(~isempty(tempPETvalIndex))
        tempPETval = nSUVRaw(tempPETvalIndex);
        SPMTnonHFO(t2) = tempPETval;
    end
    HFOvsNonHFO.T4.nonHFOPET(i,1) = mean(SPMTnonHFO);
    
    % For the correlation
    HFOincluded  = qHFO4T(finalChanMask);
    chanIncluded = HFOchannels(finalChanMask);
    PETincluded  = [];
    for pt = 1:length(chanIncluded)
        tempChan   = chanIncluded{pt};
        tempPETval = [];
        tempPETvalIndex = find(contains(ChanNames,tempChan));
        assert(~isempty(tempPETvalIndex))
        tempPETval = nSUVRaw(tempPETvalIndex);
        PETincluded(pt,1) = tempPETval;
    end
    
    mdl      = []
    msk3     = (HFOincluded == 0);
    PETincluded(msk3) = [];
    HFOincluded(msk3) = [];
    mdl = fitlm(PETincluded,log10(HFOincluded));
    figure
    plot(mdl)
    print('qHFO_PET_corr','-dpng')
    
    r = []; p = [];
    
    PETincludedFull = [PETincludedFull;PETincluded];
    HFOincludedFull = [HFOincludedFull;HFOincluded];
    [r,p] = corr(PETincluded,HFOincluded,'Type','Kendall');
    HFOvsNonHFO.T4.rho(i,1) = r;
    HFOvsNonHFO.T4.p(i,1)   = p;
        
end
cd(statF)
save('qHFOcorr.mat','HFOvsNonHFO')

%% Organize the all the HFO results to a big table
% Ignoring the latency section results
clear
cd('D:\13.2.Zilin_HFO_anat_rPET\5.HFO_results')
statF = 'D:\13.2.Zilin_HFO_anat_rPET\6.StatisticData';
% match the channel first
subNames = GetFolders(pwd);
% Parameters
PETincludedFull = [];

qHFOincludedFull    = [];
qHFOFRincludedFull  = [];

CaseID      = [];
AnonymousID = [];
for i = 1:length(subNames)
    cd(subNames{i})
    disp(subNames{i})
    
    load chanPETtVal.mat
    load HFOrate.mat
    load HFOlatency.mat
    load GrayNonArtChanMsk.mat
    
    % match the channel first
    assert(all(strcmp(HFOrate.awake1.chanLabels,HFOchannels)))
    assert(length(HFOchannels) == length(ChanNames))
    for j = 1:length(HFOchannels)
        tempHFOChan = [];
        tempHFOChan = HFOchannels{j};
        tempIdx = find(contains(ChanNames,tempHFOChan));
        assert(~isempty(tempIdx))
    end
    
    % 4 trial combined, dimension reduction
    qHFO4T = HFOrate.awake1.qHFO + ...
        HFOrate.awake2.qHFO + ...
        HFOrate.sleep1.qHFO + ...
        HFOrate.sleep2.qHFO;
    
    qHFO4TFR = HFOrate.awake1.qHFOFR + ...
        HFOrate.awake2.qHFOFR + ...
        HFOrate.sleep1.qHFOFR + ...
        HFOrate.sleep2.qHFOFR;
       
    % For the correlation
    qHFOincluded    = qHFO4T(finalChanMask);
    qHFOFRincluded  = qHFO4TFR(finalChanMask);
    
    % Method 2 take this for it enables cross state r comparison
    qHFOincluded   = qHFOincluded + 1; % For log
    qHFOFRincluded = qHFOFRincluded + 1;
    
    qHFOincluded   = log10(qHFOincluded);
    qHFOFRincluded = log10(qHFOFRincluded);
   
    chanIncluded = HFOchannels(finalChanMask);
    PETincluded  = [];
    for pt = 1:length(chanIncluded)
        tempChan   = chanIncluded{pt};
        tempPETval = [];
        tempPETvalIndex = find(contains(ChanNames,tempChan));
        assert(~isempty(tempPETvalIndex))
        tempPETval = nSUVRaw(tempPETvalIndex);
        PETincluded(pt,1) = tempPETval;
    end
    
    r1 = []; p1 = [];
    r2 = []; p2 = [];
    [r1,p1] = corr(PETincluded,qHFOincluded);
    [r2,p2] = corr(PETincluded,qHFOFRincluded);
    
    rcollectHFO(i,1)   = r1;
    rcollectHFOFR(i,1) = r2;
    
    PETincludedFull = [PETincludedFull;PETincluded];
    
    qHFOincludedFull    = [qHFOincludedFull;qHFOincluded];
    qHFOFRincludedFull  = [qHFOFRincludedFull;qHFOFRincluded];
       
    tempcaseID = [];
    [~,tempcase,~] = fileparts(subNames{i});
    tempcase = {tempcase};
    tempcase = repmat(tempcase,[length(PETincluded),1]);
    CaseID         = [CaseID;tempcase];
    tempAnoID = repmat(i,[length(PETincluded),1]);
    AnonymousID    = [AnonymousID;tempAnoID];
end

mean(rcollectHFO)
mean(rcollectHFOFR)
[h,p] = ttest(rcollectHFO,rcollectHFOFR);
% 
p = signrank(rcollectHFO,rcollectHFOFR);

qHFOlog10T4PETtable = table(qHFOincludedFull,qHFOFRincludedFull,PETincludedFull,CaseID,AnonymousID);

%
cd(statF)
writetable(qHFOlog10T4PETtable,'qHFOT4PETFullfinal.csv')

%% Collect case ID
clear
cd('D:\13.2.Zilin_HFO_anat_rPET\5.HFO_results')

subNames = GetFolders(pwd);

CaseID =[];
for i = 1:length(subNames)
    cd(subNames{i})
    disp(subNames{i})
    
    tempcaseID = [];
    [~,tempcase,~] = fileparts(subNames{i});
    tempcase = {tempcase};
    CaseID         = [CaseID;tempcase];
end
%% The rest is abandoned
%% Organize the all the HFO results to a big table
% Ignoring the latency section results
clear
cd('D:\13.2.Zilin_HFO_anat_rPET\5.HFO_results')
statF = 'D:\13.2.Zilin_HFO_anat_rPET\6.StatisticData';
% match the channel first
subNames = GetFolders(pwd);
% Parameters
PETincludedFull = [];

qHFOincludedFull    = [];
qHFOFRincludedFull  = [];
qHFOlatincludedFull = [];

CaseID = [];
for i = 1:length(subNames)
    cd(subNames{i})
    disp(subNames{i})
    
    load chanPETtVal.mat
    load HFOrate.mat
    load HFOlatency.mat
    load GrayNonArtChanMsk.mat
    
    % match the channel first
    assert(all(strcmp(HFOrate.awake1.chanLabels,HFOchannels)))
    assert(length(HFOchannels) == length(ChanNames))
    for j = 1:length(HFOchannels)
        tempHFOChan = [];
        tempHFOChan = HFOchannels{j};
        tempIdx = find(contains(ChanNames,tempHFOChan));
        assert(~isempty(tempIdx))
    end
    
    % 4 trial combined, dimension reduction
    qHFO4T = HFOrate.awake1.qHFO + ...
        HFOrate.awake2.qHFO + ...
        HFOrate.sleep1.qHFO + ...
        HFOrate.sleep2.qHFO;
    
    qHFO4TFR = HFOrate.awake1.qHFOFR + ...
        HFOrate.awake2.qHFOFR + ...
        HFOrate.sleep1.qHFOFR + ...
        HFOrate.sleep2.qHFOFR;
    
    % 4 trial combined, dimension reduction: latency
    qHFO4Tlat = [HFOlatency.awake1.LatIndx', ...
        HFOlatency.awake2.LatIndx' , ...
        HFOlatency.sleep1.LatIndx' , ...
        HFOlatency.sleep2.LatIndx'];
    qHFO4Tlat = nanmean(qHFO4Tlat')';
    
    finalChanMask = and(finalChanMask,~isnan(qHFO4Tlat));
    
    % For the correlation
    qHFOincluded    = qHFO4T(finalChanMask);
    qHFOFRincluded  = qHFO4TFR(finalChanMask);
    qHFOlatincluded = qHFO4Tlat(finalChanMask);
    
    % Method 2 take this for it enables cross state r comparison
    
    qHFOincluded   = qHFOincluded + 1;
    qHFOFRincluded = qHFOFRincluded + 1;
    
    qHFOincluded   = log10(qHFOincluded);
    qHFOFRincluded = log10(qHFOFRincluded);
    
%     qHFOincluded   = normalize(qHFOincluded,'range');
%     qHFOFRincluded = normalize(qHFOFRincluded,'range');
    
%     % Normalize the latency
    qHFOlatincluded = normalize(qHFOlatincluded,'range');
    
    chanIncluded = HFOchannels(finalChanMask);
    PETincluded  = [];
    for pt = 1:length(chanIncluded)
        tempChan   = chanIncluded{pt};
        tempPETval = [];
        tempPETvalIndex = find(contains(ChanNames,tempChan));
        assert(~isempty(tempPETvalIndex))
        tempPETval = nSUVRaw(tempPETvalIndex);
        PETincluded(pt,1) = tempPETval;
    end
    
    % PETincluded = normalize(PETincluded,'range');
    
    PETincludedFull = [PETincludedFull;PETincluded];
    
    qHFOincludedFull    = [qHFOincludedFull;qHFOincluded];
    qHFOFRincludedFull  = [qHFOFRincludedFull;qHFOFRincluded];
    qHFOlatincludedFull = [qHFOlatincludedFull;qHFOlatincluded];
    
    tempcaseID = [];
    [~,tempcase,~] = fileparts(subNames{i});
    tempcase = {tempcase};
    tempcase = repmat(tempcase,[length(PETincluded),1]);
    CaseID         = [CaseID;tempcase];
end

% % Method 1
% % Exclude those did not show any HFO
% ZeroHFOmsk = (HFOincludedFull == 0);
% HFOincludedFull(ZeroHFOmsk) = [];
% PETincludedFull(ZeroHFOmsk) = [];
% CaseID(ZeroHFOmsk)          = [];

qHFOlog10T4PETtable = table(qHFOincludedFull,qHFOFRincludedFull,qHFOlatincludedFull,PETincludedFull,CaseID);

%
cd(statF)
writetable(qHFOlog10T4PETtable,'qHFOT4PETFull2.csv')

%% qHFOFR latency
clear
cd('D:\13.2.Zilin_HFO_anat_rPET\5.HFO_results')
statF = 'D:\13.2.Zilin_HFO_anat_rPET\6.StatisticData';
% match the channel first
subNames = GetFolders(pwd);
% Parameters
PETincludedFull = [];
HFOincludedFull = [];
CaseID = [];
for i = 1:length(subNames)
    cd(subNames{i})
    disp(subNames{i})
    
    load chanPETtVal.mat
    load HFOlatency.mat
    load GrayNonArtChanMsk.mat
    
    % match the channel first
    assert(all(strcmp(HFOlatency.awake1.chanLabels,HFOchannels)))
    assert(length(HFOchannels) == length(ChanNames))
    for j = 1:length(HFOchannels)
        tempHFOChan = [];
        tempHFOChan = HFOchannels{j};
        tempIdx = find(contains(ChanNames,tempHFOChan));
        assert(~isempty(tempIdx))
    end
    
    % 4 trial combined, dimension reduction
    qHFO4T = [HFOlatency.awake1.LatIndx', ...
             HFOlatency.awake2.LatIndx' , ...
             HFOlatency.sleep1.LatIndx' , ...
             HFOlatency.sleep2.LatIndx'];
    qHFO4T = nanmean(qHFO4T')';
    finalChanMask = and(finalChanMask,~isnan(qHFO4T));
    
    % For the correlation
    HFOincluded  = qHFO4T(finalChanMask);
    chanIncluded = HFOchannels(finalChanMask);
    PETincluded  = [];
    for pt = 1:length(chanIncluded)
        tempChan   = chanIncluded{pt};
        tempPETval = [];
        tempPETvalIndex = find(contains(ChanNames,tempChan));
        assert(~isempty(tempPETvalIndex))
        tempPETval = nSUVRaw(tempPETvalIndex);
        PETincluded(pt,1) = tempPETval;
    end
    
    mdl = [];
    xx = PETincluded;
    yy = HFOincluded;
    mdl = fitlm(xx,yy);
    figure
    plot(mdl)
    
    PETincludedFull = [PETincludedFull;PETincluded];
    HFOincludedFull = [HFOincludedFull;HFOincluded];
    tempcaseID = [];
    [~,tempcase,~] = fileparts(subNames{i});
    tempcase = {tempcase};
    tempcase = repmat(tempcase,[length(PETincluded),1]);
    CaseID         = [CaseID;tempcase];
end

%

qHFOlog10T4PETtable = table(HFOincludedFull,PETincludedFull,CaseID);
%
cd(statF)
writetable(qHFOlog10T4PETtable,'qHFOT4PETlatency.csv')
%% qHFOFR
clear
cd('D:\13.2.Zilin_HFO_anat_rPET\5.HFO_results')
statF = 'D:\13.2.Zilin_HFO_anat_rPET\6.StatisticData';
% match the channel first
subNames = GetFolders(pwd);
% Parameters
PETincludedFull = [];
HFOincludedFull = [];
CaseID = [];
for i = 1:length(subNames)
    cd(subNames{i})
    disp(subNames{i})
    
    load chanPETtVal.mat
    load HFOrate.mat
    load GrayNonArtChanMsk.mat
    
    % match the channel first
    assert(all(strcmp(HFOrate.awake1.chanLabels,HFOchannels)))
    assert(length(HFOchannels) == length(ChanNames))
    for j = 1:length(HFOchannels)
        tempHFOChan = [];
        tempHFOChan = HFOchannels{j};
        tempIdx = find(contains(ChanNames,tempHFOChan));
        assert(~isempty(tempIdx))
    end
    
    % 4 trial combined, dimension reduction
    qHFO4T = HFOrate.awake1.qHFOFR + ...
             HFOrate.awake2.qHFOFR + ...
             HFOrate.sleep1.qHFOFR + ...
             HFOrate.sleep2.qHFOFR;
    
    % For the correlation
    HFOincluded  = qHFO4T(finalChanMask);
    chanIncluded = HFOchannels(finalChanMask);
    PETincluded  = [];
    for pt = 1:length(chanIncluded)
        tempChan   = chanIncluded{pt};
        tempPETval = [];
        tempPETvalIndex = find(contains(ChanNames,tempChan));
        assert(~isempty(tempPETvalIndex))
        tempPETval = nSUVRaw(tempPETvalIndex);
        PETincluded(pt,1) = tempPETval;
    end
    
    PETincludedFull = [PETincludedFull;PETincluded];
    HFOincludedFull = [HFOincludedFull;HFOincluded];
    tempcaseID = [];
    [~,tempcase,~] = fileparts(subNames{i});
    tempcase = {tempcase};
    tempcase = repmat(tempcase,[length(PETincluded),1]);
    CaseID         = [CaseID;tempcase];
end

% % Method 1
% % Exclude those did not show any HFO
% ZeroHFOmsk = (HFOincludedFull <= 10);
% HFOincludedFull(ZeroHFOmsk) = [];
% PETincludedFull(ZeroHFOmsk) = [];
% CaseID(ZeroHFOmsk)          = [];

% Method 2 take this for it enables cross state r comparison
HFOincludedFull = HFOincludedFull + 1;

HFOincludedFull = log10(HFOincludedFull);

qHFOlog10T4PETtable = table(HFOincludedFull,PETincludedFull,CaseID);
%
cd(statF)
writetable(qHFOlog10T4PETtable,'qHFOT4PETFR.csv')

%% qHFOFR old manner
clear
cd('D:\13.2.Zilin_HFO_anat_rPET\5.HFO_results')
statF = 'D:\13.2.Zilin_HFO_anat_rPET\6.StatisticData';
% match the channel first
subNames = GetFolders(pwd);
% Parameters
HFOvsNonHFO = [];
for i = 1:length(subNames)
    cd(subNames{i})
    disp(subNames{i})
    
    load chanPETtVal.mat
    load HFOrate.mat
    load GrayNonArtChanMsk.mat
    
    % match the channel first
    assert(all(strcmp(HFOrate.awake1.chanLabels,HFOchannels)))
    assert(length(HFOchannels) == length(ChanNames))
    for j = 1:length(HFOchannels)
        tempHFOChan = [];
        tempHFOChan = HFOchannels{j};
        tempIdx = find(contains(ChanNames,tempHFOChan));
        assert(~isempty(tempIdx))
    end
    
    % 4 trial combined
    qHFO4T = HFOrate.awake1.qHFOFR + ...
             HFOrate.awake2.qHFOFR + ...
             HFOrate.sleep1.qHFOFR + ...
             HFOrate.sleep2.qHFOFR;
    qHFOthreshDist = qHFO4T;
    qHFOthreshDist(finalChanMask) = [];
    HFOcountsThresh = median(qHFOthreshDist);
    
    T4HFOmsk    = (qHFO4T > HFOcountsThresh);
    T4nonHFOmsk = ~T4HFOmsk;
    T4HFOmsk    = and(finalChanMask,T4HFOmsk);
    T4nonHFOmsk = and(finalChanMask,T4nonHFOmsk);
    
    T4HFOchan    = HFOchannels(T4HFOmsk);
    T4nonHFOchan = HFOchannels(T4nonHFOmsk);
    
    % Take the SPM T values between groups
    SPMTHFO = [];
    for t1 = 1:length(T4HFOchan)
        tempChan = T4HFOchan{t1};
        tempPETval = [];
        tempPETvalIndex = find(contains(ChanNames,tempChan));
        assert(~isempty(tempPETvalIndex))
        tempPETval = nSUVRaw(tempPETvalIndex);
        SPMTHFO(t1) = tempPETval;
    end
    HFOvsNonHFO.T4.HFOPET(i,1) = mean(SPMTHFO);
    
    SPMTnonHFO = [];
    for t2 = 1:length(T4nonHFOchan)
        tempChan = T4nonHFOchan{t2};
        tempPETval = [];
        tempPETvalIndex = find(contains(ChanNames,tempChan));
        assert(~isempty(tempPETvalIndex))
        tempPETval = nSUVRaw(tempPETvalIndex);
        SPMTnonHFO(t2) = tempPETval;
    end
    HFOvsNonHFO.T4.nonHFOPET(i,1) = mean(SPMTnonHFO);
    
    % For the correlation
    HFOincluded  = qHFO4T(finalChanMask);
    chanIncluded = HFOchannels(finalChanMask);
    PETincluded  = [];
    for pt = 1:length(chanIncluded)
        tempChan   = chanIncluded{pt};
        tempPETval = [];
        tempPETvalIndex = find(contains(ChanNames,tempChan));
        assert(~isempty(tempPETvalIndex))
        tempPETval = nSUVRaw(tempPETvalIndex);
        PETincluded(pt,1) = tempPETval;
    end
    r = []; p = [];
    
    [r,p] = corr(PETincluded,HFOincluded);
    HFOvsNonHFO.T4.rho(i,1) = r;
    HFOvsNonHFO.T4.p(i,1)   = p;
        
end
cd(statF)
save('qHFOFRcorr.mat','HFOvsNonHFO')

%%
clear
cd('D:\13.2.Zilin_HFO_anat_rPET\5.HFO_results')
statF = 'D:\13.2.Zilin_HFO_anat_rPET\6.StatisticData';
% match the channel first
subNames = GetFolders(pwd);
% Parameters
HFOvsNonHFO = [];
for i = 1:length(subNames)
    cd(subNames{i})
    disp(subNames{i})
    
    load chanPETtVal.mat
    load HFOlatency.mat
    load GrayNonArtChanMsk.mat
    
    % match the channel first
    assert(all(strcmp(HFOlatency.awake1.chanLabels,HFOchannels)))
    assert(length(HFOchannels) == length(ChanNames))
    for j = 1:length(HFOchannels)
        tempHFOChan = [];
        tempHFOChan = HFOchannels{j};
        tempIdx = find(contains(ChanNames,tempHFOChan));
        assert(~isempty(tempIdx))
    end
    
    % 4 trial combined
    qHFO4T = [HFOlatency.awake1.LatIndx', ...
             HFOlatency.awake2.LatIndx' , ...
             HFOlatency.sleep1.LatIndx' , ...
             HFOlatency.sleep2.LatIndx'];
    qHFO4T = nanmean(qHFO4T')';
    finalChanMask = and(finalChanMask,~isnan(qHFO4T));
    qHFOthreshDist = qHFO4T;
    qHFOthreshDist(finalChanMask) = [];
    HFOcountsThresh = median(qHFOthreshDist);
    
    T4HFOmsk    = (qHFO4T > HFOcountsThresh);
    T4nonHFOmsk = ~T4HFOmsk;
    T4HFOmsk    = and(finalChanMask,T4HFOmsk);
    T4nonHFOmsk = and(finalChanMask,T4nonHFOmsk);
    
    T4HFOchan    = HFOchannels(T4HFOmsk);
    T4nonHFOchan = HFOchannels(T4nonHFOmsk);
    
    % Take the SPM T values between groups
    SPMTHFO = [];
    for t1 = 1:length(T4HFOchan)
        tempChan = T4HFOchan{t1};
        tempPETval = [];
        tempPETvalIndex = find(contains(ChanNames,tempChan));
        assert(~isempty(tempPETvalIndex))
        tempPETval = nSUVRaw(tempPETvalIndex);
        SPMTHFO(t1) = tempPETval;
    end
    HFOvsNonHFO.T4.HFOPET(i,1) = mean(SPMTHFO);
    
    SPMTnonHFO = [];
    for t2 = 1:length(T4nonHFOchan)
        tempChan = T4nonHFOchan{t2};
        tempPETval = [];
        tempPETvalIndex = find(contains(ChanNames,tempChan));
        assert(~isempty(tempPETvalIndex))
        tempPETval = nSUVRaw(tempPETvalIndex);
        SPMTnonHFO(t2) = tempPETval;
    end
    HFOvsNonHFO.T4.nonHFOPET(i,1) = mean(SPMTnonHFO);
    
    % For the correlation
    HFOincluded  = qHFO4T(finalChanMask);
    if isempty(HFOincluded)
        continue
    end
    chanIncluded = HFOchannels(finalChanMask);
    PETincluded  = [];
    for pt = 1:length(chanIncluded)
        tempChan   = chanIncluded{pt};
        tempPETval = [];
        tempPETvalIndex = find(contains(ChanNames,tempChan));
        assert(~isempty(tempPETvalIndex))
        tempPETval = nSUVRaw(tempPETvalIndex);
        PETincluded(pt,1) = tempPETval;
    end
    r = []; p = [];
    
    [r,p] = corr(PETincluded,HFOincluded);
    HFOvsNonHFO.T4.rho(i,1) = r;
    HFOvsNonHFO.T4.p(i,1)   = p;
        
end
cd(statF)
save('qHFOLatcorr.mat','HFOvsNonHFO')


%% 2) above threshold corr



%%
