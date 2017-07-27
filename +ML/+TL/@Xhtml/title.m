function out = title(this, varargin)

% --- Input ---------------------------------------------------------------
in = ML.Input;
in.title = 'char';
in = in.process;

% --- Processing ----------------------------------------------------------

out = this.container(this.Index.head, 'title', 'inline', true);
this.text(out, in.title);