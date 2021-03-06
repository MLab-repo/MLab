classdef Class < ML.FS.search.Root

    properties (Access = public)
       
        Syntax
        isclassdef = true
        
    end
    
    methods
        
        % --- Constructor -------------------------------------------------
        function this = Class(varargin)
            
            % --- Parent's constructor ------------------------------------
            
            this = this@ML.FS.search.Root(varargin{:});
            
            % --- Inputs --------------------------------------------------

            in = ML.Input(varargin{2:end});
            in.info(struct()) = @isstruct;
            in = in.process;
            
            % --- Name
            [~, tmp] = fileparts(this.Fullpath);
            this.Name = tmp(2:end);
            
            % --- Syntax
            if isprop(this, 'Package')
                this.Syntax = [this.Package '.' this.Name];
            elseif ismember(this.Category, {'MLab', 'Plugin'})
                this.Syntax = ['ML.' this.Name];
            else
                this.Syntax = this.Name;
            end
                  
            % --- Parents
            tmp = superclasses(this.Syntax);
            if ~isempty(tmp)
                addprop(this, 'Parents');
                this.Parents = tmp;
            end
            
            % --- Classdef ?
            this.isclassdef = ~isempty(meta.class.fromName(this.Syntax));
            
        end
        
    end
end
