addpath('D:\HFO_AI_Detector')
addpath('D:\spm12_7219')
spm('defaults','eeg')

cd('E:\13.HFO_ZiLin\IID\35GuiHaifeng\sleep1')

D80 = spm_eeg_load('BpHi80_bc_BipM_fffffffffspmeeg_sleep1.mat');

load ResultsAll.mat

%%
chanRange = [83:93];
sampleRange = [37000:45000];
t = D80.time(sampleRange);
chanData = squeeze(D80(chanRange,sampleRange,:));
timeStamp = HFO.CandidateHFOsFinalEventsTimeStamps(chanRange);

figure
for i = 1:11
    tempChanD = chanData(i,:) - 10*i;
    plot(t,tempChanD,'k')
    hold on
    % add color to the HFO events
    tempTS    = timeStamp{i};
    msk1 = find(tempTS(:,1) > sampleRange(1));
    msk2 = find(tempTS(:,3) < sampleRange(end));
    tempTSmsk = intersect(msk1,msk2);
    tempTS    = tempTS(tempTSmsk,:);
    
    tempTS(:,1:3) = tempTS(:,1:3) - sampleRange(1);
    
    for j = 1:size(tempTS,1)
        tempD = tempChanD(tempTS(j,1):tempTS(j,3));
        tempT = t(tempTS(j,1):tempTS(j,3));
        plot(tempT,tempD,'LineWidth',1,'Color','r')
    end
end
axis tight
ylim([-120 5])
set(gcf,'Position',[100 100 1200 800])
print('HFOexample','-dpng','-r600')

%%