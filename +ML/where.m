function out = where(varargin)
%ML.where Find a string in files
%   ML.where(STR, DIR) lists the m-files containing the string STR in the
%   directory DIR and all subdirectories, recursively. The results are
%   displayed in the command window.
%
%   OUT = ML.where(...) returns a n-by-3 cell of results. The first column
%   contains the files' full names, the second contain the line numbers and
%   the third the line content. The results are not displayed, unless the 
%   'Display' parameter is explicitely set to true.
%
%   ML.where(..., 'Extensions', EXT) specifies a list of file extensions to
%   filter, in a cell of strings. The default value is m-files only.
%
%   ML.where(..., 'CaseSensitive', true) searches case-sensitively, the
%   default search being case-insensitive.
%
%   ML.where(..., 'Fullpath', true) returns and display the full path of the
%   files where occurences are found.
%
%   [TO DO] ML.where(STR) assumes that DIR is the current project's 'Programs'
%   folder. This syntax requires that the 'Projects' plugin is installed
%   and that a project is selected.
%
%   See also ML.which, depfun, which
%
%   More on <a href="matlab:ML.doc('ML.where');">ML.doc</a>

% --- Inputs

in = ML.Input;
in.str = @ischar;
in.dir{''} = @(x) exist(x, 'dir');
in.Extensions('m') = @(x) ischar(x) || iscellstr(x);
in.CaseSensitive(false) = @islogical;
in.Display(false) = @islogical;
in.Fullpath(false) = @islogical;
in = +in;

% Cellification
if ischar(in.Extensions), in.Extensions = {in.Extensions}; end

% --- Automatic directories
if strcmp(in.dir, 'MLab')
    config = ML.config;
    in.dir = config.path;
end

% TO DO: Current project directory

if isunix
    
    % === Unix method =====================================================
    
    % Get extensions
    ext = strjoin(in.Extensions, ',');
    if in.CaseSensitive, cso = ''; else, cso = '-i'; end
    
    % Perform search
    cmd = ['grep ' cso ' --include=\*.{' ext ',} -rn "' in.dir '" -e "' in.str '"'];
    [status, res] = unix(cmd);
    
    % Parse results
    if status || isempty(res)
        Res = cell(0,3);
    else
        tmp = textscan(res, '%s', 'Delimiter', '\n');
        tmp = tmp{1};
        tmp = cellfun(@strtrim, tmp, 'UniformOutput', false);
        Res = cell(numel(tmp),3);
        for i = 1:numel(tmp)
            K = strfind(tmp{i}, ':');
            Res{i,1} = tmp{i}(1:K(1)-1);
            Res{i,2} = tmp{i}(K(1)+1:K(2)-1);
            Res{i,3} = tmp{i}(K(2)+1:end);
        end
    end
    
else
    
    % === Pure Matlab method ==============================================
    
    warning('ML:where:OS', 'ML.where is not implemented yet on non-Unix system.');
    if nargout, out = {}; end
    return
    
end

% --- Manage output
if nargout
    out = Res;
    
    if ~in.Fullpath
        out(:,1) = cellfun(@(x) x(numel(in.dir)+1:end), out(:,1), 'UniformOutput', false);
    end
    
else
    in.Display = true;
end

if in.Display
    
    % --- Group by files
    G = ML.groupby(Res);
    
    % --- Display
    ML.CW.line(['<strong>Occurences of "' in.str '"</strong>']);
    
    fprintf('\nRoot: %s\n', in.dir);
    
    if status, fprintf('\nThe folder couldn''t be found.\n'); end
    if isempty(Res), fprintf('\nNo occurence found.\n'); end
    
    for i = 1:size(G,1)
                
        if in.Fullpath
            fname = G{i,1};
        else
            fname = G{i,1}(numel(in.dir)+1:end);
        end
        
        fprintf('\n<a href="matlab:edit(''%s'');">%s</a>\n',G{i,1}, fname);
        
        for j = 1:size(G{i,2},1)
            
            tmp = regexprep(G{i,2}{j,2}, in.str, ['<strong>' in.str '</strong>'], 'preservecase');
            if ~in.CaseSensitive
                tmp = strrep(tmp, 'STRONG>', 'strong>');
            end
            fprintf('\t<a href="matlab:opentoline(''%s'', %s);">%s</a>\t%s\n', ...
                G{i,1}, G{i,2}{j,1}, G{i,2}{j,1}, tmp);
        end
        
    end
    fprintf('\n');
    
end

end

%! ------------------------------------------------------------------------
%! Author: Raphaël Candelier
%! Version: 2.2
%
%! Revisions
%   2.2     (2015/04/18): Changed ML.text.line for ML.CW.line
%   2.1     (2015/04/06): Handled empty results, corrected the ':' bug in
%               the Unix version, trimmed grep results, handled
%               non-existant directory, added the 'MLab' shortcut.
%   2.0     (2015/04/03): Rewrited the whole code for Unix and created the
%               help.
%   1.0     (2015/01/01): Initial version.
%
%! To_do
%   Manage automatic directoring if a Project is selected
%   MLab doc
%
%! ------------------------------------------------------------------------
%! Doc
%   <title>To do</title>