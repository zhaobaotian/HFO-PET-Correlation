%%
Cronexe = 'C:\Users\THIENC\Desktop\mricron\mricron.exe ';
anatF = 'anat.nii';
PETF  = 'rPET.nii';

cd('D:\13.2.Zilin_HFO_anat_rPET\1.subRAW')
sub = GetFolders(pwd);
for i = 30
    cd(sub{i})
    MRIcronCodes = ['start ',Cronexe, anatF, ' -o ' PETF, ' -c -33 -b 80'];
    system(MRIcronCodes)
end
%%