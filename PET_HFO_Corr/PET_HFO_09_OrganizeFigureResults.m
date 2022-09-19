%% For figure 3 main results
addpath(genpath('C:\Users\THIENC\Desktop\PET_SEEG'))
%% Data for illustrative case correlation
clear
cd('D:\13.2.Zilin_HFO_anat_rPET\5.HFO_results\35GuiHaifeng')
statF = 'D:\13.2.Zilin_HFO_anat_rPET\6.StatisticData';

CaseID = [];

load chanPETtVal.mat
load HFOrate.mat
load GrayNonArtChanMsk.mat

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

qHFOincluded   = qHFOincluded + 1;
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

qHFOlog10T4PETtable = table(qHFOincluded,qHFOFRincluded,PETincluded);

[r,p] = corr(PETincluded,qHFOincluded);
[r,p] = corr(PETincluded,qHFOFRincluded);

%
cd(statF)
writetable(qHFOlog10T4PETtable,'case35guihaifengCorr.csv')

%% Data for group r and p values for each case
% For bar plot in R
clear
cd('D:\13.2.Zilin_HFO_anat_rPET\5.HFO_results')
statF = 'D:\13.2.Zilin_HFO_anat_rPET\6.StatisticData';
% match the channel first
subNames = GetFolders(pwd);
% Parameters
rHFO   = [];
rHFOFR = [];
pHFO   = [];
pHFOFR = [];
CaseID = [];
for i = 1:length(subNames)
    cd(subNames{i})
    disp(subNames{i})
    
    load chanPETtVal.mat
    load HFOrate.mat
    load GrayNonArtChanMsk.mat
    
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
    
    qHFOincluded   = qHFOincluded + 1;
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
    
%     % norm test
%     if ~kstest(PETincluded) && ~kstest(qHFOincluded)
%         [rHFO(i,1),pHFO(i,1)] = corr(PETincluded,qHFOincluded,'Type','Pearson');
%     elseif ~kstest(PETincluded) && ~kstest(qHFOFRincluded)
%         [rHFOFR(i,1),pHFOFR(i,1)] = corr(PETincluded,qHFOFRincluded,'Type','Pearson');
%     else
%         [rHFO(i,1),pHFO(i,1)] = corr(PETincluded,qHFOincluded,'Type','Spearman');
%         [rHFOFR(i,1),pHFOFR(i,1)] = corr(PETincluded,qHFOFRincluded,'Type','Spearman');
%     end
    
    
    [rHFO(i,1),pHFO(i,1)] = corr(PETincluded,qHFOincluded,'Type','Pearson');
    [rHFOFR(i,1),pHFOFR(i,1)] = corr(PETincluded,qHFOFRincluded,'Type','Pearson');
    
    % Lcorr(i,1)   = length(PETincluded);
    
    %     [pHFOperm(i,1), rHFOperm(i,1), ~, alphaHFO(i,1), ~]=mult_comp_perm_corr(PETincluded,qHFOincluded,10000);
    %     [pHFOFRperm(i,1), rHFOFRperm(i,1), ~, alphaHFOFR(i,1), ~]=mult_comp_perm_corr(PETincluded,qHFOFRincluded,10000);
    %
    CaseID(i,1)  = i;
end

% figure
% scatter(pHFOperm,pHFO)

% Organize the table to fit r plot convention
CaseID = [CaseID;CaseID];
rVal     = [rHFO;rHFOFR];
pVal     = [pHFO;pHFOFR];

label1 = repmat({'HFO'},[length(rHFO),1]);
label2 = repmat({'HFOFR'},[length(rHFO),1]);
GroupInd = [label1;label2];

qHFOlog10T4PETtable = table(CaseID,rVal,pVal,GroupInd);
%
cd(statF)
writetable(qHFOlog10T4PETtable,'GroupCorrRPrplot.csv')
%% Data for fisher z
clear
cd('D:\13.2.Zilin_HFO_anat_rPET\5.HFO_results')
statF = 'D:\13.2.Zilin_HFO_anat_rPET\6.StatisticData';
% match the channel first
subNames = GetFolders(pwd);
% Parameters
fisherzHFO   = [];
fisherzHFOFR = [];

