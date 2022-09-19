%% Use ielvis, change the electrode size

%% Path
addpath(genpath('C:\Users\THIENC\Desktop\ecog_fmri_visualization_matlab-master'))

cd('C:\Users\THIENC\Desktop\ecog_fmri_visualization_matlab-master')

%% Parameters
fsDir = 'D:\FreesurferDir\fsaverage';

%%
% load the MNI corr
brain_data = read_freesurfer_brain(fsDir);
% load the elec info


% Make the plot
% ------------ Parameters ----------
spheR = 1; % sphere radius


% ----------------------------------