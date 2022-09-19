%% deep elctrode plot The good outcome one
clear
locPath = 'D:\13.2.Zilin_HFO_anat_rPET\0.eleLoc\14HeQianqian';
HFOPath = 'D:\13.2.Zilin_HFO_anat_rPET\5.HFO_results\14HeQianqian';
addpath(genpath('C:\Users\THIENC\Desktop\iELVis-master'))
% Load the localization
cd(locPath)
load GrayEle.mat
% Load the HFO counts
cd(HFOPath)
load HFOrate.mat
load GrayNonArtChanMsk.mat

qHFO4TFR = HFOrate.awake1.qHFOFR + ...
    HFOrate.awake2.qHFOFR + ...
    HFOrate.sleep1.qHFOFR + ...
    HFOrate.sleep2.qHFOFR;

% For the correlation
qHFOFRincluded  = qHFO4TFR(finalChanMask);
% qHFOFRincluded  = qHFO4TFR;

% Method 2 take this for it enables cross state r comparison
qHFOFRincluded = qHFOFRincluded + 1;

qHFOFRincluded = log10(qHFOFRincluded);

% Match the names
chanIncluded = HFOchannels(finalChanMask);
% chanIncluded = HFOchannels;
MNIcorrIncluded  = [];
for pt = 1:length(chanIncluded)
    tempChan   = chanIncluded{pt};
    tempMNIcorr = [];
    tempMNICorrIndex = find(contains(EleNamesLoc,tempChan));
    assert(~isempty(tempMNICorrIndex))
    tempMNIcorr = CorrMNI(tempMNICorrIndex,:);
    MNIcorrIncluded(pt,:) = tempMNIcorr;
end

% based on HFOs frequency
% set color
colorOrigin = linspecer(length(chanIncluded));

qHFOsCounts = qHFOFRincluded;

[~,indexC] = sort(qHFOsCounts);
colorOrigin = colorOrigin(indexC,:);

FullMNI     = MNIcorrIncluded;
groupIsLeft = FullMNI(:,1) <=0;

color = colorOrigin;

