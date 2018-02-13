classdef Page < handle
   
    properties
        
        Object
        name
        main
      
    end
    
    
    methods
        
        function this = Page(Object)
        
            % --- Definitions
            this.Object = Object;
            
            % --- Get properties
            
            % Page name
            this.name = Object.Syntax;
                        
        end
        
    end
end