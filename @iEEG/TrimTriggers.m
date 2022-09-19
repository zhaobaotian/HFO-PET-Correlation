function obj = TrimTriggers(obj)
%TrimTriggers Trim redundant triggers including header and tail
% FORMAT: obj = TrimTriggers(obj)
% Input:
%       obj: With properties: HeaderTriggers, TailTriggers and other task
%       specific redundant triggers
% Output:
%       obj: iEEG object loaded with MEEG
% --------------------------------------------------------------
% THIENC, Tiantan Human Intracranial Electrophysiology & Neuroscience Center

% Baotian Zhao 20190510
% zhaobaotian0220@foxmail.com

% Remove header and tail triggers if there is any
if ~isempty(obj.HeaderTriggers)
    for i = 1:length(obj.DCTriggers)
        obj.DCTriggers{i} = obj.DCTriggers{i}(obj.HeaderTriggers + 1:end);
    end
end

if ~isempty(obj.TailTriggers)
    for i = 1:length(obj.DCTriggers)
        obj.DCTriggers{i} = obj.DCTriggers{i}(1:end - obj.TailTriggers);
    end
end

switch obj.TaskName
    case 'Race'
        % stimulus onests for race faces
        obj.DCTriggers{1} = obj.DCTriggers{1}(1:2:216); % stimulus onsets for 108 images
        fileID = fopen('Race1Onsets.txt','w');
        fprintf(fileID,'%f\n',obj.DCTriggers{1});
        fclose(fileID);
        obj.DCTriggers{2} = obj.DCTriggers{2}(1:4:432); % stimulus onsets for 108 images
        fileID = fopen('Race2Onsets.txt','w');
        fprintf(fileID,'%f\n',obj.DCTriggers{2});
        fclose(fileID);
end

end

