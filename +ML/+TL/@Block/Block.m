classdef Block < handle
%ML.TL.Block Block for tagged language
%
%   More on ...
    
    % --- Properties
    properties
        
        opener = {'<', '>'};
        closer = {'</', '>'};
        singler = {'<', ' />'};
        commenter = {'<!-- ', ' -->'};
        spacer = '  ';
        attquote = '"';
        lowtag = false;
        lowatt = false;
        
        Tree = struct('parent', {}, 'position', {}, 'type', {}, ...
            'tagname', {}, 'attributes', {}, 'content', {}, 'inline', {});
        
        indent = true;
        condensed = false;
        
    end
    
    % --- Constructor
    methods
        
        function this = Block(varargin)
           
            
            
        end
        
        % --- Setter methods ---------------------------------------------
        function this = set.condensed(this, value)
            this.condensed = value;
            if value
                this.indent = false;
            end
        end
        
    end
end