for i = 1:length(subNames)
    cd(subNames{i})
    disp(subNames{i})
    
    load chanPETtVal.mat
    load HFOrate.mat
    load GrayNonArtChanMsk.mat
    
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
    
    qHFOincluded   = qHFOincluded + 1;
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
    
    [rHFO(i,1),pHFO(i,1)] = corr(PETincluded,qHFOincluded);
    [rHFOFR(i,1),pHFOFR(i,1)] = corr(PETincluded,qHFOFRincluded);
    
    fisherzHFO(i,1)   = fisherz(rHFO(i,1));
    fisherzHFOFR(i,1) = fisherz(rHFOFR(i,1));
    
end

qHFOlog10T4PETtable = table(fisherzHFO,fisherzHFOFR);
kstest(fisherzHFO) 
kstest(fisherzHFOFR)

[p,h] = signrank(fisherzHFO,fisherzHFOFR)
%
cd(statF)
writetable(qHFOlog10T4PETtable,'fisherzHFO_HFOFR.csv')

%% TLE and eTLE comparing
% Manual mask
temp = [];
isTLE.inclusionMsk = (temp ~= 3);
isTLE.TLE = (temp == 1);
save('isTLE.mat','isTLE')
%% comparing TLE and eTLE
clear
cd('D:\13.2.Zilin_HFO_anat_rPET\6.StatisticData')
load isTLE.mat
fisherZ = readtable('fisherzHFO_HFOFR.csv');
TLEmsk  = and(isTLE.inclusionMsk,isTLE.TLE);
eTLEmsk = and(isTLE.inclusionMsk,~isTLE.TLE);
TLEfisherz  = fisherZ.fisherzHFOFR(TLEmsk);
eTLEfisherz = fisherZ.fisherzHFOFR(eTLEmsk);

mean(TLEfisherz)
mean(eTLEfisherz)
[h,p] = ttest2(TLEfisherz,eTLEfisherz)


%% manual label outcome
temp = [];
isFree.inclusionMsk = (temp ~= 3);
isFree.Free = (temp == 1);
save('isFree.mat','isFree')

%% comparing outcome
clear
cd('D:\13.2.Zilin_HFO_anat_rPET\6.StatisticData')
statF = 'D:\13.2.Zilin_HFO_anat_rPET\6.StatisticData';

load isFree.mat
fisherZ = readtable('fisherzHFO_HFOFR.csv');
Freemsk  = and(isFree.inclusionMsk,isFree.Free);
nonFreemsk = and(isFree.inclusionMsk,~isFree.Free);
Freefisherz  = fisherZ.fisherzHFOFR(Freemsk);
nonFreefisherz = fisherZ.fisherzHFOFR(nonFreemsk);

kstest(Freefisherz) 
kstest(nonFreefisherz)

mean(Freefisherz)
mean(nonFreefisherz)
[h,p]   = ttest2(Freefisherz,nonFreefisherz)
[p2,h2] = ranksum(Freefisherz,nonFreefisherz)

freelabel    = repmat({'Free'},[length(Freefisherz),1]);
Nonfreelabel = repmat({'Non-free'},[length(nonFreefisherz),1]);

Labels   = [freelabel;Nonfreelabel];
fisherZs = [Freefisherz;nonFreefisherz];
FisherZtable = table(Labels,fisherZs);
cd(statF)
writetable(FisherZtable,'fisherzFreeNonfree.csv')
copyfile('fisherzFreeNonfree.csv','C:\Users\THIENC\Desktop\CC-Linear-mixed-models-master')
%% Subgroup analysis , data preparation for LME
% Ignoring the latency section results
clear
cd('D:\13.2.Zilin_HFO_anat_rPET\6.StatisticData')

load isTLE.mat
TLEmsk  = and(isTLE.inclusionMsk,isTLE.TLE);
eTLEmsk = and(isTLE.inclusionMsk,~isTLE.TLE);

cd('D:\13.2.Zilin_HFO_anat_rPET\5.HFO_results')
statF = 'D:\13.2.Zilin_HFO_anat_rPET\6.StatisticData';


subNames = GetFolders(pwd);
assert(length(TLEmsk) == length(subNames))
% TEL and eTLE
PETincludedTLE = [];
PETincludedeTLE = [];

qHFOFRincludedTLE  = [];
qHFOFRincludedeTLE  = [];

% awake and sleep
PETincludedFull = [];

qHFOFRincludedAwake  = [];
qHFOFRincludedeSleep  = [];

CaseID      = [];
CaseIDTLE   = [];
CaseIDeTLE  = [];

