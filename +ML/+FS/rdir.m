function out = rdir(varargin)
% ML.rdir Recursive directory listing
%   OUT = ML.rdir recursively lists the files and folders in the current 
%   folder, except for the files starting with a dot. In particular, '.' 
%   and '..' are exluded. As for DIR, results appear in the order returned 
%   by the operating system. The output is a structure with fields:
%       - 'level' (starts at 1 at root level)
%       - 'name'
%       - 'folder'
%       - 'fullname'
%       - 'extension' (e.g. '.m', '.png')
%       - 'date'
%       - 'bytes'
%       - 'isdir'
%       - 'datenum'
%
%   ML.rdir(IN) specifies the root directory to search in.
%
%   ML.rdir(..., 'MaxRecursionLevel', MAX) specifies the maximum recursion
%   level. As the first recursion is level 1, calling ML.rdir with
%   MaxRecursionLevel set to 1 is equivalent to call ML.dir.
%
%   ML.rdir(..., 'Only', TYPE) filters the output to return only elements of
%   a certain type. TYPE can be 'Files' or 'Folders'.
%
%   ML.rdir(..., 'Include', INC) include only the elements whose name match
%   the regular expression patterns in INC. INC can be a single pattern 
%   string or a cell of pattern strings. The default behavior is
%   case-sensitive. Note that elements starting with a dot can be included
%   if they match one of the patterns.
%
%   ML.rdir(..., 'Exclude', EXC) exclude all elements whose name match the
%   regular expresion patterns in EXC. EXC can be a single pattern 
%   string or a cell of pattern strings. The default excluding behavior is 
%   case-sensitive. 
%
%   Note: In case both inclusion and exclusion matching are invoked, 
%   inclusion is treated prior to exclusion.
%
%   ML.rdir(..., 'CaseSensitive', false) performs inclusion/exclusion 
%   filtering case-insensitively.
%
%   See also dir, ML.dir, regexp
%
%   More on ...

% --- Inputs --------------------------------------------------------------

in = ML.Input;
in.Path{pwd} = 'str,topath';
in.Only('') = @(x) ismember(lower(x), {'file', 'files', 'folder', 'folders'}) ;
in.Include({}) = 'str,cellstr,incell';
in.Exclude({}) = 'str,cellstr,incell';
in.CaseSensitive(true) = 'logical';
in.MaxRecursionLevel(1) = 'numeric,integer,>=1';
in = in.process;

% --- List files and folders ----------------------------------------------

out = dir(in.Path);

% --- Filters

% Remove items whose name starts with a dot
out(cellfun(@(x) strcmp(x(1),'.'), {out(:).name})) = [];

% Only files or folders
switch lower(in.Only)
    case {'file', 'files'}, out([out(:).isdir]) = [];
    case {'folder', 'folders'}, out(~[out(:).isdir]) = [];
end

% Inclusion
if ~isempty(in.Include)
    if in.CaseSensitive
        A = cellfun(@(x) cellfun(@isempty, regexp({out(:).name},x)), in.Include, 'UniformOutput', false);
    else
        A = cellfun(@(x) cellfun(@isempty, regexpi({out(:).name},x)), in.Include, 'UniformOutput', false);
    end
    out(all(cat(1,A{:}),1)) = [];
end

% Exclusion
if ~isempty(in.Exclude)
    if in.CaseSensitive
        A = cellfun(@(x) cellfun(@isempty, regexp({out(:).name},x)), in.Exclude, 'UniformOutput', false);
    else
        A = cellfun(@(x) cellfun(@isempty, regexpi({out(:).name},x)), in.Exclude, 'UniformOutput', false);
    end
    out(~all(cat(1,A{:}),1)) = [];
end

% --- Output --------------------------------------------------------------

for i = 1:numel(out)
    
    % Fullname
    out(i).fullname = [out(i).folder filesep out(i).name];
    
    % Basename and extension
    [~, out(i).basename, out(i).extension] = fileparts(out(i).name);
    
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