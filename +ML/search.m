function OUT = search(varargin)
%ML.FS.search Locate functions, packages, classes, methods and more
%   ML.FS.search(NAME) displays information on the script, function, 
%   package, class, method or MLab item (MLab, plugin or tutorial) 
%   designated by the entity NAME. NAME can be a string or a function 
%   handle.
%
%   ML.FS.search(..., 'first') displays information on the first found item
%   designated by the entity NAME. This entry is the one accessible in the
%   path, the others are shadowed.
%
%   ML.FS.search(..., 'notfound', NFP) uses a custom "not found procedure".
%   NFP is a string which can be:
%       - 'none': Nothing is done
%       - 'info': A message is displayed in the command window
%       - 'warning': (default) A warning is thrown
%       - 'error': An error is thrown
%
%   out = ML.FS.search(...) returns a ML.FS.Search-derived object, or a 
%   cell of ML.FS.Search-derived objects if the 'all' option is invoked.
%
%   See also which, lookfor, exist
%
%   More on ...

% --- Inputs --------------------------------------------------------------

in = ML.Input;
in.req = @(x) ischar(x) || isa(x, 'function_handle');
in.what{'all'} = @(x) ismember(x, {'first', 'all'});
in.notfound('warning') = @(x) ismember(x, {'none', 'info', 'warning', 'error'});
in = in.process;

% --- Checks --------------------------------------------------------------

% Manage function handles
if isa(in.req, 'function_handle')
    in.req = func2str(in.req);
end

% Empty request
if isempty(in.req)
    warning('ML:FS:search', 'Empty input.');
    return
end

% --- Path list ----------------------------------------------------------

Path = {};

% --- MLab
if strcmp(in.req, 'MLab')
    conf = ML.config;
    Path{end+1,1} = conf.path;
else
    
    % --- Files and classes
    if strcmp(in.what, 'all')
        
        Path = [Path ; which(in.req, '-all')];
        if ~isempty(strfind(in.req, '.'))
            Path = [Path ; which(pathify(in.req), '-all')];
        end
        
    else
        tmp = which(in.req);
        if ~isempty(tmp)
            Path{end+1,1} = tmp;
        else
            tmp = which(pathify(in.req));
            if ~isempty(tmp)
                Path{end+1,1} = tmp;
            end
        end
    end
    
    % --- Packages
    p = meta.package.fromName(in.req);
    if ~isempty(p)
        
        if isempty(strfind(p.Name, '.'))
            tmp = what(p.Name);
        else
            tmp = what(['+' strrep(p.Name, '.', [filesep '+'])]);
        end
        
        for j = 1:numel(tmp)
            Path{end+1,1} = tmp(j).path;
        end
        
    end
    
    % --- Methods
    k = find(in.req=='.', 1, 'last');
    if ~isempty(k) && ~isempty(which(in.req(1:k-1)))
        
        % Class & category
        tmp = ML.FS.search(in.req(1:k-1));
        cls = tmp{1};
        
        % Path
        if exist([cls.Fullpath filesep in.req(k+1:end) '.m'], 'file')
            Path{end+1,1} = [cls.Fullpath filesep in.req(k+1:end) '.m'];
        elseif exist([cls.Fullpath filesep in.req(k+1:end) '.p'], 'file')
            Path{end+1,1} = [cls.Fullpath filesep in.req(k+1:end) '.p'];
        end
        
    end
    
    % % %
    % % %     % --- Plugins ---------------------------------------------------------
    % % %
    % % %     if isnotfound && exist([ppath in.req], 'dir')
    % % %         info.type = 'Plugin';
    % % %         info.category = 'Plugin';
    % % %         path{i} = [ppath in.req];
    % % %         isnotfound = false;
    % % %     end
    % % %
    
end

% --- Path list reduction -------------------------------------------------

% --- Constructors

for i = 1:numel(Path)
    
    [tmp, name, ext] = fileparts(Path{i});
    [~, nclass] = fileparts(tmp);
    if ismember(ext, {'.m', '.p'}) && ...
            strcmp(nclass(1), '@') && strcmp(nclass(2:end), name)
        Path{i} = tmp;
    end
end

% --- Doublons

Path = unique(Path, 'stable');

% --- Object creation -----------------------------------------------------

if isempty(Path)
    
    if nargout
        OUT = struct();
    else
        switch in.notfound
            case 'info'
                fprintf('Could not find anything for ''%s''.\n', in.req);
            case 'warning'
                warning('ML:FS:search:NotFound', ['Could not find anything for ''' in.req '''.']);
            case 'error'
                error('ML:FS:search:NotFound', ['Could not find anything for ''' in.req '''.']);
        end
    end
    
    return
end

out = cellfun(@ML.FS.path2obj, Path, 'UniformOutput', false);

% --- Output & display ----------------------------------------------------

if nargout
    
    if strcmp(in.what, 'all')
        OUT = out;
    else
        OUT = out{1};
    end
    
else
    
    fprintf('\n');
    ML.CW.line(['Search Results for ''' in.req '''']);
    fprintf('\n');
    
    out{1}.display;
    
    if strcmp(in.what, 'all')
        
        if numel(out)==1
            fprintf('\n─── No other result have been found.\n\n');
        else
            
            fprintf('─── Other (shadowed) results:\n');
            T = cell(numel(out)-1,2);
            for i = 2:numel(out)
                
                DocClass = class(out{i});
                k = strfind(DocClass, '.');
                if numel(k), DocClass = DocClass(k(end)+1:end); end
                
                % --- Category
                switch out{i}.Category
                    case 'Toolbox'
                        cat = [out{i}.Toolbox ' toolbox'];
                    otherwise
                        cat = out{i}.Category;
                end
                
                % --- Class
                switch DocClass
                    case 'Method'
                        type = ['~b{' out{i}.Class '} method'];
                    otherwise
                        type = lower(DocClass);
                end
                
                
                % --- Table elemnts
                T{i-1,1} = [ML.FS.search.Root.slnk(out{i}.Fullpath, out{i}.Name) ' (' type ' / ' cat ')'];
                T{i-1,2} = ['~c[100 175 175]{' out{i}.Fullpath '}'];
            end
            ML.text.table(T, 'style', 'compact', 'border', 'none');
        end
    end
    
end

end

% === Local functions =====================================================

function out = pathify(in)

tmp = strsplit(in, '.');
tmp(1:end-1) = cellfun(@(x) ['+' x], tmp(1:end-1), 'UniformOutput', false);
out = strjoin(tmp, filesep);

end

%! ------------------------------------------------------------------------
%! Contributors: Raphaël Candelier
%! Version: 1.6
%
%! Revisions
%   1.6     (2016/06/24): Creation of the ML.Doc.path2obj function and the
%               static method ML.Doc.Root.slnk.
%   1.5     (2016/06/15): Rename to ML.search. Creation of the
%               ML.Doc.Root class and derivatives.
%   1.4     (2016/05/07): Move most of the content to the ML.Tell objects.
%   1.3     (2016/04/02): Allow for the 'all' option.
%   1.2     (2016/03/14): Complete rewriting. Among several other changes,
%               this version differentiates category and type.
%   1.1     (2015/04/04): Added the pattern-based inclusion/exclusion
%               mechanism.
%   1.0     (2010/01/01): Initial version.
%
%! ------------------------------------------------------------------------