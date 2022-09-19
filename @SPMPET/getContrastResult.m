function obj = getContrastResult(obj)
%GETCONTRASTRESULT Contrast the results

cd([obj.SysPath.MainSub,filesep,'Results'])

matFile = dir('SPM.mat');
matFile = [matFile.folder,filesep,matFile.name];
matlabbatch = [];
matlabbatch{1}.spm.stats.con.spmmat = {matFile};
matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'SPMPET';
matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = [1 -1];
matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.delete = 0;

spm('defaults', 'PET');
spm_jobman('run', matlabbatch);

end