AnonymousID = [];
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
    
    qHFO4TFR = HFOrate.awake1.qHFOFR + ...
        HFOrate.awake2.qHFOFR + ...
        HFOrate.sleep1.qHFOFR + ...
        HFOrate.sleep2.qHFOFR;
    
    % For the correlation
    qHFOFRincluded  = qHFO4TFR(finalChanMask);
    
    % Method 2 take this for it enables cross state r comparison
    qHFOFRincluded = qHFOFRincluded + 1;
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
    
    if TLEmsk(i)
        PETincludedTLE     = [PETincludedTLE;PETincluded];
        qHFOFRincludedTLE  = [qHFOFRincludedTLE;qHFOFRincluded];
        
        tempcaseID = [];
        [~,tempcase,~] = fileparts(subNames{i});
        tempcase  = {tempcase};
        tempcase  = repmat(tempcase,[length(PETincluded),1]);
        CaseIDTLE = [CaseIDTLE;tempcase];
    elseif eTLEmsk(i)
        PETincludedeTLE    = [PETincludedeTLE;PETincluded];
        qHFOFRincludedeTLE = [qHFOFRincludedeTLE;qHFOFRincluded];
        
        tempcaseID = [];
        [~,tempcase,~] = fileparts(subNames{i});
        tempcase  = {tempcase};
        tempcase  = repmat(tempcase,[length(PETincluded),1]);
        CaseIDeTLE = [CaseIDeTLE;tempcase];
    end
    
    PETincludedFull     = [PETincludedFull;PETincluded];
    
    qHFOFR2Tawake = HFOrate.awake1.qHFOFR + HFOrate.awake2.qHFOFR;
    qHFOFR2Tsleep = HFOrate.sleep1.qHFOFR + HFOrate.sleep2.qHFOFR;
    
    % For the correlation
    qHFOFRincludedawake  = qHFOFR2Tawake(finalChanMask);
    qHFOFRincludedsleep  = qHFOFR2Tsleep(finalChanMask);
    
    % Method 2 take this for it enables cross state r comparison
    qHFOFRincludedawake = qHFOFRincludedawake + 1;
    qHFOFRincludedawake = log10(qHFOFRincludedawake);
    
    qHFOFRincludedsleep = qHFOFRincludedsleep + 1;
    qHFOFRincludedsleep = log10(qHFOFRincludedsleep);
    
    qHFOFRincludedAwake  = [qHFOFRincludedAwake;qHFOFRincludedawake];
    qHFOFRincludedeSleep = [qHFOFRincludedeSleep;qHFOFRincludedsleep];
    
    tempcaseID = [];
    [~,tempcase,~] = fileparts(subNames{i});
    tempcase = {tempcase};
    tempcase = repmat(tempcase,[length(PETincluded),1]);
    CaseID         = [CaseID;tempcase];
    tempAnoID = repmat(i,[length(PETincluded),1]);
    AnonymousID    = [AnonymousID;tempAnoID];
end

awakesleepT = table(qHFOFRincludedAwake,qHFOFRincludedeSleep,PETincludedFull,CaseID,AnonymousID);
TLET  = table(qHFOFRincludedTLE,PETincludedTLE,CaseIDTLE);
eTLET = table(qHFOFRincludedeTLE,PETincludedeTLE,CaseIDeTLE);
%
cd(statF)
writetable(awakesleepT,'awakesleepHFOFR.csv')
writetable(TLET,'TLEHFOFR.csv')
writetable(eTLET,'eTLEHFOFR.csv')

copyfile('awakesleepHFOFR.csv','C:\Users\THIENC\Desktop\CC-Linear-mixed-models-master')
copyfile('TLEHFOFR.csv','C:\Users\THIENC\Desktop\CC-Linear-mixed-models-master')
copyfile('eTLEHFOFR.csv','C:\Users\THIENC\Desktop\CC-Linear-mixed-models-master')
%% HFO counts between awake and sleep
clear
cd('D:\13.2.Zilin_HFO_anat_rPET\5.HFO_results')
statF = 'D:\13.2.Zilin_HFO_anat_rPET\6.StatisticData';
% match the channel first
subNames = GetFolders(pwd);
% Parameters
HFOawake = [];
HFOsleep = [];

HFOFRawake = [];
HFOFRsleep = [];

