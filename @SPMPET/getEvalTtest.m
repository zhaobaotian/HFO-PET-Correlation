function obj = getEvalTtest(obj)
%GETEVALTTEST Evaluate the two sample ttest model

cd([obj.SysPath.MainSub,filesep,'Results'])

matFile = dir('SPM.mat');
matFile = [matFile.folder,filesep,matFile.name];
matlabbatch = [];
matlabbatch{1}.spm.stats.fmri_est.spmmat = {matFile};
matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;

spm('defaults', 'PET');
spm_jobman('run', matlabbatch);


end

