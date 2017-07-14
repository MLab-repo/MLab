function out = dir(varargin)
% ML.dir Directory content
%   OUT = ML.dir lists the files and folders in the current folder, except 
%   for the files starting with a dot. In particular, '.' and '..' are 
%   exluded. As for DIR, results appear in the order returned by the 
%   operating system.
%
%   ML.dir(IN) specifies the directory to search in.
%
%   ML.dir(..., 'Include', INC) include only the elements whose name match
%   the regular expression patterns in INC. INC can be a single pattern 
%   string or a cell of pattern strings. The default behavior is
%   case-sensitive. Note that elements starting with a dot can be included
%   if they match one of the patterns.
%
%   ML.dir(..., 'Exclude', EXC) exclude all elements whose name match the
%   regular expresion patterns in EXC. EXC can be a single pattern 
%   string or a cell of pattern strings. The default excluding behavior is 
%   case-sensitive. 
%
%   Note: In case both inclusion and exclusion matching are invoked, 
%   inclusion is treated prior to exclusion.
%
%   ML.dir(..., 'CaseSensitive', false) performs inclusion/exclusion 
%   filtering case-insensitively.
%
%   See also dir, regexp
%
%   More on <a href="matlab:ML.doc('ML.dir');">ML.doc</a>

% --- Inputs
in = ML.Input;
in.Path{'.'} = @ischar;
in.Include({}) = @(x) ischar(x) || iscellstr(x);
in.Exclude({}) = @(x) ischar(x) || iscellstr(x);
in.CaseSensitive(true) = @islogical;
in.Options('') = @ischar;
in = +in;

% Cellification
if ischar(in.Include), in.Include = {in.Include}; end
if ischar(in.Exclude), in.Exclude = {in.Exclude}; end

% --- List files and folders
out = dir(in.Path);

% --- Inclusion

if ~isempty(in.Include)
    if in.CaseSensitive
        A = cellfun(@(x) cellfun(@isempty, regexp({out(:).name},x)), in.Include, 'UniformOutput', false);
    else
        A = cellfun(@(x) cellfun(@isempty, regexpi({out(:).name},x)), in.Include, 'UniformOutput', false);
    end
    out(all(cat(1,A{:}),1)) = [];
else
    out(cellfun(@(x) strcmp(x(1),'.'), {out(:).name})) = [];
end

% --- Exclusion
if ~isempty(in.Exclude)
    if in.CaseSensitive
        A = cellfun(@(x) cellfun(@isempty, regexp({out(:).name},x)), in.Exclude, 'UniformOutput', false);
    else
        A = cellfun(@(x) cellfun(@isempty, regexpi({out(:).name},x)), in.Exclude, 'UniformOutput', false);
    end
    out(~all(cat(1,A{:}),1)) = [];
end

%! ------------------------------------------------------------------------
%! Author: Raphaël Candelier
%! Version: 1.1
%
%! Revisions
%   1.1     (2015/04/04): Added the pattern-based inclusion/exclusion 
%               mechanism.
%   1.0     (2010/01/01): Initial version.
%
%! To_do
%   Write ML.doc.
%! ------------------------------------------------------------------------
%! Doc
%   <title>Custom title</title>
%   <h1>ML.dir</h1>
%   <hline>Directory content</hline>
%
%   <h2>Syntax</h2>
%   <sx>ML.dir</sx>
%   <sx>listing = ML.dir(name)</sx>
%
%   <h2>Description</h2>
%   <p><c>dir</c> lists the files and folders in the MATLAB® current folder. Results appear in the order returned by the operating system.</p>
%   <p>This is some html <doc target='text'>text</doc></p>.
%   You should take at the <MLdoc target="parafit">ML.parafit</MLdoc> function.