for i = 1:length(subNames)
    cd(subNames{i})
    disp(subNames{i})
    
    load HFOrate.mat
    load GrayNonArtChanMsk.mat
    
    % 4 trial combined, dimension reduction
    qHFO2Tawake = HFOrate.awake1.qHFO + ...
        HFOrate.awake2.qHFO;
    qHFO2Tsleep = HFOrate.sleep1.qHFO + ...
        HFOrate.sleep2.qHFO;
    
    qHFO2TFRawake = HFOrate.awake1.qHFOFR + ...
        HFOrate.awake2.qHFOFR;
    qHFO2TFRsleep = HFOrate.sleep1.qHFOFR + ...
        HFOrate.sleep2.qHFOFR;
    
    % For the correlation
    qHFOincludedAW    = qHFO2Tawake(finalChanMask);
    qHFOincludedSL    = qHFO2Tsleep(finalChanMask);
    
    qHFOFRincludedAW  = qHFO2TFRawake(finalChanMask);
    qHFOFRincludedSL  = qHFO2TFRsleep(finalChanMask);
    
    % Method 2 take this for it enables cross state r comparison
    qHFOincludedAW    = qHFOincludedAW + 1;
    qHFOincludedSL    = qHFOincludedSL + 1;
    
    qHFOFRincludedAW  = qHFOFRincludedAW + 1;
    qHFOFRincludedSL  = qHFOFRincludedSL + 1;
    
    qHFOincludedAW    = log10(qHFOincludedAW);
    qHFOincludedSL    = log10(qHFOincludedSL);
    
    qHFOFRincludedAW  = log10(qHFOFRincludedAW);
    qHFOFRincludedSL  = log10(qHFOFRincludedSL);
    
    
    HFOawake(i,1)  = mean(qHFOincludedAW);
    HFOsleep(i,1)  = mean(qHFOincludedSL);
    
    HFOFRawake(i,1)  = mean(qHFOFRincludedAW);
    HFOFRsleep(i,1)  = mean(qHFOFRincludedSL);
    
end

qHFOlog10T4PETtable = table(HFOawake,HFOsleep,HFOFRawake,HFOFRsleep);
%

kstest(HFOawake)
kstest(HFOsleep)

kstest(HFOFRawake)
kstest(HFOFRsleep)
[p,h]   = signrank(HFOawake,HFOsleep)
[p2,h2] = signrank(HFOFRawake,HFOFRsleep)


cd(statF)
writetable(qHFOlog10T4PETtable,'HFOHFOFRawakesleep.csv')
copyfile('HFOHFOFRawakesleep.csv','C:\Users\THIENC\Desktop\CC-Linear-mixed-models-master')

%% Age test with PET control
clear
cd('D:\10SPMPET')
ControlAge = importdata('PETNormAge.txt');
cd('D:\13.2.Zilin_HFO_anat_rPET')
TestAge = importdata('subAge.txt');
TestAge([10 15 27 36]) = [];

kstest(ControlAge)
[p,h] = ranksum(ControlAge,TestAge)

mean(ControlAge)
mean(TestAge)

%% test clinical info between TLE and eTLE
clear
cd('D:\13.2.Zilin_HFO_anat_rPET\6.StatisticData')
load TELclinicalCharacter.mat
TLEmsk  = (a(:,1) == 1);
eTLEmsk = (a(:,1) == 0);
% Age
TELage  = a(TLEmsk,2);
eTLEage = a(eTLEmsk,2);

[p,h, stats] = ranksum(TELage,eTLEage)
% Gender
TELele  = a(TLEmsk,5);
eTLEele = a(eTLEmsk,5);
TLEF  = sum(TELele)
TLEM  = length(TELele) - TLEF
eTLEF = sum(eTLEele)
eTLEM = length(eTLEele) - eTLEF

% N electrode
TELele  = a(TLEmsk,3);
eTLEele = a(eTLEmsk,3);
[p,h] = ranksum(TELele,eTLEele)

% Dur
TELdur  = a(TLEmsk,4);
eTLEdur = a(eTLEmsk,4);
kstest(TELdur)
[p,h] = ranksum(TELdur,eTLEdur)
mean(TELdur)
mean(eTLEdur)

%% r value counts
clear
cd('D:\13.2.Zilin_HFO_anat_rPET\6.StatisticData')
RPcounts = readtable('GroupCorrRP.csv')
sum(RPcounts.rHFO < 0)
sum(RPcounts.rHFOFR < 0)

