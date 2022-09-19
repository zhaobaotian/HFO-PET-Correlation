function obj = LoadMatFiles(obj)
%LoadMatFiles Load .mat file including the behavior data and timestamps from PTB  
% FORMAT: obj = LoadMatFiles(obj)
% Input:
%       obj:  iEEG object need to load iEEG_MEEG
% Output:
%       obj:  iEEG object loaded with iEEG_MEEG
% --------------------------------------------------------------
% THIENC, Tiantan Human Intracranial Electrophysiology & Neuroscience Center

% Baotian Zhao 20190510
% zhaobaotian0220@foxmail.com

if ~isempty(obj.matFile)
    warning('matFile is not empty and will be erased and reloaded')
    obj.matFile = [];
end

[filename, path]       = uigetfile('*.mat','Please select .mat file to load','MultiSelect','on');
if ischar(filename)
    filename_full      = [path filename];
    obj.matFile{1} = filename_full;
elseif iscell(filename)
    filename_full = cellfun(@(x) [path x],filename,'UniformOutput',false);
    for i = 1:length(filename_full)
        obj.matFile{i} = filename_full{i};
    end   
else
    error('Please select proper .mat files')
end
end


