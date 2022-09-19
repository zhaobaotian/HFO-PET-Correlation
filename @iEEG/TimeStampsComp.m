function obj = TimeStampsComp(obj, threshold)
%TimeStampsComp Compare and plot triggers from DC channel and .mat file
% FORMAT: obj = TimeStampsComp(obj)
% Input:
%       obj:       The iEEG object need to be loaded with DCTriggers and MatTriggers
%       threshold: Maximum Time stamps differences allowed, default: 20ms
% Output:
%       obj:       iEEG object loaded with iEEG_MEEG
% --------------------------------------------------------------
% THIENC, Tiantan Human Intracranial Electrophysiology & Neuroscience Center

% Baotian Zhao 20190510
% zhaobaotian0220@foxmail.com
if nargin < 2 || isempty(threshold)
    threshold = 0.02; % in seconds
end

if isempty(obj.MatTriggers) || isempty(obj.DCTriggers)
    error('Time stamps can not be compared because MatTriggers/DCTriggers is empty')
end
if length(obj.MatTriggers) ~= length(obj.DCTriggers)
    error('Number of MatTriggers & DCTriggers mismatch')
end

for i = 1:length(obj.MatTriggers)
    
    timeStampBehaviorNew = obj.MatTriggers{i} - obj.MatTriggers{i}(1);
    timeStampBehaviorNew = timeStampBehaviorNew';
    timeStampDCNew       = obj.DCTriggers{i} - obj.DCTriggers{i}(1);
    figure
    plot(diff(timeStampDCNew),'o','MarkerSize',8,'LineWidth',3)
    hold on
    plot(diff(timeStampBehaviorNew),'r*')
    difference = timeStampDCNew - timeStampBehaviorNew;
    print(['Behavioral_DC_Timestamps' num2str(i)],'-dpng')
    close
    if ~all(abs(difference) < threshold)
        error('Behavioral timestamp and DC timestamp mismatch')
    else
        disp('DC triggers and mat triggers matched')
    end 
end

