function obj = LoadTriggerMEEG(obj)
%LoadTriggerMEEG Load trigger MEEG
% FORMAT: obj = LoadTriggerMEEG(obj)
% Input:
%       obj:  iEEG object need to load trigger MEEG
% Output:
%       obj:  iEEG object loaded with trigger MEEG
% --------------------------------------------------------------
% THIENC, Tiantan Human Intracranial Electrophysiology & Neuroscience Center

% Baotian Zhao 20190507
% zhaobaotian0220@foxmail.com

if ~isempty(obj.Trigger_MEEG)
    warning('Trigger_MEEG is not empty and will be erased and reloaded')
end

obj.Trigger_MEEG = [];
[filename, path]       = uigetfile('*.mat','Please select TRIGGER MEEG mat file to load','MultiSelect','on');
if ischar(filename)
    filename_full      = [path filename];
    obj.Trigger_MEEG{1} = spm_eeg_load(filename_full);
elseif iscell(filename)
    filename_full = cellfun(@(x) [path x],filename,'UniformOutput',false);
    for i = 1:length(filename_full)
        obj.Trigger_MEEG{i} = spm_eeg_load(filename_full{i});
    end   
else
    error('Please select proper MEEG mat files')
end
end