BipolarNamesLabel = cellstr(string([1:size(FullMNI,1)]'));
BipolarNamesFinal = BipolarNamesLabel;
groupLabels = BipolarNamesFinal;


global globalFsDir;
globalFsDir='C:\Users\THIENC\Desktop\DepthElectrodePlot\FreesurferDir';
%
cfg=[];
if FullMNI(:,1) > 0
cfg.view='r';
else
    cfg.view='l';
end
cfg.ignoreDepthElec='n';
cfg.elecSize = 2.5;
cfg.elecColors=color;
cfg.elecColorScale=[0 1];
cfg.opaqueness=0.2;
cfg.elecShape='sphere';
cfg.elecCoord=[FullMNI groupIsLeft];
cfg.elecNames=groupLabels;
cfg.showLabels='y';
% cfg.elecUnits='r';
% cfg.title=['PT',num2str(sub)];
plotPialSurf('fsaverage',cfg);
colormap(linspecer)
min(qHFOsCounts)
max(qHFOsCounts)
%% The bad one
clear
locPath = 'D:\13.2.Zilin_HFO_anat_rPET\0.eleLoc\06GuoLiang';
HFOPath = 'D:\13.2.Zilin_HFO_anat_rPET\5.HFO_results\06GuoLiang';
addpath(genpath('C:\Users\THIENC\Desktop\iELVis-master'))
% Load the localization
cd(locPath)
load GrayEle.mat
% Load the HFO counts
cd(HFOPath)
load HFOrate.mat
load GrayNonArtChanMsk.mat

qHFO4TFR = HFOrate.awake1.qHFOFR + ...
    HFOrate.awake2.qHFOFR + ...
    HFOrate.sleep1.qHFOFR + ...
    HFOrate.sleep2.qHFOFR;

% For the correlation
qHFOFRincluded  = qHFO4TFR(finalChanMask);
% qHFOFRincluded  = qHFO4TFR;

% Method 2 take this for it enables cross state r comparison
qHFOFRincluded = qHFOFRincluded + 1;

qHFOFRincluded = log10(qHFOFRincluded);

% Match the names
chanIncluded = HFOchannels(finalChanMask);
% chanIncluded = HFOchannels;
MNIcorrIncluded  = [];
for pt = 1:length(chanIncluded)
    tempChan   = chanIncluded{pt};
    tempMNIcorr = [];
    tempMNICorrIndex = find(contains(EleNamesLoc,tempChan));
    assert(~isempty(tempMNICorrIndex))
    tempMNIcorr = CorrMNI(tempMNICorrIndex,:);
    MNIcorrIncluded(pt,:) = tempMNIcorr;
end

% based on HFOs frequency
% set color
colorOrigin = linspecer(length(chanIncluded));

qHFOsCounts = qHFOFRincluded;

[~,indexC] = sort(qHFOsCounts);
colorOrigin = colorOrigin(indexC,:);

FullMNI     = MNIcorrIncluded;
groupIsLeft = FullMNI(:,1) <=0;

color = colorOrigin;

BipolarNamesLabel = cellstr(string([1:size(FullMNI,1)]'));
BipolarNamesFinal = BipolarNamesLabel;
groupLabels = BipolarNamesFinal;


global globalFsDir;
globalFsDir='C:\Users\THIENC\Desktop\DepthElectrodePlot\FreesurferDir';
%
cfg=[];
if FullMNI(:,1) > 0
cfg.view='r';
else
    cfg.view='l';
end
cfg.ignoreDepthElec='n';
cfg.elecSize = 2.5;
cfg.elecColors=color;
cfg.elecColorScale=[0 1];
cfg.opaqueness=0.2;
cfg.elecShape='sphere';
cfg.elecCoord=[FullMNI groupIsLeft];
cfg.elecNames=groupLabels;
cfg.showLabels='y';
% cfg.elecUnits='r';
% cfg.title=['PT',num2str(sub)];
plotPialSurf('fsaverage',cfg);
colormap(linspecer)
min(qHFOsCounts)
max(qHFOsCounts)
%% The additional illustration case bad TLE case 09WangXiaoqian
clear
locPath = 'D:\13.2.Zilin_HFO_anat_rPET\0.eleLoc\09WangXiaoqian';
HFOPath = 'D:\13.2.Zilin_HFO_anat_rPET\5.HFO_results\09WangXiaoqian';
addpath(genpath('C:\Users\THIENC\Desktop\iELVis-master'))
% Load the localization
cd(locPath)
load GrayEle.mat
% Load the HFO counts
cd(HFOPath)
load HFOrate.mat
load GrayNonArtChanMsk.mat

qHFO4TFR = HFOrate.awake1.qHFOFR + ...
    HFOrate.awake2.qHFOFR + ...
    HFOrate.sleep1.qHFOFR + ...
    HFOrate.sleep2.qHFOFR;

% For the correlation
qHFOFRincluded  = qHFO4TFR(finalChanMask);
% qHFOFRincluded  = qHFO4TFR;

% Method 2 take this for it enables cross state r comparison
qHFOFRincluded = qHFOFRincluded + 1;

qHFOFRincluded = log10(qHFOFRincluded);

% Match the names
chanIncluded = HFOchannels(finalChanMask);
% chanIncluded = HFOchannels;
MNIcorrIncluded  = [];
for pt = 1:length(chanIncluded)
    tempChan   = chanIncluded{pt};
    tempMNIcorr = [];
    tempMNICorrIndex = find(contains(EleNamesLoc,tempChan));
    assert(~isempty(tempMNICorrIndex))
    tempMNIcorr = CorrMNI(tempMNICorrIndex,:);
    MNIcorrIncluded(pt,:) = tempMNIcorr;
end

% based on HFOs frequency
% set color
colorOrigin = linspecer(length(chanIncluded));

qHFOsCounts = qHFOFRincluded;

[~,indexC] = sort(qHFOsCounts);
colorOrigin = colorOrigin(indexC,:);

FullMNI     = MNIcorrIncluded;
groupIsLeft = FullMNI(:,1) <=0;

color = colorOrigin;

BipolarNamesLabel = cellstr(string([1:size(FullMNI,1)]'));
BipolarNamesFinal = BipolarNamesLabel;
groupLabels = BipolarNamesFinal;


global globalFsDir;
globalFsDir='C:\Users\THIENC\Desktop\DepthElectrodePlot\FreesurferDir';
%
cfg=[];
if FullMNI(:,1) > 0
cfg.view='r';
else
    cfg.view='l';
end
cfg.ignoreDepthElec='n';
cfg.elecSize = 2.5;
cfg.elecColors=color;
cfg.elecColorScale=[0 1];
cfg.opaqueness=0.2;
cfg.elecShape='sphere';
cfg.elecCoord=[FullMNI groupIsLeft];
cfg.elecNames=groupLabels;
cfg.showLabels='n';
% cfg.elecUnits='r';
% cfg.title=['PT',num2str(sub)];
plotPialSurf('fsaverage',cfg);
colormap(linspecer)
min(qHFOsCounts)
max(qHFOsCounts)

%% Plot the map from every subject
clear
addpath(genpath('C:\Users\THIENC\Desktop\iELVis-master'))
addpath(genpath('C:\Users\THIENC\Desktop\PET_SEEG'))

locPath = 'D:\13.2.Zilin_HFO_anat_rPET\0.eleLoc\09WangXiaoqian';
HFOPath = 'D:\13.2.Zilin_HFO_anat_rPET\5.HFO_results\09WangXiaoqian';

locRoot = 'D:\13.2.Zilin_HFO_anat_rPET\0.eleLoc\';
cd(locRoot)
locPathFull = GetFolders(pwd);
HFORoot = 'D:\13.2.Zilin_HFO_anat_rPET\5.HFO_results\';
cd(HFORoot)
HFOPathFull = GetFolders(pwd);

for i = 1:length(HFOPathFull)
    HFOPath = HFOPathFull{i};
    % Load the HFO counts
    cd(HFOPath)
    load HFOrate.mat
    load GrayNonArtChanMsk.mat
    
    [~,subName,~] = fileparts(HFOPathFull{i});
    
    % Load the localization
    locPath = [locRoot,subName];
    cd(locPath)
    load GrayEle.mat
    
    qHFO4TFR = HFOrate.awake1.qHFOFR + ...
        HFOrate.awake2.qHFOFR + ...
        HFOrate.sleep1.qHFOFR + ...
        HFOrate.sleep2.qHFOFR;
    
    % For the correlation
    qHFOFRincluded  = qHFO4TFR(finalChanMask);
    % qHFOFRincluded  = qHFO4TFR;
    
    % Method 2 take this for it enables cross state r comparison
    qHFOFRincluded = qHFOFRincluded + 1;
    
    qHFOFRincluded = log10(qHFOFRincluded);
    
    % Match the names
    chanIncluded = HFOchannels(finalChanMask);
    % chanIncluded = HFOchannels;
    MNIcorrIncluded  = [];
    for pt = 1:length(chanIncluded)
        tempChan   = chanIncluded{pt};
        tempMNIcorr = [];
        tempMNICorrIndex = find(contains(EleNamesLoc,tempChan));
        assert(~isempty(tempMNICorrIndex))
        tempMNIcorr = CorrMNI(tempMNICorrIndex,:);
        MNIcorrIncluded(pt,:) = tempMNIcorr;
    end
    
    % based on HFOs frequency
    % set color
    colorOrigin = linspecer(length(chanIncluded));
    
    qHFOsCounts = qHFOFRincluded;
    
    [~,indexC] = sort(qHFOsCounts);
    colorOrigin = colorOrigin(indexC,:);
    
    FullMNI     = MNIcorrIncluded;
    groupIsLeft = FullMNI(:,1) <=0;
    
    color = colorOrigin;
    
    BipolarNamesLabel = cellstr(string([1:size(FullMNI,1)]'));
    BipolarNamesFinal = BipolarNamesLabel;
    groupLabels = BipolarNamesFinal;
    
    
    global globalFsDir;
    globalFsDir='C:\Users\THIENC\Desktop\DepthElectrodePlot\FreesurferDir';
    %
    cfg=[];
    if FullMNI(:,1) > 0
        cfg.view='r';
    else
        cfg.view='l';
    end
    cfg.ignoreDepthElec='n';
    cfg.elecSize = 2.5;
    cfg.elecColors=color;
    cfg.elecColorScale=[0 1];
    cfg.opaqueness=0.2;
    cfg.elecShape='sphere';
    cfg.elecCoord=[FullMNI groupIsLeft];
    cfg.elecNames=groupLabels;
    cfg.showLabels='n';
    % cfg.elecUnits='r';
    % cfg.title=['PT',num2str(sub)];
    plotPialSurf('fsaverage',cfg);
    colormap(linspecer)
    print('HFOEledist','-dpng')
    close
end
%%















