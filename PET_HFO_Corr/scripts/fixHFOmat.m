%%
clear
cd('D:\13.2.Zilin_HFO_anat_rPET\3.PET-HFO-rate-corr\12FengZhengjun_awake1')
matF = [];
matF = dir('*awake*.mat');
if isempty(matF)
    matF = dir('*sleep*.mat');
end
assert(~isempty(matF))

load(matF.name)

HFO.qualityHFOsCounts                   = HFO.qualityHFOsCounts(1:111);
HFO.CandidateHFOsFinalEventsLabels      = HFO.CandidateHFOsFinalEventsLabels(1:111);
HFO.CandidateHFOsFinalEventsTimeStamps  = HFO.CandidateHFOsFinalEventsTimeStamps(1:111);
save(matF.name,'Elec','HFO','HFOV')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
cd('D:\13.2.Zilin_HFO_anat_rPET\3.PET-HFO-rate-corr\12FengZhengjun_awake2')
matF = [];
matF = dir('*awake*.mat');
if isempty(matF)
    matF = dir('*sleep*.mat');
end
assert(~isempty(matF))

load(matF.name)

HFO.qualityHFOsCounts                   = HFO.qualityHFOsCounts(1:111);
HFO.CandidateHFOsFinalEventsLabels      = HFO.CandidateHFOsFinalEventsLabels(1:111);
HFO.CandidateHFOsFinalEventsTimeStamps  = HFO.CandidateHFOsFinalEventsTimeStamps(1:111);
save(matF.name,'Elec','HFO','HFOV')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
cd('D:\13.2.Zilin_HFO_anat_rPET\3.PET-HFO-rate-corr\12FengZhengjun_sleep1')
matF = [];
matF = dir('*awake*.mat');
if isempty(matF)
    matF = dir('*sleep*.mat');
end
assert(~isempty(matF))

load(matF.name)

HFO.qualityHFOsCounts                   = HFO.qualityHFOsCounts(1:111);
HFO.CandidateHFOsFinalEventsLabels      = HFO.CandidateHFOsFinalEventsLabels(1:111);
HFO.CandidateHFOsFinalEventsTimeStamps  = HFO.CandidateHFOsFinalEventsTimeStamps(1:111);
save(matF.name,'Elec','HFO','HFOV')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
cd('D:\13.2.Zilin_HFO_anat_rPET\3.PET-HFO-rate-corr\12FengZhengjun_sleep2')
matF = [];
matF = dir('*awake*.mat');
if isempty(matF)
    matF = dir('*sleep*.mat');
end
assert(~isempty(matF))

load(matF.name)

HFO.qualityHFOsCounts                   = HFO.qualityHFOsCounts(1:111);
HFO.CandidateHFOsFinalEventsLabels      = HFO.CandidateHFOsFinalEventsLabels(1:111);
HFO.CandidateHFOsFinalEventsTimeStamps  = HFO.CandidateHFOsFinalEventsTimeStamps(1:111);
save(matF.name,'Elec','HFO','HFOV')

%%
clear
rangeChan = 1:107;
cd('D:\13.2.Zilin_HFO_anat_rPET\3.PET-HFO-rate-corr\14HeQianqian_awake1')
matF = [];
matF = dir('*awake*.mat');
if isempty(matF)
    matF = dir('*sleep*.mat');
end
assert(~isempty(matF))

load(matF.name)

HFO.qualityHFOsCounts                   = HFO.qualityHFOsCounts(rangeChan);
HFO.CandidateHFOsFinalEventsLabels      = HFO.CandidateHFOsFinalEventsLabels(rangeChan);
HFO.CandidateHFOsFinalEventsTimeStamps  = HFO.CandidateHFOsFinalEventsTimeStamps(rangeChan);
save(matF.name,'Elec','HFO','HFOV')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
rangeChan = 1:107;
cd('D:\13.2.Zilin_HFO_anat_rPET\3.PET-HFO-rate-corr\14HeQianqian_awake2')
matF = [];
matF = dir('*awake*.mat');
if isempty(matF)
    matF = dir('*sleep*.mat');
end
assert(~isempty(matF))

load(matF.name)

HFO.qualityHFOsCounts                   = HFO.qualityHFOsCounts(rangeChan);
HFO.CandidateHFOsFinalEventsLabels      = HFO.CandidateHFOsFinalEventsLabels(rangeChan);
HFO.CandidateHFOsFinalEventsTimeStamps  = HFO.CandidateHFOsFinalEventsTimeStamps(rangeChan);
save(matF.name,'Elec','HFO','HFOV')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
rangeChan = 1:107;
cd('D:\13.2.Zilin_HFO_anat_rPET\3.PET-HFO-rate-corr\14HeQianqian_sleep1')
matF = [];
matF = dir('*awake*.mat');
if isempty(matF)
    matF = dir('*sleep*.mat');