%% clinical variable between good and bad surgical outcome group
clear
cd('D:\13.2.Zilin_HFO_anat_rPET\6.StatisticData')
load OutcomeGroupclincialVar.mat

% 'age',
% 'gender',
% 'epilepsy duration',...
% 'seizure type (TLE or eTLE)',
% 'number of electrodes',
% 'MRIpos1neg0'

Freemsk    = (ClincialVar(:,1) == 1);
Nonfreemsk = (ClincialVar(:,1) == 0);

% 'age', 2
% 'epilepsy duration',4
% 'number of electrodes',6
ClincialVarIndx = 6;
Goodage  = ClincialVar(Freemsk,ClincialVarIndx);
Badage   = ClincialVar(Nonfreemsk,ClincialVarIndx);
[p,h] = ranksum(Goodage,Badage)

% 'gender',3
% 'seizure type (TLE or eTLE)',5
% 'MRIpos1neg0'7
ClincialvarIndx = 7;
grouping = ClincialVar(:,1);
grouping(grouping == 3) = [];
Gender = ClincialVar(:,ClincialvarIndx);
Gender(ClincialVar(:,1) == 3) = [];
[conttbl,chi2,p,labels] = crosstab(grouping,Gender)

% GoodOut = ClincialVar(Freemsk,5);
% BadOut  = ClincialVar(Nonfreemsk,5);
% GoodF  = sum(GoodOut)
% GoodM  = length(GoodOut) - GoodF
% BadF   = sum(BadOut)
% BadM  = length(BadOut) - BadF

%% The ROC curve for fisher z and surgical outcome
clear
cd('D:\13.2.Zilin_HFO_anat_rPET\6.StatisticData')
Outcome = readtable('fisherzFreeNonfree.csv');

pred = Outcome.fisherZs;
resp = strcmp(Outcome.Labels,'Free');
mdl = fitglm(pred,resp,'Distribution','binomial','Link','logit');
scores = mdl.Fitted.Probability;
[X,Y,T,AUC] = perfcurve(Outcome.Labels,scores,'Free');
figure
plot(X,Y,'LineWidth',2,'Color',[101 161 197]./255)
xlabel('False positive rate')
ylabel('True positive rate')
title('ROC: Logistic Regression')
set(gca,'FontSize',18)
print('OutcomeAUC','-dpdf')
close
%% summary the number of bipolar channels
clear
cd('D:\13.2.Zilin_HFO_anat_rPET\5.HFO_results')
subNames = GetFolders(pwd);
% Parameters
for i = 1:length(subNames)
    cd(subNames{i})
    disp(subNames{i})
    load chanPETtVal.mat
    NBipChanTotal(i,1) = length(nSUVRaw);
end

cd('D:\13.2.Zilin_HFO_anat_rPET\6.StatisticData')

IncludedChanT = readtable('qHFOT4PETFullfinal.csv');

for i = 1:32

    NBipChanIN(i,1) = length(find(IncludedChanT.AnonymousID == i));
    
end

NEleTable = table(NBipChanTotal,NBipChanIN);
writetable(NEleTable,'TableSelectrodeNumber.csv')

%% Additional analysis comparing HS + FCD versus other pathology
% % Make the is HSFCD mask
% isHSFCD.inclusionMsk = [];
% isHSFCD.HSFCD = [];
% save('isHSFCD.mat','isHSFCD')

clear
cd('D:\13.2.Zilin_HFO_anat_rPET\6.StatisticData')

load isHSFCD.mat

TLEmsk  = and(isHSFCD.inclusionMsk,isHSFCD.HSFCD);
eTLEmsk = and(isHSFCD.inclusionMsk,~isHSFCD.HSFCD);

cd('D:\13.2.Zilin_HFO_anat_rPET\5.HFO_results')
statF = 'D:\13.2.Zilin_HFO_anat_rPET\6.StatisticData';


subNames = GetFolders(pwd);
assert(length(TLEmsk) == length(subNames))
% TEL and eTLE
PETincludedTLE = [];
PETincludedeTLE = [];

qHFOFRincludedTLE  = [];
qHFOFRincludedeTLE  = [];

% awake and sleep
PETincludedFull = [];

qHFOFRincludedAwake  = [];
qHFOFRincludedeSleep  = [];

CaseID      = [];
CaseIDTLE   = [];
CaseIDeTLE  = [];

