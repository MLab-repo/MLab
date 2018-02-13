function out = path2obj(varargin)
%ML.FS.path2obj transforms a path into a Search objet
%   OBJ = ML.FS.path2obj(PATH) returns an object corresponding to the
%   element located at the string PATH.
%
%   See also ML.FS.search, ML.FS.Search.Function etc.

% --- Inputs --------------------------------------------------------------

in = ML.Input;
in.path = @ischar;
in = in.process;

% --- Definitions ---------------------------------------------------------

% --- Pathes

% Toolboxes
tpath = [matlabroot filesep 'toolbox' filesep];

% MLab & plugins
conf = ML.config;
ppath = [conf.path 'Plugins' filesep];

% --- Type ----------------------------------------------------------------

% Preparation
info = struct('category', '', 'type', '');

if ~isempty(in.path)
    
    % --- Category --------------------------------------------------------
    
    if regexp(in.path, '^built-in \(.*\)', 'once')
        
        % Built-in
        info.category = 'Built-in';
        
        % Redefine path
        tmp = regexp(in.path, '^built-in \((.*)\)', 'tokens');
        in.path = tmp{1}{1};
        
    elseif strfind(in.path, [tpath 'matlab' filesep])
        
        % Matlab
        info.category = 'Matlab';
        
    elseif strfind(in.path, tpath)
        
        % Toolbox
        info.category = 'Toolbox';
        x = in.path(numel(tpath)+1:end);
        info.toolbox = x(1:strfind(x, filesep)-1);
        
    elseif strfind(in.path, ppath)
        
        info.category = 'Plugin';
        x = in.path(numel(ppath)+1:end);
        info.plugin = x(1:strfind(x, filesep)-1);
        
    elseif strfind(in.path, conf.path)
        
        info.category = 'User';
        info.type = 'MLab';
        
    else
        
        % User
        info.category = 'User';
        
    end
    
    % --- Type ------------------------------------------------------------
    
    [P, name, ext] = fileparts(in.path);
        
    if ~isempty(name)
        switch name(1)
            
            case '+'
                info.type = 'Package';
                
            case '@'
                info.type = 'Class';
                
            otherwise
                
                % --- Method, function or script ?
                if ismember(ext, {'', '.m', '.p'})
                                        
                    [~, tmp] = fileparts(P);
                    if strcmp(tmp(1), '@')
                        
                        % Method
                        info.type = 'Method';
                        
                        cls = ML.FS.path2obj(P);
                        info.class = cls.Name;
                        
                    else
                        
                        info.type = 'Function';
                        
                        if ismember(ext, {'.m', '.p'})
                            
                            try
                                nargin(in.path);
                                
                            catch EX
                                if strcmp(EX.identifier, 'MATLAB:nargin:isScript')
                                    info.type = 'Script';
                                else
                                    rethrow(EX);
                                end
                            end
                        end
                    end
                    
                end
        end
    end
    
end

% --- Containing package ----------------------------------------------

if ~ismember(info.type, {'Class', 'Method'})
    str = fileparts(in.path);
    I = strfind(str, [filesep '+']);
    tmp = cell(numel(I), 1);
    for j = 1:numel(I)
        if j<numel(I)
            tmp{j} = str(I(j)+2:I(j+1)-1);
        else
            tmp{j} = str(I(j)+2:end);
        end
    end
    if ~isempty(tmp)
        info.package = strjoin(tmp, '.');
    end
end

% --- ML.Doc objects -----------------------------------------------

switch info.type
    
    case 'Function'
        out = ML.FS.search.Function(in.path, 'info', info);
        
    case 'Script'
        out = ML.FS.search.Script(in.path, 'info', info);
        
    case 'Package'
        out = ML.FS.search.Package(in.path, 'info', info);
        
    case 'Class'
        out = ML.FS.search.Class(in.path, 'info', info);
        
    case 'Method'
        out = ML.FS.search.Method(in.path, 'info', info);
        
    case 'MLab'
        out = ML.FS.search.MLab();
        
    case 'Plugin'
        out = ML.FS.search.Plugin(in.path, 'info', info);
        
    otherwise
        warning('ML:FS:Search:UnknownType', 'Unknown type');
end

%! ------------------------------------------------------------------------
%! Contributors: Raphaël Candelier
%! Version: 1.0
%
%! Revisions
%   1.0     (2016/06/17): Initial version.
%
%! ------------------------------------------------------------------------