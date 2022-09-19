function Tvalue = ExtractT(MNIcorr,Tmap)
%EXTRACT T 
T1 = Tmap;


%% Make bipolar masks
% Make bipolar mask info
BipolarContactsMaskSphere(T1,BipolarName,BipolarPos,Radius)

%% Extract T values of individual SPM PET
BipolarGreyMasks = dir('RawBipContactsMask\*.nii');
BipolarGreyMasks = {BipolarGreyMasks.name}';
BipolarGreyMasks = cellfun(@(x) ['.\RawBipContactsMask\' x],BipolarGreyMasks,'UniformOutput',false);

% Extract raw T values
BipolarGreyMasks = natsortfiles(BipolarGreyMasks);
nrPET = 'spmT_0001.nii';
nSUVRaw = ExtractIndividualSUV(nrPET,BipolarGreyMasks);


end

