classdef Html < handle
%ML.Html Html generation
%
%   More on ...
    
    % --- Properties
    properties
        
        tab = '  ';
        Tree = struct('parent', {}, 'pos', {}, 'children', {}, ...
            'type', {}, 'options', {}, 'text', {});
        
        Index = struct('head', NaN, 'body', NaN);
        
    end
    
    % --- Constructor
    methods
        
        function this = Html(varargin)
            
            % Create the basic stucture
            this.NewElm(0, 'Root', 'options', '<!DOCTYPE html>');
            this.NewElm(1, 'html');
            this.Index.head = this.NewElm(2, 'head');
            this.Index.body = this.NewElm(2, 'body');
            
        end
        
    end
end