function obj = GetMatTimeStamps(obj)
%GetMatTimeStamps Extract time trigger time stamps from .mat files
% FORMAT: GetDCTimeStamps(obj)
% Input:
%       obj:  iEEG object loaded with Trigger_MEEG property used for epoch
% Output:
%       obj:  iEEG object loaded with DCTriggers property
% --------------------------------------------------------------
% THIENC, Tiantan Human Intracranial Electrophysiology & Neuroscience Center

% Baotian Zhao 20190510
% zhaobaotian0220@foxmail.com

if isempty(obj.TaskName)
    error('Please define the task type! e.g. obj.TaskName = "Race"')
end

switch obj.TaskName
    case 'Race'
        load(obj.matFile{1})
        for i = 1:216
            MatTriggers1(i) = theData(i).flip.StimulusOnsetTime;
        end
        for i = 1:432
            MatTriggers2(i) = theData(i+216).flip.StimulusOnsetTime;
        end
        obj.MatTriggers{1} = MatTriggers1;
        obj.MatTriggers{2} = MatTriggers2;
end      
end

