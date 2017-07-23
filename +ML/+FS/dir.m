function out = dir(varargin)
% ML.FS.dir Directory content
%   OUT = ML.FS.dir lists the files and folders in the current folder, 
%   except for the files starting with a dot. In particular, '.' and '..' 
%   are exluded. As for DIR, results appear in the order returned by the 
%   operating system. The output is a structure with fields:
%       - 'name'
%       - 'folder'
%       - 'basename'
%       - 'fullname'
%       - 'extension' (e.g. '.m', '.png')
%       - 'date'
%       - 'bytes'
%       - 'isdir'
%       - 'datenum'
%
%   ML.FS.dir(IN) specifies the directory to search in.
%
%   ML.FS.dir(..., 'Include', KEEP) or
%   ML.FS.dir(..., 'Keep', KEEP) filters the output to keep only the
%   elements whose name match the regular expression patterns in KEEP. KEEP
%   can be a single pattern string or a cell of pattern strings.
%
%   ML.FS.dir(..., 'Exclude', REM) or
%   ML.FS.dir(..., 'Remove', REM) filters the output to remove all elements
%   whose name match the regular expression patterns in REM. REM can be a 
%   single pattern string or a cell of pattern strings.
%
%   ML.FS.dir(..., 'CaseSensitive', false) performs inclusion/exclusion
%   filtering case-insensitively.
%
%   ML.FS.dir(..., 'Only', TYPE) filters the output to return only
%   elements of a certain type. TYPE can be 'Files' or 'Folders'.
%
%   See also ML.FS.rdir, dir, regexp
%
%   More on ...

% === MAIN ================================================================

% --- Inputs --------------------------------------------------------------

in = ML.Input;
in.Path{pwd} = 'str';
in.Only('') = @(x) ismember(lower(x), {'file', 'files', 'folder', 'folders', 'dir'});
in.Include({}) = 'str,cellstr';
in.Exclude({}) = 'str,cellstr';
in.Keep({}) = 'str,cellstr';
in.Remove({}) = 'str,cellstr';
in.CaseSensitive(true) = 'logical';
in.process;

% --- Process -------------------------------------------------------------

varargin{end+1} = 'MaxRecursionLevel';
varargin{end+1} = 1;

out = ML.FS.rdir(varargin{:});

% --- Output --------------------------------------------------------------

out = rmfield(out, 'level');

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