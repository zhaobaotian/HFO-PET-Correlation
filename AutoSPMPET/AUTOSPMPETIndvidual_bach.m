%% Path
addpath(genpath('C:\Users\THIENC\Desktop\THIENC_iEEG_Task_Preprocessing_Base'))
addpath(genpath('C:\Users\THIENC\Desktop\PET_SEEG'))
clear

%% Parameters
ResultsFolder     = 'D:\13.2.Zilin_HFO_anat_rPET\2.SPM_PET_Results';
CalcFolder        = 'D:\10SPMPET\Patients';
tempResultsFolder = 'D:\10SPMPET\Results';
% load the Age and Gender info
% Age in years
AgeList = textread('D:\13.2.Zilin_HFO_anat_rPET\subAge.txt');
% Set patient gender: female = 1; male = 0;
GenderList = textread('D:\13.2.Zilin_HFO_anat_rPET\subGender.txt');
%% Subject loop
cd('D:\13.2.Zilin_HFO_anat_rPET\1.subRAW')
subDir = dir();
subDir = subDir(3:end);
for i = 1:length(subDir)
    cd('D:\13.2.Zilin_HFO_anat_rPET\1.subRAW')
    cd(subDir(i).name)
    % copy the file to calculation folder
    status1 = copyfile('anat.nii',CalcFolder);
    status2 = copyfile('rPET.nii',CalcFolder);
    assert(status1)
    assert(status2)
    AUTOSPMPETIndvidual_func(AgeList(i),GenderList(i))
    cd(ResultsFolder)
    mkdir(subDir(i).name)
    cd(tempResultsFolder)
    % move the results to RESULTS folder
    Resultsfiles = [];
    Resultsfiles = dir();
    Resultsfiles = Resultsfiles(3:end);
    for j = 1:length(Resultsfiles)
        status3 = movefile(Resultsfiles(j).name,[ResultsFolder,filesep,subDir(i).name]);
        assert(status3)
    end
    % empty the patients folder after every calc
    cd(CalcFolder)
    delete('*')
    status4 = rmdir('Raw','s');
    status5 = rmdir('temp','s');
    assert(status4)
    assert(status5)
end










%
