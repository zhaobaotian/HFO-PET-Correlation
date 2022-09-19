function obj = SetBadChannels(obj,BadChannel)
%SetBadChannels detect bad channels and label them as bad in SPM meeg object
% FORMAT: obj = Converter_EDF(filename,index_to_keep,prefix)
% Input:
%       BadChannel: Manually input bad channels index of the CONVERTED
%                   FILE, it is empty by default
% Output:
%       obj:        iEEG object loaded with MEEG
% --------------------------------------------------------------
% THIENC, Tiantan Human Intracranial Electrophysiology & Neuroscience Center

% Baotian Zhao 20190507
% zhaobaotian0220@foxmail.com

if nargin < 2 || isempty(BadChannel)
    BadChannel = [];
end

% if ~isempty(obj.BadChan)
%     BadChannel = obj.BadChan;
% end

% Below is code Written by J. Schrouff and S. Bickel, 07/27/2015, LBCN, Stanford
% Try file name first
try
    file = [];
    for i = 1:length(obj.iEEG_MEEG)
        file = [file;obj.iEEG_MEEG{i}.fname];
    end
    obj.iEEG_MEEG = LBCN_filter_badchans_China(file,[],BadChannel);
    
    % Feed full names if the previous code does not work
catch
    file = [];
    for i = 1:length(obj.iEEG_MEEG)
        file = [file;obj.iEEG_MEEG{i}.fullfile];
    end
    obj.iEEG_MEEG = LBCN_filter_badchans_China(file,[],BadChannel);    
end
end