AnonymousID = [];
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
    
    qHFO4TFR = HFOrate.awake1.qHFOFR + ...
        HFOrate.awake2.qHFOFR + ...
        HFOrate.sleep1.qHFOFR + ...
        HFOrate.sleep2.qHFOFR;
    
    % For the correlation
    qHFOFRincluded  = qHFO4TFR(finalChanMask);
    
    % Method 2 take this for it enables cross state r comparison
    qHFOFRincluded = qHFOFRincluded + 1;
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
    
    if TLEmsk(i)
        PETincludedTLE     = [PETincludedTLE;PETincluded];
        qHFOFRincludedTLE  = [qHFOFRincludedTLE;qHFOFRincluded];
        
        tempcaseID = [];
        [~,tempcase,~] = fileparts(subNames{i});
        tempcase  = {tempcase};
        tempcase  = repmat(tempcase,[length(PETincluded),1]);
        CaseIDTLE = [CaseIDTLE;tempcase];
    elseif eTLEmsk(i)
        PETincludedeTLE    = [PETincludedeTLE;PETincluded];
        qHFOFRincludedeTLE = [qHFOFRincludedeTLE;qHFOFRincluded];
        
        tempcaseID = [];
        [~,tempcase,~] = fileparts(subNames{i});
        tempcase  = {tempcase};
        tempcase  = repmat(tempcase,[length(PETincluded),1]);
        CaseIDeTLE = [CaseIDeTLE;tempcase];
    end
    
    PETincludedFull     = [PETincludedFull;PETincluded];
    
    qHFOFR2Tawake = HFOrate.awake1.qHFOFR + HFOrate.awake2.qHFOFR;
    qHFOFR2Tsleep = HFOrate.sleep1.qHFOFR + HFOrate.sleep2.qHFOFR;
    
    % For the correlation
    qHFOFRincludedawake  = qHFOFR2Tawake(finalChanMask);
    qHFOFRincludedsleep  = qHFOFR2Tsleep(finalChanMask);
    
    % Method 2 take this for it enables cross state r comparison
    qHFOFRincludedawake = qHFOFRincludedawake + 1;
    qHFOFRincludedawake = log10(qHFOFRincludedawake);
    
    qHFOFRincludedsleep = qHFOFRincludedsleep + 1;
    qHFOFRincludedsleep = log10(qHFOFRincludedsleep);
    
    qHFOFRincludedAwake  = [qHFOFRincludedAwake;qHFOFRincludedawake];
    qHFOFRincludedeSleep = [qHFOFRincludedeSleep;qHFOFRincludedsleep];
    
    tempcaseID = [];
    [~,tempcase,~] = fileparts(subNames{i});
    tempcase = {tempcase};
    tempcase = repmat(tempcase,[length(PETincluded),1]);
    CaseID         = [CaseID;tempcase];
    tempAnoID = repmat(i,[length(PETincluded),1]);
    AnonymousID    = [AnonymousID;tempAnoID];
end

awakesleepT = table(qHFOFRincludedAwake,qHFOFRincludedeSleep,PETincludedFull,CaseID,AnonymousID);
TLET  = table(qHFOFRincludedTLE,PETincludedTLE,CaseIDTLE);
eTLET = table(qHFOFRincludedeTLE,PETincludedeTLE,CaseIDeTLE);
%
cd(statF)

writetable(TLET,'HSFCDHFOFR.csv')
writetable(eTLET,'otherPathHFOFR.csv')

copyfile('HSFCDHFOFR.csv','C:\Users\THIENC\Desktop\CC-Linear-mixed-models-master')
copyfile('otherPathHFOFR.csv','C:\Users\THIENC\Desktop\CC-Linear-mixed-models-master')

%% The ROC curve for fisher z and surgical outcome
% 20220905 update: following the comments from reviewer 1
% Add cross validation strategy
clear
cd('D:\13.2.Zilin_HFO_anat_rPET\6.StatisticData')
Outcome = readtable('fisherzFreeNonfree.csv');

pred = Outcome.fisherZs;
resp = strcmp(Outcome.Labels,'Free'); % 1 for free, 0 for non free
mdl = fitglm(pred,resp,'Distribution','binomial','Link','logit');
scores = mdl.Fitted.Probability;
[X,Y,T,AUC] = perfcurve(Outcome.Labels,scores,'Free');

