function obj = getSave(obj)
%GETSAVE Save results
cd([obj.SysPath.MainSub,filesep,'Results'])

save('Ttest2Result','obj')

end

