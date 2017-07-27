classdef Xhtml < ML.TL.Block
%ML.LT.Xhtml XHTML generation
%
%   More on ...
    
    % --- Properties
    properties
        
        doctype = 'html';
        xmlns = 'http://www.w3.org/1999/xhtml';
        
        Index = struct('html', NaN, 'head', NaN, 'body', NaN);
        
    end
    
    % --- Constructor
    methods
        
        function this = Xhtml(varargin)
            
            % --- Input
            in = ML.Input;
            in.title{''} = 'char';
            [in, unmin] = in.process;
            
            % --- Parent's constructor
            
            this = this@ML.TL.Block(unmin{:});
            
            % --- Default elements
            this.Index.html = this.container(0, 'html', 'attributes', struct('xmlns', this.xmlns));
            this.Index.head = this.container(this.Index.html, 'head');
            this.Index.body = this.container(this.Index.html, 'body');
            this.title(in.title);

            
        end
        
    end
end