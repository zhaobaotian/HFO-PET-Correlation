addpath(genpath('C:\Users\THIENC\Desktop\THIENC_iEEG_Task_Preprocessing_Base'))
addpath(genpath('C:\Users\THIENC\Desktop\PET_SEEG'))
clear
cd('D:\13.2.Zilin_HFO_anat_rPET\0.eleLoc')

%% Label all the channels as gray and white matter for channel selection
% Collect the data channels
cd('ElcLoc')
sub = GetFolders(pwd);
subNames = dir(pwd);
subNames = subNames(3:end);

for i = 1:length(sub)
    disp(sub{i})
    cd(sub{i})
    cd('implantation\')
    
    EleName   = dir('*Name.txt');
    EleName   = EleName(~contains({EleName.name},'MNI'));
    ElePos    = dir('*Pos.txt');
    ElePos    = ElePos(~contains({ElePos.name},'MNI'));
    EleMNIPos = dir('*MNI_Pos.txt');
    tgtDir = ['D:\13.2.Zilin_HFO_anat_rPET\0.eleLoc',filesep,subNames(i).name]
    mkdir(tgtDir)
    copyfile(EleName.name,tgtDir)
    copyfile(ElePos.name,tgtDir)
    copyfile(EleMNIPos.name,tgtDir)
    
    % The anatomy file
    cd(sub{i})
    cd('t1mri\')
    tempDir = GetFolders(pwd)
    assert(length(tempDir) == 1)
    cd(tempDir{1})
    
    anatFile   = dir('BNI*.nii');
    assert(~isempty(anatFile))
    assert(length(anatFile) == 1)
    copyfile(anatFile.name,tgtDir)   
    
end

%% Label all the channels
% Path
addpath(genpath('C:\Users\THIENC\Desktop\DELLO'))
addpath('C:\Users\THIENC\Desktop\spm12_7219')
addpath(genpath('C:\Users\THIENC\Desktop\THIENC_iEEG_Task_Preprocessing_Base'))
%
clear
% First we need to only include the gray matter electrode, but considering
% the bipolar montage is applied, we model location of the bipolar channe
% as in the middle point of the adjacent contacts.
% Make bipolar

cd('D:\13.2.Zilin_HFO_anat_rPET\0.eleLoc')
sub = [];
sub = GetFolders(pwd)';

for ii = 1:length(sub)
    disp(['Processing',sub{ii}])
    try
    cd(sub{ii})
    if exist('GrayEle.mat')
        continue
    end
    % Make bioplar
    MakeBipolarElectrodes
    
    clearvars -except sub ii
    
    % Process the data
    SegMRI
    
    % Atlas
    DepthEle = DepthElectrodes;
    
    % Parameters
    % DepthEle.WhiteMatterPercentageThreshold = 0.5; % At least 50% of surrounding voxel should be grey matter
    DepthEle.WhiteMatterPercentageThreshold = 0.9; % At least 90% of surrounding voxel should be grey matter
    
    AnatF     = dir('BNI*.nii');
    if isempty(AnatF)
        AnatF     = dir('FT*.nii');
        if isempty(AnatF)
            AnatF     = dir('Gre*.nii');
        end
    end
    
    GreyF     = dir('c1*.nii');
    EleName   = dir('*Name.txt');
    ElePos    = dir('*Pos.txt');
    ElePos    = ElePos(~contains({ElePos.name},'MNI'));
    EleMNIPos = dir('*MNI_Pos.txt');
    
    DepthEle.AnatFile            = AnatF.name;
    DepthEle.ElectrodeNameFile   = EleName.name;
    DepthEle.ElectrodePosFile    = ElePos.name;
    DepthEle.ElectrodePosMNIFile = EleMNIPos.name;
    
    DepthEle.BrainMask = 'BrainMask.nii';
    
    DepthEle.GreyMask  = GreyF.name;
    
    % Use AAL1
    DepthEle.AAL3Atlas  = 'C:\Users\THIENC\Desktop\DELLO\Atlas\rAutomated Anatomical Labeling (Tzourio-Mazoyer 2002).nii';
    DepthEle.Yeo7Atlas  = 'C:\Users\THIENC\Desktop\DELLO\Atlas\Yeo2011_7Networks_MNI152 (Yeo 2011).nii';
    DepthEle.AAL3LabelsFile = 'C:\Users\THIENC\Desktop\DELLO\Atlas\Automated Anatomical Labeling (Tzourio-Mazoyer 2002).txt';
    DepthEle.Yeo7LabelsFile = 'C:\Users\THIENC\Desktop\DELLO\Atlas\Yeo2011_7Networks_MNI152 (Yeo 2011).txt';
    
    DepthEle.ReadData;
    
    % Overwrite the names and coordinates with bipolar information
    load('BipolarChannelCorr.mat')
    DepthEle.ElectrodeName   = BipolarNames;
    DepthEle.ElectrodePos    = CorrNativeBipolar;
    DepthEle.ElectrodePosMNI = CorrMNIBipolar;
    
    DepthEle.LabelOutBrainElectrodes;
    DepthEle.LabelWhiteMatterElectrodes;
    DepthEle.LabelAAL3
    DepthEle.LabelYeo7
    DepthEle.ExportResultTable
    catch
        diary D:\13.2.Zilin_HFO_anat_rPET\locPrecLog.txt
        disp(['Failed: ',sub{ii}])
        diary off
        continue
    end
    
%     cd ..
end


%%

