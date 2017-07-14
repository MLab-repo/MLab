classdef (Abstract) Root < dynamicprops
%       - 'category': a string that can be either 'built-in', 'matlab',
%           'java', 'user' or 'toolbox'.
%       - 'type': a string that can be either 'script', 'function',
%           'package', 'class' or 'method'.
%       - 'extension': Any of the official Mathworks extensions (fig, m,
%           mlx, mat, mdl, slx, mdlp, slxp, mexa64, mexmaci64, mexw32,
%           mexw64, mlapp, mlappinstall, mlpkginstall, mltbx, mn, mu, p).
%           This field is empty in the case of a built-in function or a
%           java method.
%       - 'toolbox': The containing toolbox, if any (default: '').
%       - 'package': The closest parent package, if any (default: '').
%       - 'class': The parent class, if any (default: '').
%       - 'location': The entity location. The fields 'package', 'class'
%           and 'location' are structures themselves, which each contain
%           fields 'path', 'name' and 'fullpath'.
%
% The type is a string that can be either 'File', 'Package',
% 'Class', 'Methods', 'MLab', 'Plugin' or 'Tutotial'.
% The category is a string that can be either 'Built-in', 'Matlab',
% 'Toolbox', 'MLab', 'Plugin' or 'User'.

    properties (Access = public)
       
        Name
        Fullpath        
        Category        
        
    end
    
    methods
        
        % --- Constructor -------------------------------------------------
        function this = Root(varargin)
            
            % --- Inputs --------------------------------------------------

            in = ML.Input;
            in.path = @ischar;
            in.info(struct()) = @isstruct;
            in = +in;
                        
            % --- Full path -----------------------------------------------
            
            this.Fullpath = in.path;
            
            % --- Category ------------------------------------------------
            
            this.Category = in.info.category;
            
            % --- Toolbox -------------------------------------------------
            
            if isfield(in.info, 'toolbox')
                addprop(this, 'Toolbox');
                this.Toolbox = in.info.toolbox;
            end
              
            % --- Package -------------------------------------------------
            
            if isfield(in.info, 'package')
                addprop(this, 'Package');
                this.Package = in.info.package;
            end
            
             % --- Plugin -------------------------------------------------
            
            if isfield(in.info, 'plugin')
                addprop(this, 'Plugin');
                this.Plugin = in.info.plugin;
            end
        end
        
    end
    
    methods (Static)
        
      out = slnk(this, varargin) 
      
    end
end