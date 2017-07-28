function out = link(this, varargin)

% --- Input ---------------------------------------------------------------
in = ML.Input;
in.href = 'char';
[in, unmin] = in.process;

% --- Processing ----------------------------------------------------------

% unmin

out = this.single(this.Index.head, 'link', 'attributes', struct());