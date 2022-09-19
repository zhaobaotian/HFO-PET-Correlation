function obj = EpochiEEG(obj,buffer)
%EpochiEEG epoch iEEG data
% FORMAT: obj = EpochiEEG(obj,buffer)
% Input:
%       obj: Must be loaded with properties: EpochWin, DCTriggers 
%       buffer: Time buffer pre and post time of interest for TF transform, default: 1s
% Output:
%       obj: iEEG object with epoched data
% --------------------------------------------------------------
% THIENC, Tiantan Human Intracranial Electrophysiology & Neuroscience Center

% Baotian Zhao 20190510
% zhaobaotian0220@foxmail.com
if isempty(obj.iEEG_MEEG) || isempty(obj.DCTriggers)
    error('iEEG_MEEG/DCTriggers is missing')
end

if isempty(obj.EpochWin)
    warning('Epoch time window is empty and set to [-500 100] as default')
    obj.EpochWin = [-500 1000];
end

if length(obj.iEEG_MEEG) ~= length(obj.DCTriggers)
    error('Number of iEEG_MEEG & DCTriggers mismatch')
end

if nargin < 2 || isempty(buffer)
    buffer = 1; % in second
end

for i = 1:length(obj.iEEG_MEEG)
    % define the trl
    for j = 1:length(obj.DCTriggers{i})
        trl(j,1) = obj.DCTriggers{i}(j)*obj.iEEG_MEEG{i}.fsample - abs(obj.EpochWin(1)) - buffer*obj.iEEG_MEEG{i}.fsample;
        trl(j,2) = obj.DCTriggers{i}(j)*obj.iEEG_MEEG{i}.fsample + abs(obj.EpochWin(2)) + buffer*obj.iEEG_MEEG{i}.fsample;
        trl(j,3) = obj.EpochWin(1) - buffer*obj.iEEG_MEEG{i}.fsample;
    end
    clear S
    S.D = obj.iEEG_MEEG{i};
    S.bc = 1;
    S.trl = trl;
    S.prefix = 'e';
    D = spm_eeg_epochs(S);
    save(D)
    obj.iEEG_MEEG{i} = D;
end




end

