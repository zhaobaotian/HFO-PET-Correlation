function obj = getFlipPts(obj)
%GETFLIPPTS flip the images

cd(obj.SysPath.SubPath)

PETs = dir('*.nii');
PETsnames = {PETs.name};
% Select those need to be flipped
[index_to_keep,~]  = listdlg('ListString',PETsnames,'PromptString',...
    'Select images to flip');
PETsnames = PETsnames(index_to_keep);

nrun = length(PETsnames); % enter the number of runs here

for i = 1:nrun
    [~,FlpFileNames{i},~] = fileparts(PETsnames{i});
end

inputs = cell(1, nrun);
for crun = 1:nrun
    inputs{1, crun} = PETsnames(crun); % Image Calculator: Input Images - cfg_files
end

matlabbatch = cell(1, nrun);
for crun = 1:nrun
    matlabbatch{crun}.spm.util.imcalc.input = '<UNDEFINED>';
    matlabbatch{crun}.spm.util.imcalc.output = [FlpFileNames{crun},'_Fliped'];
    matlabbatch{crun}.spm.util.imcalc.outdir = {''};
    matlabbatch{crun}.spm.util.imcalc.expression = 'flip(i1)';
    matlabbatch{crun}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{crun}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{crun}.spm.util.imcalc.options.mask = 0;
    matlabbatch{crun}.spm.util.imcalc.options.interp = 1;
    matlabbatch{crun}.spm.util.imcalc.options.dtype = 8;
end

spm('defaults', 'pet');
spm_jobman('initcfg');
spm_jobman('run', matlabbatch, inputs{:});

if ~exist('temp','dir')
    mkdir('temp')  % For the temporary files
end

for i = 1:length(PETsnames)
    movefile(PETsnames{i},'temp')
end

end

