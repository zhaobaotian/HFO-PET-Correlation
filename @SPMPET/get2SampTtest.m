function obj = get2SampTtest(obj)
%GET2SAMPTTEST Perform two sample ttest between group 1 and group 2

% files of group 1
cd(obj.SysPath.SubPath)
obj.Tst.SubPET = dir('*.nii');

grp1 = cell(length(obj.Tst.SubPET),1);
for i = 1:length(obj.Tst.SubPET)
    grp1{i} = [obj.Tst.SubPET(i).folder,filesep,obj.Tst.SubPET(i).name,',1']; % Factorial design specification: Group 1 scans - cfg_files
end

cd(obj.SysPath.CtlPath)
obj.Ctl.SubPET = dir('*.nii');

grp2 = cell(length(obj.Ctl.SubPET),1);
for j = 1:length(obj.Ctl.SubPET)
    grp2{j} = [obj.Ctl.SubPET(j).folder,filesep,obj.Ctl.SubPET(j).name,',1']; % Factorial design specification: Group 2 scans - cfg_files
end

cd(obj.SysPath.MainSub)
mkdir('Results')

nrun = 1; % enter the number of runs here
% jobfile = {'D:\10SPMPET\ttest2_job.m'};
% jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
for crun = 1:nrun
end
matlabbatch = [];
matlabbatch{1}.spm.stats.factorial_design.dir = {[obj.SysPath.MainSub,filesep,'Results']};
%%
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1 = grp1;
%%
%%
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2 = grp2;
%%
matlabbatch{1}.spm.stats.factorial_design.des.t2.dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.t2.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.ancova = 0;
%%
matlabbatch{1}.spm.stats.factorial_design.cov(1).c = [obj.Tst.Age;obj.Ctl.Age];
%%
matlabbatch{1}.spm.stats.factorial_design.cov(1).cname = 'Age';
matlabbatch{1}.spm.stats.factorial_design.cov(1).iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov(1).iCC = 1;
%%
matlabbatch{1}.spm.stats.factorial_design.cov(2).c = [obj.Tst.Gender;obj.Ctl.Gender];
%%
matlabbatch{1}.spm.stats.factorial_design.cov(2).cname = 'Gender';
matlabbatch{1}.spm.stats.factorial_design.cov(2).iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov(2).iCC = 1;
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {[obj.Mask.Brain,',1']};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

spm('defaults', 'PET');
spm_jobman('run', matlabbatch, inputs{:});
end

