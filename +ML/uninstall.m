function uninstall(varargin)
% ML.uninstall MLab uninstall
%   ML.uninstall() uninstalls MLab and all associated plugins.
%
%   ML.uninstall('plugins', P) uninstalls only the plugin(s) P. P can be
%   either a string (single plugin name) or a cell of string (list of
%   plugin names).
%
%   ML.uninstall(..., 'config', false) doesn't uninstall the configuration
%   files. After uninstallation with the default value (true), there is no
%   trace left of MLab in the filesystem.
%
%   See also ML.stop
%
%   More on <a href="matlab:ML.doc('ML.uninstall');">ML.doc</a>

% --- Inputs
in = ML.Input;
in.plugins({}) = @(x) ischar(x) || iscellstring(x);
in.config(true) = @islogical;
in = +in;

% Cellification
if ischar(in.plugins)
    in.plugins = {in.plugins};
end

% --- Load configuration
config = ML.config;

if isempty(in.plugins)
    
    % --- Remove MLab
    
    while true
        
        % Ask for confirmation
        clc
        
        cws = get(0,'CommandWindowSize');
        if usejava('desktop')
            fprintf('\n--- [\b<strong>MLab uninstall</strong>]\b %s\n\n', repmat('-', [1 cws(1)-22]));
            fprintf('You are about to <strong>uninstall</strong> [\bMLab]\b on this computer.\n\n');
            fprintf('Please keep in mind that <strong>this operation is not reversible</strong>.\n\n');
            fprintf('Please choose an action:\n\n');
            fprintf('\t[[\b<strong>u</strong>]\b] Uninstall MLab and all configuration files\n');
            fprintf('\t[[\b<strong>k</strong>]\b] Uninstall MLab but keep configuration files\n');
            fprintf('\t[[\b<strong>Enter</strong>]\b] Quit the uninstaller\n\n');
        else
            fprintf('\n--- \033[1;33;40mMLab uninstall\033[0m %s\n\n', repmat('-', [1 cws(1)-22]));
            fprintf('You are about to \033[1muninstall\033[0m \033[1;33;40mMLab\033[0m on this computer.\n\n');
            fprintf('Please keep in mind that \033[1mthis operation is not reversible\033[0m.\n\n');
            fprintf('Please choose an action:\n\n');
            fprintf('\t[\033[1;33;40mu\033[0m] Uninstall MLab and all configuration files\n');
            fprintf('\t[\033[1;33;40mk\033[0m] Uninstall MLab but keep configuration files\n');
            fprintf('\t[\033[1;33;40mEnter\033[0m] Quit the uninstaller\n\n');
        end
        
        s = input('?> ', 's');
        
        if isempty(s)
            fprintf('\n[\bUninstallation aborted]\b.\n\n');
            return
        end
        if ~ismember(s, {'u', 'k'}), continue; end
        
        % Remove startup files
        fprintf('Removing startup files ...'); tic
        fname_startup_MLab = fullfile(matlabroot, 'toolbox', 'local', 'startup_MLab.m');
        if exist(fname_startup_MLab, 'file')
            delete(fname_startup_MLab);
        end
        fprintf(' %.2f sec\n', toc);
        
        % Remove configuration file
        fprintf('Removing configuration files ...'); tic        
        if strcmp(s, 'u')
            
            D = dir([prefdir filesep 'MLab*.mat']);
            for i = 1:numel(D) 
                delete([prefdir filesep D(i).name]);
            end
                
        end
        fprintf(' %.2f sec\n', toc);
        
        % Remove MLab
        fprintf('Removing MLab ...'); tic
        warning off
        rmpath(genpath(config.path));
        rmdir(config.path, 's');
        warning on
        fprintf(' %.2f sec\n', toc);
        
        break
    end
    
else
    
    % --- Remove plugin(s)
    
    for i = 1:numel(in.plugins)
        
        % Remove plugin
        warning off
        rmdir([config.path 'Plugins' filesep in.plugins{i}], 's');
        warning on
        
        % Remove configuration file
        if in.config
            fname = [prefdir filesep 'MLab_' in.plugins{i} '.mat'];
            if exist(fname, 'file'), delete(fname); end
        end
    end
    
end

% --- Update
rehash toolboxcache

% --- Bye bye message
fprintf('\nMLab is now uninstalled.\n');
if usejava('desktop')
    fprintf('[\bBye bye !]\b\n');
else
    fprintf('\033[33mBye bye !\033[0m\n');
end
