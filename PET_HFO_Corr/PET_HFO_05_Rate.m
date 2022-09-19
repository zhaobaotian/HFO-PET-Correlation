%% Organize the results
clear
HFOResultsFolder = 'D:\13.2.Zilin_HFO_anat_rPET\HFOResults';
PETResultsFolder = 'D:\13.2.Zilin_HFO_anat_rPET\2.SPM_PET_Results';
LocResultsFolder = 'D:\13.2.Zilin_HFO_anat_rPET\0.eleLoc';
TargetFolder     = 'D:\13.2.Zilin_HFO_anat_rPET\3.PET-HFO-rate-corr';
TargetFolderSPMPET = 'D:\13.2.Zilin_HFO_anat_rPET\2.SPM_PET_Results';
%% Move HFO results and make folders
cd(HFOResultsFolder)
TgtFolderNames = dir('*.xlsx');
cd(TargetFolder)
for i = 1:length(TgtFolderNames)
    mkdir(TgtFolderNames(i).name(1:end-5))
end
cd(HFOResultsFolder)
for i = 1:length(TgtFolderNames)
    copyfile(TgtFolderNames(i).name,[TargetFolder,filesep,TgtFolderNames(i).name(1:end-5)])
end

%% Move SPM T results
cd(PETResultsFolder)
PETfolders = dir();
PETfolders = PETfolders(3:end);
for i = 1:length(PETfolders)
    cd(PETfolders(i).name)
    
    tempTgtFolders = [];
    caseID         = [];
    for j = 1:length(TgtFolderNames)
        caseID{j} = TgtFolderNames(j).name(1:2);
    end
    caseID = caseID';
    caseID = str2num(cell2mat(caseID));
    tempTgtFolders = TgtFolderNames(find(caseID == i));
    
    for k = 1:length(tempTgtFolders)
        copyfile('spmT_0001.nii',[TargetFolder,filesep,tempTgtFolders(k).name(1:end-5)])
    end
    
    cd ..
end

%% Move file localization files
cd(LocResultsFolder)
subNames = GetFolders(pwd);
for i = 1:length(subNames)
    cd(subNames{i})
    % copy the location files
    tempName = []
    [~,tempName] = fileparts(subNames{i});
    copyfile('GrayEle.mat',[TargetFolderSPMPET, filesep, tempName])
end

