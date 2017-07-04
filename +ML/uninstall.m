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
        fprintf('You are going to uninstall MLab.\n');
        fprintf('Please keep in mind that <strong>this operation is not reversible</strong>.\n\n');
        fprintf('Please choose:\n');
        fprintf('\t[u] Uninstall MLab and all configuration files\n');
        fprintf('\t[k] Uninstall MLab but keep configuration files\n');
        fprintf('\t[Enter] Quit the uninstaller\n');
        s = input('?> ', 's');
        
        if isempty(s)
            fprintf('Uninstallation aborted.\n');
            return
        end
        if ~ismember(s, {'u', 'k'}), continue; end
        
        % Remove MLab
        fprintf('Removing MLab ...'); tic
        warning off
        rmpath(genpath(config.path));
        rmdir(config.path, 's');
        warning on
        fprintf(' %.2f sec\n', toc);
        
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
fprintf('Bye bye !\n');
