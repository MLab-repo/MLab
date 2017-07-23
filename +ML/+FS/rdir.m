function out = rdir(varargin)
% ML.FS.rdir Recursive directory listing
%   OUT = ML.FS.rdir recursively lists the files and folders in the current
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
%   ML.FS.rdir(IN) specifies the root directory to search in.
%
%   ML.FS.rdir(..., 'MaxRecursionLevel', MAX) specifies the maximum
%   recursion level. As the first recursion is level 1, calling ML.FS.rdir
%   with MaxRecursionLevel set to 1 is equivalent to call ML.FS.dir.
%
%   ML.FS.rdir(..., 'Include', INC) include during the search only the
%   elements whose name match the regular expression patterns in INC. INC
%   can be a single pattern string or a cell of pattern strings.
%
%   ML.FS.rdir(..., 'Exclude', EXC) exclude during the search all elements
%   whose name match the regular expresion patterns in EXC. EXC can be a
%   single pattern string or a cell of pattern strings.
%
%   ML.FS.rdir(..., 'Keep', KEEP) filters the output to keep only the
%   elements whose name match the regular expression patterns in KEEP. KEEP
%   can be a single pattern string or a cell of pattern strings.
%
%   ML.FS.rdir(..., 'Remove', REM) filters the output to remove all
%   elements whose name match the regular expression patterns in REM. REM
%   can be a single pattern string or a cell of pattern strings.
%
%   ML.FS.rdir(..., 'CaseSensitive', false) performs inclusion/exclusion
%   filtering case-insensitively.
%
%   ML.FS.rdir(..., 'Only', TYPE) filters the output to return only
%   elements of a certain type. TYPE can be 'Files' or 'Folders'.
%
%   OUT = ML.FS.rdir(..., 'OutputType', 'tree') returns a tree-structured
%   structure array, with a field 'children' containing either a NaN (for
%   files) or another tree-like structure (for folders). The default value
%   of OutputType is 'list'.
%
%   See also dir, ML.FS.dir, regexp
%
%   More on ...

% === MAIN ================================================================

% --- Inputs --------------------------------------------------------------

in = ML.Input;
in.Path{pwd} = 'str,topath';
in.Only('') = @(x) ismember(lower(x), {'file', 'files', 'folder', 'folders', 'dir'}) ;
in.Include({}) = 'str,cellstr,incell';
in.Exclude({}) = 'str,cellstr,incell';
in.Keep({}) = 'str,cellstr,incell';
in.Remove({}) = 'str,cellstr,incell';
in.CaseSensitive(true) = 'logical';
in.MaxRecursionLevel(intmax) = 'numeric,integer,>=1';
in.OutputType('list') = @(x) ismember(x, {'list', 'tree'});
in = in.process;

% --- Process -------------------------------------------------------------

% Start the recursion
out = getDir(in.Path, 1);

% Keep
if ~isempty(in.Keep)
    if in.CaseSensitive
        A = cellfun(@(x) cellfun(@isempty, regexp({out(:).name},x)), in.Keep, 'UniformOutput', false);
    else
        A = cellfun(@(x) cellfun(@isempty, regexpi({out(:).name},x)), in.Keep, 'UniformOutput', false);
    end
    out(all(cat(1, A{:}),1)) = [];
end

% Remove
if ~isempty(in.Remove)
    if in.CaseSensitive
        A = cellfun(@(x) cellfun(@isempty, regexp({out(:).name},x)), in.Remove, 'UniformOutput', false);
    else
        A = cellfun(@(x) cellfun(@isempty, regexpi({out(:).name},x)), in.Remove, 'UniformOutput', false);
    end
    out(~all(cat(1, A{:}),1)) = [];
end


% === NESTED ==============================================================

    function out = getDir(lpath, level)
        
        tmp = dir(lpath);
        
        % --- Filters
        
        % Remove items whose name starts with a dot
        tmp(cellfun(@(x) strcmp(x(1),'.'), {tmp(:).name})) = [];
        
        % Inclusion
        if ~isempty(in.Include)
            if in.CaseSensitive
                A = cellfun(@(x) cellfun(@isempty, regexp({tmp(:).name},x)), in.Include, 'UniformOutput', false);
            else
                A = cellfun(@(x) cellfun(@isempty, regexpi({tmp(:).name},x)), in.Include, 'UniformOutput', false);
            end
            tmp(all(cat(1, A{:}),1)) = [];
        end
        
        % Exclusion
        if ~isempty(in.Exclude)
            if in.CaseSensitive
                A = cellfun(@(x) cellfun(@isempty, regexp({tmp(:).name},x)), in.Exclude, 'UniformOutput', false);
            else
                A = cellfun(@(x) cellfun(@isempty, regexpi({tmp(:).name},x)), in.Exclude, 'UniformOutput', false);
            end
            tmp(~all(cat(1, A{:}),1)) = [];
        end
        
        % --- Populating the output
        
        switch in.OutputType
            
            case 'list'
                out = struct('name', {}, 'folder', {}, 'date', {}, 'bytes', {}, ...
                    'isdir', {}, 'datenum', {}, 'level', {}, 'fullname', {}, ...
                    'basename', {}, 'extension', {});
                
            case 'tree'
                out = struct('name', {}, 'folder', {}, 'date', {}, 'bytes', {}, ...
                    'isdir', {}, 'datenum', {}, 'level', {}, 'fullname', {}, ...
                    'basename', {}, 'extension', {}, 'children', {});
        end
        
        for i = 1:numel(tmp)
            
            % Level
            tmp(i).level = level;
            
            % Fullname
            tmp(i).fullname = [tmp(i).folder filesep tmp(i).name];
            
            % Basename and extension
            [~, tmp(i).basename, tmp(i).extension] = fileparts(tmp(i).name);
            
            % Children (for tree structure)
            if strcmp(in.OutputType, 'tree')
                tmp(i).children = NaN;
            end
            
            % Add item, with type filtering
            if tmp(i).isdir
                if ~ismember(lower(in.Only), {'file', 'files'})
                    out(end+1) = tmp(i); %#ok<*AGROW>
                end
            else
                if ~ismember(lower(in.Only), {'folder', 'folders', 'dir'})
                    out(end+1) = tmp(i);
                end
            end
            
            % --- Recursion
            
            % Check recursion level
            if level>=in.MaxRecursionLevel, continue; end
            
            % Perfrom recursion
            if tmp(i).isdir
                switch in.OutputType
                    
                    case 'list'
                        out = [out getDir(tmp(i).fullname, level+1)];
                        
                    case 'tree'                       
                        out(end).children = getDir(tmp(i).fullname, level+1);
                        
                end
                
            end
            
        end
        
    end

end

% === DOC =================================================================

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

%! To_do
%   - Write documentation.
%   - Change date format to 'YYYY-MM-DD HH:MM:SS' (based on datenum). Make
%       a MLab function for this, e.g. ML.Date.fromDatenum
