function obj = getNormSpaPts(obj)
%GETNORMSPAPTS Spatially normalize the PET of patients

cd(obj.SysPath.SubPath)
if ~obj.isInd
    anats = dir('*anat.nii');
    PETs = dir('*pet.nii');
elseif obj.isInd
    anats = dir('a*.nii');
    PETs = dir('r*.nii');   
end



anatsnames = {anats.name};
PETsnames = {PETs.name};

nrun = length(PETsnames); % enter the number of runs here
inputs = cell(2, nrun);
for crun = 1:nrun
    inputs{1, crun} = anatsnames(crun); % Normalise: Estimate & Write: Image to Align - cfg_files
    inputs{2, crun} = PETsnames(crun); % Normalise: Estimate & Write: Images to Write - cfg_files
end

matlabbatch = cell(1,nrun);
for crun = 1:nrun
    matlabbatch{crun}.spm.spatial.normalise.estwrite.subj.vol = '<UNDEFINED>';
    matlabbatch{crun}.spm.spatial.normalise.estwrite.subj.resample = '<UNDEFINED>';
    matlabbatch{crun}.spm.spatial.normalise.estwrite.eoptions.biasreg = 0.0001;
    matlabbatch{crun}.spm.spatial.normalise.estwrite.eoptions.biasfwhm = 60;
    matlabbatch{crun}.spm.spatial.normalise.estwrite.eoptions.tpm = {[obj.SysPath.SPM,filesep,'tpm',filesep,'TPM.nii']};
    matlabbatch{crun}.spm.spatial.normalise.estwrite.eoptions.affreg = 'mni';
    matlabbatch{crun}.spm.spatial.normalise.estwrite.eoptions.reg = [0 0.001 0.5 0.05 0.2];
    matlabbatch{crun}.spm.spatial.normalise.estwrite.eoptions.fwhm = 0;
    matlabbatch{crun}.spm.spatial.normalise.estwrite.eoptions.samp = 3;
    matlabbatch{crun}.spm.spatial.normalise.estwrite.woptions.bb = [-78 -112 -70
        78 76 85];
    matlabbatch{crun}.spm.spatial.normalise.estwrite.woptions.vox = [1 1 1];
    matlabbatch{crun}.spm.spatial.normalise.estwrite.woptions.interp = 4;
    matlabbatch{crun}.spm.spatial.normalise.estwrite.woptions.prefix = 'w_';
end


spm('defaults', 'pet');
spm_jobman('initcfg');
spm_jobman('run', matlabbatch, inputs{:});

% move all the previous data to seperate folders
mkdir('Raw')   % For the raw images
mkdir('temp')  % For the temporary files

movefile('y_*.nii','temp')

filelist = dir('*.nii');
filelist = filelist(~startsWith({filelist.name}, 'w_'));
for i = 1:length(filelist)
    movefile(filelist(i).name,'Raw')
end

end