end
assert(~isempty(matF))

load(matF.name)

HFO.qualityHFOsCounts                   = HFO.qualityHFOsCounts(rangeChan);
HFO.CandidateHFOsFinalEventsLabels      = HFO.CandidateHFOsFinalEventsLabels(rangeChan);
HFO.CandidateHFOsFinalEventsTimeStamps  = HFO.CandidateHFOsFinalEventsTimeStamps(rangeChan);
save(matF.name,'Elec','HFO','HFOV')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
rangeChan = 1:107;
cd('D:\13.2.Zilin_HFO_anat_rPET\3.PET-HFO-rate-corr\14HeQianqian_sleep2')
matF = [];
matF = dir('*awake*.mat');
if isempty(matF)
    matF = dir('*sleep*.mat');
end
assert(~isempty(matF))

load(matF.name)

HFO.qualityHFOsCounts                   = HFO.qualityHFOsCounts(rangeChan);
HFO.CandidateHFOsFinalEventsLabels      = HFO.CandidateHFOsFinalEventsLabels(rangeChan);
HFO.CandidateHFOsFinalEventsTimeStamps  = HFO.CandidateHFOsFinalEventsTimeStamps(rangeChan);
save(matF.name,'Elec','HFO','HFOV')
%%
clear
rangeChan = 1:95;
cd('D:\13.2.Zilin_HFO_anat_rPET\3.PET-HFO-rate-corr\15WangRuyi_awake1')
matF = [];
matF = dir('*awake*.mat');
if isempty(matF)
    matF = dir('*sleep*.mat');
end
assert(~isempty(matF))

load(matF.name)

HFO.qualityHFOsCounts                   = HFO.qualityHFOsCounts(rangeChan);
HFO.CandidateHFOsFinalEventsLabels      = HFO.CandidateHFOsFinalEventsLabels(rangeChan);
HFO.CandidateHFOsFinalEventsTimeStamps  = HFO.CandidateHFOsFinalEventsTimeStamps(rangeChan);
save(matF.name,'Elec','HFO','HFOV')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
rangeChan = 1:95;
cd('D:\13.2.Zilin_HFO_anat_rPET\3.PET-HFO-rate-corr\15WangRuyi_awake2')
matF = [];
matF = dir('*awake*.mat');
if isempty(matF)
    matF = dir('*sleep*.mat');
end
assert(~isempty(matF))

load(matF.name)

HFO.qualityHFOsCounts                   = HFO.qualityHFOsCounts(rangeChan);
HFO.CandidateHFOsFinalEventsLabels      = HFO.CandidateHFOsFinalEventsLabels(rangeChan);
HFO.CandidateHFOsFinalEventsTimeStamps  = HFO.CandidateHFOsFinalEventsTimeStamps(rangeChan);
save(matF.name,'Elec','HFO','HFOV')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
rangeChan = 1:95;
cd('D:\13.2.Zilin_HFO_anat_rPET\3.PET-HFO-rate-corr\15WangRuyi_sleep1')
matF = [];
matF = dir('*awake*.mat');
if isempty(matF)
    matF = dir('*sleep*.mat');
end
assert(~isempty(matF))

load(matF.name)

HFO.qualityHFOsCounts                   = HFO.qualityHFOsCounts(rangeChan);
HFO.CandidateHFOsFinalEventsLabels      = HFO.CandidateHFOsFinalEventsLabels(rangeChan);
HFO.CandidateHFOsFinalEventsTimeStamps  = HFO.CandidateHFOsFinalEventsTimeStamps(rangeChan);
save(matF.name,'Elec','HFO','HFOV')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
rangeChan = 1:95;
cd('D:\13.2.Zilin_HFO_anat_rPET\3.PET-HFO-rate-corr\15WangRuyi_sleep2')
matF = [];
matF = dir('*awake*.mat');
if isempty(matF)
    matF = dir('*sleep*.mat');
end
assert(~isempty(matF))

load(matF.name)

HFO.qualityHFOsCounts                   = HFO.qualityHFOsCounts(rangeChan);
HFO.CandidateHFOsFinalEventsLabels      = HFO.CandidateHFOsFinalEventsLabels(rangeChan);
HFO.CandidateHFOsFinalEventsTimeStamps  = HFO.CandidateHFOsFinalEventsTimeStamps(rangeChan);
save(matF.name,'Elec','HFO','HFOV')
%%