fullcohort = 1:28;
% Manual leave one out cross validation
for i = 1:28
    keepIdx = []; keepIdx = setdiff(fullcohort,i);
    
    % The leave one out strategy
    TempPred = pred(keepIdx);
    TempResp = resp(keepIdx);

%   take all the sample in fitting
%     TempPred = pred;
%     TempResp = resp;
    
    tempmdl = [];
    tempmdl = fitglm(TempPred,TempResp,'Distribution','binomial','Link','logit');
    CVlabel(i,1) = predict(tempmdl,pred(i));
end

[X2,Y2,T2,AUC2] = perfcurve(Outcome.Labels,CVlabel,'Free');

for i = 1:10
    Accuracy = mean((CVlabel > i * 0.1) == resp)
end

figure
plot(X2,Y2,'LineWidth',2,'Color',[101 161 197]./255)
xlabel('False positive rate')
ylabel('True positive rate')
title('ROC: Logistic Regression')
set(gca,'FontSize',18)
print('OutcomeAUC_CV','-dpdf')
close

%% Table S1: Max/90 percentile HFO rate (/min)
% Ignoring the latency section results
clear
cd('D:\13.2.Zilin_HFO_anat_rPET\5.HFO_results')
statF = 'D:\13.2.Zilin_HFO_anat_rPET\6.StatisticData';
% match the channel first
subNames = GetFolders(pwd);
% Parameters
qHFOFRincludedFull  = [];

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
    qHFO4TFR = HFOrate.awake1.qHFOFRrate + ...
        HFOrate.awake2.qHFOFRrate + ...
        HFOrate.sleep1.qHFOFRrate + ...
        HFOrate.sleep2.qHFOFRrate;
    
    qHFO4TFR = qHFO4TFR ./4;
    assert(length(qHFO4TFR) == length(finalChanMask))
    
    qHFO4TFRrateIncluded = qHFO4TFR(finalChanMask);
    maxFRrate(i,1)   = max(qHFO4TFRrateIncluded);
    pct90FRrate(i,1) = prctile(qHFO4TFRrateIncluded,90);
    
end

%
cd(statF)
save('MaxAnd90percentFRdistribution.mat','maxFRrate','pct90FRrate')

%% Add r values and 95% CI to the table S1
% For bar plot in R
clear
cd('D:\13.2.Zilin_HFO_anat_rPET\5.HFO_results')
statF = 'D:\13.2.Zilin_HFO_anat_rPET\6.StatisticData';
% match the channel first
subNames = GetFolders(pwd);
% Parameters
rHFO   = [];
rHFOFR = [];
pHFO   = [];
pHFOFR = [];
CaseID = [];
RLHFO  = [];
RUHFO  = [];

RLHFOFR = [];
RUHFOFR = [];

for i = 1:length(subNames)
    cd(subNames{i})
    disp(subNames{i})
    
    load chanPETtVal.mat
    load HFOrate.mat
    load GrayNonArtChanMsk.mat
    
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
    
    qHFOincluded   = qHFOincluded + 1;
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
    
    rHFO1 = []; pHFO1 = []; RLHFO1 = []; RUHFO1 = [];
    [rHFO1,pHFO1,RLHFO1,RUHFO1] = corrcoef(PETincluded,qHFOincluded);
    
    rHFOFR1 = [];pHFOFR1 = [];RLHFOFR1 = []; RUHFOFR1 = [];
    [rHFOFR1,pHFOFR1,RLHFOFR1,RUHFOFR1] = corrcoef(PETincluded,qHFOFRincluded);
    
    
    [rHFO(i,1),pHFO(i,1),RLHFO(i,1),RUHFO(i,1)] = deal(rHFO1(2),pHFO1(2),RLHFO1(2),RUHFO1(2));
    [rHFOFR(i,1),pHFOFR(i,1),RLHFOFR(i,1),RUHFOFR(i,1)] = deal(rHFOFR1(2),pHFOFR1(2),RLHFOFR1(2),RUHFOFR1(2));
    
    CaseID(i,1)  = i;
end


qHFOlog10T4PETtable = table(CaseID,rHFO,pHFO,RLHFO,RUHFO,...
                                   rHFOFR,pHFOFR,RLHFOFR,RUHFOFR);
%
cd(statF)
writetable(qHFOlog10T4PETtable,'GroupCorrRP95CI.csv')

%%




