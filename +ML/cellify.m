function out = cellify(varargin)
% ML.cellify Make sure the output is a cell
%   OUT = ML.cellify(IN) checks that the input IN is a cell array, and 
%   otherwise embeds it in a cell array.
%
%   See also cell
%
%   More on ...

% --- Check input
in = ML.Input;
in.var = @(x) true;
in = in.process;

% --- Check terminal file separator
if isa(in.var, 'cell')
    out = in.var;
else
    out = {in.var};
end

