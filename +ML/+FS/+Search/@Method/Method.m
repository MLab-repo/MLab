classdef Method < ML.FS.Search.Root

    properties (Access = public)
       
        Syntax
        Extension = ''
        Class
        
    end
    
    methods
        
        % --- Constructor -------------------------------------------------
        function this = Method(varargin)
            
            % --- Parent's constructor ------------------------------------
            
            this = this@ML.FS.Search.Root(varargin{:});
            
            % --- Inputs --------------------------------------------------

            in = ML.Input(varargin{2:end});
            in.info(struct()) = @isstruct;
            in = +in;
            
            % --- Name & extension
            [~, this.Name, this.Extension] = fileparts(this.Fullpath);
            
            % --- Class
            this.Class = in.info.class;
            
            % --- Syntax
            this.Syntax = [this.Class '.' this.Name];
            
        end
        
    end
end
