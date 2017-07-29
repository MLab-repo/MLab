function out = link(this, varargin)

% --- Input ---------------------------------------------------------------

in = ML.Input;
in.href = 'char';
in = in.process('merge', true, 'OutputClass', 'cell');

% --- Processing ----------------------------------------------------------

out = this.single(this.Index.head, 'link', 'attributes', in);