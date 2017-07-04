function toggle(this, varargin)
%ML.CW.CLI/toggle Toggle selection
%   ML.CW.CLI/toggle(I, K) toggles the K-th option of the selectable list
%   placed at positio I in the grid. Toggling modifies the value of the
%   K-th element and possibly the values of other elemnts if the 'mode'
%   parameter of the select element is set to 'multiple'.
%
%   Note: This method is related to <a href="matlab:help M.CW.CLI.select">ML.CW.CLI/select</a> and should not be 
%   called directly by the end user of the class.
%
%   See also ML.CW.CLI, ML.CW.CLI/select
%
%   More on <a href="matlab:ML.doc('ML.CW.CLI.toggle');">ML.doc</a>

% --- Input
in = ML.Input;
in.elm = @isnumeric;
in.ind = @isnumeric;
in = +in;

% --- Toggle
switch this.elms{in.elm}.mode
    
    case 'single'
        tmp = ~this.elms{in.elm}.values(in.ind);
        this.elms{in.elm}.values(:) = false;
        this.elms{in.elm}.values(in.ind) = tmp;
    
    case 'multiple'
        this.elms{in.elm}.values(in.ind) = ~this.elms{in.elm}.values(in.ind);
        
end

% --- Display
if this.hlmode
    this.print;
elseif ismethod(this, 'structure')
    this.structure;
end