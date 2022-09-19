function obj = getSmoothCtl(obj)
%GETSMOOTHCTL smooth the control group
% For controls
% Free the vars

cd(obj.SysPath.CtlPath)
PETs = dir('*.nii');
PETsnames = {PETs.name};
nrun = length(PETsnames); % enter the number of runs here

inputs = cell(1, nrun);
for crun = 1:nrun
    inputs{1, crun} = PETsnames(crun); % Smooth: Images to smooth - cfg_files
end

matlabbatch = cell(1, nrun);
for i = 1:nrun
    matlabbatch{i}.spm.spatial.smooth.data = '<UNDEFINED>';
    matlabbatch{i}.spm.spatial.smooth.fwhm = obj.GauSmooth;
    matlabbatch{i}.spm.spatial.smooth.dtype = 0;
    matlabbatch{i}.spm.spatial.smooth.im = 0;
    matlabbatch{i}.spm.spatial.smooth.prefix = ['s',num2str(obj.GauSmooth(1)),'_'];
end

spm('defaults', 'pet');
spm_jobman('initcfg');
spm_jobman('run', matlabbatch, inputs{:});

% move all the previous data to seperate folders
if ~exist('temp','dir')
    mkdir('temp')  % For the temporary files
end

filelist = dir('*.nii');
filelist = filelist(~startsWith({filelist.name}, ['s',num2str(obj.GauSmooth(1)),'_']));
for i = 1:length(filelist)
    movefile(filelist(i).name,'temp')
end

end

