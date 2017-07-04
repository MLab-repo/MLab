function get_input(this, varargin)
%ML.CW.CLI/get_input Get input
%   ML.CW.CLI/get_input(I) asks for a the value of the input element at
%   position I in the grid.
%
%   Note: This method is related to <a href="matlab:help M.CW.CLI.input">ML.CW.CLI/input</a> and should not be 
%   called directly by the end user of the class.
%
%   See also ML.CW.CLI, ML.CW.CLI/input
%
%   More on <a href="matlab:ML.doc('ML.CW.CLI.get_input');">ML.doc</a>

% --- Input
in = ML.Input;
in.elm = @isnumeric;
in = +in;

% --- Get input
fprintf('Please enter the new input for ''%s'': [Ctrl+C to skip]\n', this.elms{in.elm}.desc);
this.elms{in.elm}.value = input('?> ', 's');

% --- Display
if this.hlmode
    this.print;
elseif ismethod(this, 'structure')
    this.structure;
end