classdef Script < ML.Doc.Root

    properties (Access = public)
       
        Syntax
        Extension = ''
        
    end
    
    methods
        
        % --- Constructor -------------------------------------------------
        function this = Script(varargin)
            
            % --- Parent's constructor ------------------------------------
            
            this = this@ML.Doc.Root(varargin{:});
            
            % --- Inputs --------------------------------------------------

            in = ML.Input(varargin{2:end});
            in.info(struct()) = @isstruct;
            in = +in;
            
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