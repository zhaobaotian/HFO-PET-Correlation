%% Path
% Paths
clear classes
addpath(genpath('D:\PET_SEEG'))
sPET = SPMPET;
%% Parameters
sPET.SysPath.Main    = 'D:\PET_SEEG';
sPET.SysPath.SubPath = 'D:\10SPMPET\Patients';
sPET.SysPath.SPM     = 'D:\spm12_7219';
sPET.SysPath.MainSub = 'D:\10SPMPET';
sPET.SysPath.CtlPath = 'D:\10SPMPET\PETNorm52niiMNIcereb';
sPET.GauSmooth = [8 8 8];

%% Prerocessing
sPET.getSetPath
sPET.getLoadData
sPET.getNormSpaPts
sPET.getNormIntensityPts
sPET.getSmoothPts
sPET.getSmoothCtl
sPET.getFlipPts
%% Two sample ttest
sPET.get2SampTtest
sPET.getEvalTtest
sPET.getContrastResult
%% Save results
sPET.getSave