function obj = getNormIntensityPts(obj)
%GETNORMINTENSITY Intensity normalization of the PET to the cerebellum

cd(obj.SysPath.SubPath)
ROIMask = obj.Mask.Cereb;
wPET = dir('*.nii');

if isempty(wPET)
    error('Please DO the spatial normalization of the patients PET first')
end

for i = 1:length(wPET)
    
    [~] = PETIntensityNormROI(wPET(i).name,ROIMask);
    
end

filelist = dir('*.nii');
filelist = filelist(~startsWith({filelist.name}, 'n_'));
for i = 1:length(filelist)
    movefile(filelist(i).name,'temp')
end

end

