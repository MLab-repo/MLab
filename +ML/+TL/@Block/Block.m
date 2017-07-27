classdef Block < handle
%ML.TL.Block Block for tagged language
%
%   More on ...
    
    % --- Properties
    properties
        
        opener = {'<', '>'};
        closer = {'</', '>'};
        singler = {'<', '/>'};
        spacer = '  ';
        
        Tree = struct('parent', {}, 'position', {}, 'type', {}, ...
            'tagname', {}, 'attributes', {}, 'content', {}, 'inline', {});
        
        indent = true;
        condensed = false;
        
    end
    
    % --- Constructor
    methods
        
        function this = Block(varargin)
           
            
            
        end
        
    end
end