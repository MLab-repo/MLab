function action(this, varargin)
%ML.CW.CLI/action Clickable element (action triger)
%   ML.CW.CLI/action(I, J, DESC, ACTION) adds a clickable link at position 
%   (I,J) in the grid. The text of the link is specified by the string
%   DESC. ACTION can be either a string or a function handle, but in both
%   cases they refer to a method of the class that will be called as a
%   parameterless callback.
%
%   See also ML.CW.CLI, ML.CW.CLI/text, ML.CW.CLI/input, ML.CW.CLI/select
%
%   More on <a href="matlab:ML.doc('ML.CW.CLI.action');">ML.doc</a>

% --- Input
in = ML.Input;
in.row = @isnumeric;
in.col = @isnumeric;
in.desc = @ischar;
in.action = @(x) ischar(x) || ML.isfunction_handle(x);
in.args({}) = @iscell;
in = +in;

% --- Check
if ML.isfunction_handle(in.action)
    in.action = func2str(in.action);
end

if isempty(in.desc)
    warning('ML:CW:CLI:action:NoDescription', 'The description of an action element cannot be empty.')
    in.desc = '-';
end

% --- Store
this.elms{in.row, in.col} = struct('type', 'action', ...
    'desc', in.desc, ...
    'action', in.action, ...
    'args', {in.args});

% Registration
ML.Session.set('MLab_CLI', this.name, this);