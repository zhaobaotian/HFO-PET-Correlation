classdef SPMPET < handle
    %SPMPET used for performing SPM two sample test model
    
    properties % Paths
        SysPath % Main script path
        
    end
    
    properties % Parameters
        % For control group
        Ctl
        % For test group
        Tst
        % Smooth kernel
        GauSmooth
        
        % Mask
        Mask
        
        % is Individual
        isInd
        
        
    end
    
    methods
        function obj = SPMPET()
            %SPMPET is used for SPM group comparison
            
            % 52 normal control subjects, covariates parameters
            obj.Ctl.Age    = [];
            obj.Ctl.Gender = [];
            obj.Ctl.SubPET = [];
            
            % Test subjects;
            obj.Tst.Age     = [];
            obj.Tst.Gender  = [];
            obj.Tst.SubAnat = [];
            obj.Tst.SubPET  = [];
            
            % default parameters
            obj.GauSmooth = [8 8 8];
            
            % Path
            obj.SysPath.Main    = [];
            obj.SysPath.MainSub = [];
            obj.SysPath.SPM     = [];
            obj.SysPath.SubPath = [];
            obj.SysPath.CtlPath = [];
            
            % Mask
            obj.Mask.Brain = [];
            obj.Mask.Cereb = [];
            
            % Is induvidual or NOT
            obj.isInd      = 0;
            
        end
        
    end
end

