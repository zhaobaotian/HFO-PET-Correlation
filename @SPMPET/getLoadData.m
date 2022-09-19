function obj = getLoadData(obj)
%GETLOADDATA load all the necessary data for processing

% Load the control data
cd(obj.SysPath.CtlPath)
obj.Ctl.SubPET = dir('*.nii');
obj.Ctl.SubPET = {obj.Ctl.SubPET.name};
% Covariates
cd(obj.SysPath.MainSub)
obj.Ctl.Age    = importdata('PETNormAge.txt');
obj.Ctl.Gender = importdata('PETNormGender.txt');

% Double check
assert(isequal(length(obj.Ctl.SubPET),length(obj.Ctl.Age),length(obj.Ctl.Gender)))

% Load the test Data
if ~obj.isInd
cd(obj.SysPath.SubPath)
obj.Tst.SubPET = dir('*.nii');
obj.Tst.SubPET = {obj.Tst.SubPET.name};
% Covariates
obj.Tst.Age    = importdata('Age.txt');
obj.Tst.Gender = importdata('Gender.txt'); % female = 1; male = 0;
% Double check
assert(isequal(length(obj.Tst.SubPET),length(obj.Tst.Age),length(obj.Tst.Gender)))
end
    
% Templates
obj.Mask.Brain = [obj.SysPath.MainSub,filesep,'Templates',filesep,'mask_ICV.nii'];
obj.Mask.Cereb = [obj.SysPath.MainSub,filesep,'Templates',filesep,'Desikan-Killiany_MNI_cerebellum.nii'];

end

