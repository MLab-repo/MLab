function input(this, varargin)
%ML.CW.CLI/input Input element
%   ML.CW.CLI/input(I, J, DESC) adds a clickable input element at position 
%   (I,J) in the grid. The description is specified by the string DESC and
%   can be removed if an empty string is passed.
%
%   ML.CW.CLI/input(..., 'value', V) specifies the initial value. V can be
%   a boolean, a number or a string.
%
%   See also ML.CW.CLI, ML.CW.CLI/text, ML.CW.CLI/select, ML.CW.CLI/action
%
%   More on <a href="matlab:ML.doc('ML.CW.CLI.input');">ML.doc</a>

% --- Input
in = ML.Input;
in.row = @isnumeric;
in.col = @isnumeric;
in.desc = @ischar;
in.value('') = @(x) ischar(x) || isnumeric(x) || islogical(x);
in = +in;

% --- Check
if isnumeric(in.value)
    in.value = num2str(in.value);
end

% --- Store
this.elms{in.row, in.col} = struct('type', 'input', ...
    'desc', in.desc, ...
    'value', in.value);

% Registration
ML.Session.set('MLab_CLI', this.name, this);
