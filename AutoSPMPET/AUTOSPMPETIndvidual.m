%% Path
% Paths
clear classes
addpath(genpath('C:\Users\THIENC\Desktop\PET_SEEG'))
sPET = SPMPET;
%% Parameters
sPET.isInd      = 1; % Set to 1 for individual
sPET.Tst.Age    = 19; % Set patient age
sPET.Tst.Gender = 0; % Set patient gender: female = 1; male = 0;

sPET.SysPath.Main    = 'D:\PET_SEEG';
sPET.SysPath.SubPath = 'D:\10SPMPET\Patients';
sPET.SysPath.SPM     = 'C:\Users\THIENC\Desktop\spm12_7219';
sPET.SysPath.MainSub = 'D:\10SPMPET';
sPET.SysPath.CtlPath = 'D:\10SPMPET\PETNorm52niiMNIcereb';
sPET.GauSmooth       = [8 8 8];

%% Prerocessing
sPET.getSetPath
sPET.getLoadData
sPET.getNormSpaPts
sPET.getNormIntensityPts
sPET.getSmoothPts

%% Two sample ttest
sPET.get2SampTtest

sPET.getEvalTtest
sPET.getContrastResult
%% Save results
sPET.getSave