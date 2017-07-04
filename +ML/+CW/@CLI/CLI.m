classdef CLI<handle
% ML.CW.CLI Command line Interface
%   This class creates a clickable interface in the command window. The
%   interface has the form of a 2D grid in which every square can contain
%   an interactive element (input, selectable field or link).
%
%   --- Syntax
%
%   ML.CW.CLI creates a CLI object.
%
%   --- Usage
%
%   The following methods can be used to place a new element in the grid:
%       - <a href="matlab: help ML.CW.CLI.text">text</a>:   adds a textual element (not interactive)
%       - <a href="matlab: help ML.CW.CLI.select">select</a>: adds a selectable element. It supports multiple choices
%                 and multiple selections.
%       - <a href="matlab: help ML.CW.CLI.input">input</a>:  adds an input field
%       - <a href="matlab: help ML.CW.CLI.action">action</a>: adds an action (link)
%
%   Once all elements are placed on the grid, use the <a href="matlab: help ML.CW.CLI.print">print</a> method to 
%   display the interface.
%
%   See also ML.CW.CLIm
%
%   More on <a href="matlab:ML.doc('ML.CW.CLI');">ML.doc</a>


    % --- Properties
    properties (SetAccess = private)
        
        name = '';
        print_param = {};
        hlmode = ML.isdesktop;
        isfirst = true;
        clal = {};
        
    end
    
    properties (SetAccess = protected)
        elms = {};
    end
    
    properties (SetAccess = public)
        title = '';
        desc = '';
    end
    
    % --- Constructor
    methods
        
        function this = CLI(varargin)
            
            % Inputs
            in = ML.Input;
            in.name{ML.randstr(10, 'type', 'variable')} = @isvarname;
            in.mode('default') = @(x) ismember(x, {'CL', 'CW'});
            in = +in;
            
            % Assignment
            this.name = in.name;
                  
            % Mode
            switch in.mode
                case 'CL'
                    this.hlmode = false;
                case 'CW'
                    this.hlmode = true;
                otherwise
                    this.hlmode = ML.isdesktop;
            end
            
            % Registration
            ML.Session.set('MLab_CLI', this.name, this);

            
        end
        
    end
end