classdef Plugin < ML.Doc.Root
    
    properties (Access = public)
        
        Content = struct()
        Tutorials = struct();
        
    end
    
    methods (Access = public)
        
        % --- Constructor -------------------------------------------------
        function this = Plugin(varargin)
            
            % --- Parent's constructor ------------------------------------
            
            this = this@ML.Doc.Root(varargin{:});
            
            % --- Inputs --------------------------------------------------
                        
            in = ML.Input(varargin{2:end});
            in.info(struct()) = @isstruct;
            in = +in;
            
            % --- Name
            [~, this.Name] = fileparts(this.Fullpath);
            
            % --- Content
            this.Content = this.get_content([this.Fullpath filesep '+ML']);
            
        end
    end
    
    methods (Access = private)
        
        function out = get_content(this, in)
            
            out = struct();
            tmp = ML.dir(in);
            for i = 1:numel(tmp)
                out(i).Name = tmp(i).name;
                
                switch out(i).Name(1)
                    case '+'
                        out(i).Type = 'Package';
                        out(i).Content = this.get_content([in filesep out(i).Name]);
                        
                    case '@'
                        out(i).Type = 'Class';
                        out(i).Content = this.get_content([in filesep out(i).Name]);
                        
                    otherwise
                        out(i).Type = 'File';
                        out(i).Content = [];
                end
            end
            
        end
        
    end
    
end