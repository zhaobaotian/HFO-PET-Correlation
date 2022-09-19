function obj = GetDCTimeStamps(obj)
%GetDCTimeStamps Extract trigger timestamps from DC channels
% FORMAT: GetDCTimeStamps(obj)
% Input:
%       obj:  iEEG object loaded with Trigger_MEEG property used for epoch
% Output:
%       obj:  iEEG object loaded with DCTriggers property
% --------------------------------------------------------------
% THIENC, Tiantan Human Intracranial Electrophysiology & Neuroscience Center

% Baotian Zhao 20190510
% zhaobaotian0220@foxmail.com

if isempty(obj.Trigger_MEEG)
    error('Please load Trigger_MEEG using like: obj.Converter_EDF([],[],[],1)')
end
for i = 1:length(obj.Trigger_MEEG)
    obj.DCTriggers{i} = FindCCEPTriggers(obj.Trigger_MEEG{i});
end
DCTriggers = obj.DCTriggers;
save('eventTriggersTimeStamps.mat','DCTriggers')

end

