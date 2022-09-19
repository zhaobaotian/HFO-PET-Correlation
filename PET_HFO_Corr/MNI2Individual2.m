% List of open inputs
% Normalise: Write: Deformation Field - cfg_files
% Normalise: Write: Images to Write - cfg_files
nrun = X; % enter the number of runs here
jobfile = {'C:\Users\THIENC\Desktop\PET_SEEG\PET_HFO_Corr\MNI2Individual2_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(2, nrun);
for crun = 1:nrun
    inputs{1, crun} = MATLAB_CODE_TO_FILL_INPUT; % Normalise: Write: Deformation Field - cfg_files
    inputs{2, crun} = MATLAB_CODE_TO_FILL_INPUT; % Normalise: Write: Images to Write - cfg_files
end
spm('defaults', 'PET');
spm_jobman('run', jobs, inputs{:});
