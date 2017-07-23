function out = groupby(varargin)
%ML.groupby Group by column
%   OUT = ML.groupby(IN) groups the elements of IN according to the 
%   elements of the first column. IN can be a numerical array or a cell. If
%   IN is a cell, all elements of the grouped column must be numbers or 
%   strings. The output OUT is a n-by-2 cell.
%
%   OUT = ML.groupby(..., 'col', COL) groups elements according to the 
%   COL-th column.
%
%   OUT = ML.groupby(..., 'CaseSensitive', false) groups string elements
%   case-insensitively. If this parameter is set to false, the first column
%   of the output is converted in lowercase.
%
%   See also unique, strcmp
%
%   More on <a href="matlab:ML.doc('ML.groupby');">ML.doc</a>

% === Input variables =====================================================

in = ML.Input;
in.M = @(x) iscell(x) | isnumeric(x);
in.col(1) = @isnumeric;
in.CaseSensitive(true) = @isnumeric;
in = +in;

% =========================================================================

% --- Get column
C = in.M(:, in.col);

% --- Cellification
if isnumeric(C), C = mat2cell(C, ones(1, numel(C))); end

% --- Stringification
I = cellfun(@isnumeric, C);
C(I) = cellfun(@num2str, C(I), 'UniformOutput', false);

% --- Case sensitivity
if ~in.CaseSensitive, C = cellfun(@lower, C); end

% --- Grouping
[U, Iu] = unique(C);

out = cell(numel(U),2);
cols = setdiff(1:size(in.M,2),in.col);

for i = 1:numel(U)
    if iscell(in.M)
        out{i,1} = in.M{Iu(i), in.col};
    else
        out{i,1} = in.M(Iu(i), in.col);
    end
    
    I = strcmp(C, U{i});
    out{i,2} = in.M(I,cols);
end

%! ------------------------------------------------------------------------
%! Author: Raphaël Candelier
%! Version: 2.0
%
%! Revisions
%   2.0     (2015/04/01): Created help and authorized strings in cells.
%               Replaced hist by histcounts.
%   1.0     (2008/01/01): Initial version.
%
%! ------------------------------------------------------------------------
%! Doc
%   <title>To do</title>