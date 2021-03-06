classdef MLab < ML.FS.search.Root

    properties (Access = public)
       
        Plugins = {}
        Tutorials = {}
        
    end
    
    methods
        
        % --- Constructor -------------------------------------------------
        function this = MLab()
            
            % Get fullpath
            conf = ML.config;
            
            % --- Parent's constructor ------------------------------------
            
            this = this@ML.FS.search.Root(conf.path, 'info', struct('category', 'MLab'));
            
            % --- Installed plugins
            tmp = ML.dir([conf.path 'Plugins']);
            this.Plugins = {tmp(:).name};
            
            % --- Tutorials
                  
        end
        
    end
end
