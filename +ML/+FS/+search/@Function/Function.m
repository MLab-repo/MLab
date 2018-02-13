classdef Function < ML.FS.search.Root

    properties (Access = public)
       
        Syntax
        Extension = ''
        
    end
    
    methods
        
        % --- Constructor -------------------------------------------------
        function this = Function(varargin)
            
            % --- Parent's constructor ------------------------------------
            
            this = this@ML.FS.search.Root(varargin{:});
            
            % --- Inputs --------------------------------------------------

            in = ML.Input(varargin{2:end});
            in.info(struct()) = @isstruct;
            in = in.process;
            
            % --- Name & extension
            [~, this.Name, this.Extension] = fileparts(this.Fullpath);
            
            % --- Syntax
            if isprop(this, 'Package')
                this.Syntax = [this.Package '.' this.Name];
            elseif ismember(this.Category, {'MLab', 'Plugin'})
                this.Syntax = ['ML.' this.Name];
            else
                this.Syntax = this.Name;
            end
                  
        end
        
    end
end
