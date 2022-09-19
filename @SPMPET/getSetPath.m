function obj = getSetPath(obj)
%GETSETPATH set environment paths

if isempty(obj.SysPath.Main)
    error('Please add the script folders')
end

if isempty(obj.SysPath.SPM)
    error('Please add the script folders')
end

if isempty(obj.SysPath.SubPath)
    error('Please define the subject folder')
end

if isempty(obj.SysPath.CtlPath)
error('Please define the control subject folder')
end

if isempty(obj.SysPath.MainSub)
error('Please define the control subject folder')
end

% Add paths
addpath(obj.SysPath.SPM)
addpath(genpath(obj.SysPath.Main))

if ~exist('spm','file') % Check the path of SPM
    error('Please add SPM folder first')
end
spm('defaults','PET') % Initialize SPM PET module


end