%% Extract the T values
% Make bipolar mask info
clear
cd('D:\13.2.Zilin_HFO_anat_rPET\2.SPM_PET_Results')
subF = GetFolders(pwd);
for i = 1:length(subF)
    cd(subF{i})
    disp(subF{i})
    load('GrayEle.mat')
    T1          = 'spmT_0001.nii';
    BipolarName = [];
    BipolarName = EleNamesLoc;
    BipolarPos  = [];
    BipolarPos  = CorrMNI;
    Radius      = 3; %%%%%%%%%%%%%%%%% IMPORTANT PARAMETER
    BipolarContactsMaskSphere(T1,BipolarName,BipolarPos,Radius)
    
    % Extract T values of individual SPM PET
    BipolarGreyMasks = [];
    BipolarGreyMasks = dir('RawBipContactsMask\*.nii');
    BipolarGreyMasks = {BipolarGreyMasks.name}';
    BipolarGreyMasks = cellfun(@(x) ['.\RawBipContactsMask\' x],BipolarGreyMasks,'UniformOutput',false);
    
    % Extract raw T values
    BipolarGreyMasks = natsortfiles(BipolarGreyMasks);
    nrPET = 'spmT_0001.nii';
    [ChanNames,nSUVRaw] = ExtractIndividualSUV(nrPET,BipolarGreyMasks);
    save('chanPETtVal.mat','ChanNames','nSUVRaw','Radius')
end

%% HFO channel selection
% First do the auto detection, then manual labeling
clear
cd('D:\13.2.Zilin_HFO_anat_rPET\3.PET-HFO-rate-corr')
subHFO = GetFolders(pwd);
HFONoisyThresh = 0.5;
for i = 1:length(subHFO)
    
    cd(subHFO{i})
    disp(subHFO{i})
    if exist('chanLabeled.mat')
        continue
    end
    HFOexcel = dir('*.xlsx');
    HFOResults = [];
    ChanLabels = [];
    [HFOResults,ChanLabels,~] = xlsread(HFOexcel.name);
    ChanLabels = ChanLabels(2:end,1);
    
    % Exclude some noisy channels by setting threshold on the qualify/candidate
    ArtifactInd = (HFOResults(:,3)./HFOResults(:,1)) < 1 - HFONoisyThresh;
    
    % Match the channel in the gray matter labeling
    load('GrayEle.mat')
    
    ChanLabelsPET = EleNamesLoc;
    
    % Match the channels
    ChanLGray = [];
    for j = 1:length(ChanLabels)
        tempInd = find(contains(ChanLabelsPET,ChanLabels{j}));
        if isempty(tempInd)
            error('HFO and PET channel mismatch')
        end
        ChanLGray(j,1) = IsGray(tempInd);
    end
    assert(length(ChanLGray) == length(ArtifactInd))
    
    % Take the intersection of the channel inclusion
    InterseMask = [];
    InterseMask = or(~ChanLGray,ArtifactInd);
    
    % Add the artifact index to the last colume
    xlRange1 = 'H1';
    xlswrite(HFOexcel.name,{'Inclusion'},1,xlRange1)
    xlRange2 = 'H2';
    xlswrite(HFOexcel.name,double(~InterseMask),1,xlRange2)
    meaningless = 0;
    save('chanLabeled.mat','meaningless')
end

%% HFO results exportion
clear
cd('D:\13.2.Zilin_HFO_anat_rPET\3.PET-HFO-rate-corr')
subHFO = GetFolders(pwd);
HFOResultsDir = 'D:\13.2.Zilin_HFO_anat_rPET\5.HFO_results';

for i = 1:36
    tempOnsetIndx  = (i - 1) * 4 + 1;
    tempOffsetIndx = (i - 1) * 4 + 4;
    HFOrate = [];
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
        mkdir(tgtDirResults)
        
        HFOexcel    = dir('*.xlsx');
        HFOResults  = [];
        ChanLabels  = [];
        
        [HFOResults,ChanLabels,~] = xlsread(HFOexcel.name);
        
        assert(~isempty(HFOResults))
        assert(~isempty(ChanLabels))
        
        ChanLabels    = ChanLabels(2:end,1);
        
        qHFO          = [];
        qHFOrate      = [];
        qHFOFR        = [];
        qHFOFRrate    = [];
        chanInclusion = [];
        
        qHFO          = HFOResults(:,3);
        qHFOrate      = HFOResults(:,4);
        qHFOFR        = HFOResults(:,5);
        qHFOFRrate    = HFOResults(:,6);
        chanInclusion = HFOResults(:,7);
        
        switch tempSubState
            case 'awake1'
                HFOrate.awake1.chanLabels    = ChanLabels;
                HFOrate.awake1.qHFO          = qHFO;
                HFOrate.awake1.qHFOrate      = qHFOrate;
                HFOrate.awake1.qHFOFR        = qHFOFR;
                HFOrate.awake1.qHFOFRrate    = qHFOFRrate;
                HFOrate.awake1.chanInclusion = chanInclusion;
            case 'awake2'
                HFOrate.awake2.chanLabels    = ChanLabels;
                HFOrate.awake2.qHFO          = qHFO;
                HFOrate.awake2.qHFOrate      = qHFOrate;
                HFOrate.awake2.qHFOFR        = qHFOFR;
                HFOrate.awake2.qHFOFRrate    = qHFOFRrate;
                HFOrate.awake2.chanInclusion = chanInclusion;
            case 'sleep1'
                HFOrate.sleep1.chanLabels    = ChanLabels;
                HFOrate.sleep1.qHFO          = qHFO;
                HFOrate.sleep1.qHFOrate      = qHFOrate;
                HFOrate.sleep1.qHFOFR        = qHFOFR;
                HFOrate.sleep1.qHFOFRrate    = qHFOFRrate;
                HFOrate.sleep1.chanInclusion = chanInclusion;
            case 'sleep2'
                HFOrate.sleep2.chanLabels    = ChanLabels;
                HFOrate.sleep2.qHFO          = qHFO;
                HFOrate.sleep2.qHFOrate      = qHFOrate;
                HFOrate.sleep2.qHFOFR        = qHFOFR;
                HFOrate.sleep2.qHFOFRrate    = qHFOFRrate;
                HFOrate.sleep2.chanInclusion = chanInclusion;
        end
    end
    assert(~isempty(HFOrate))
    cd(tgtDirResults)
    save('HFOrate.mat','HFOrate')
end

%% Do the correlation within the gray matter channels











