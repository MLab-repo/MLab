function text(this, varargin)
%ML.CW.CLI/text Text element
%   ML.CW.CLI/text(I, J, TEXT) adds a text element containing the string
%   TEXT at position (I,J) in the grid.
%
%   See also ML.CW.CLI, ML.CW.CLI/input, ML.CW.CLI/select, ML.CW.CLI/action
%
%   More on <a href="matlab:ML.doc('ML.CW.CLI.text');">ML.doc</a>

% --- Input
in = ML.Input;
in.row = @isnumeric;
in.col = @isnumeric;
in.text = @(x) ischar(x) || iscellstr(x);
in = +in;

% --- Store
this.elms{in.row, in.col} = struct('type', 'text', 'text', {in.text});

% Registration
ML.Session.set('MLab_CLI', this.name, this);
