function out = default(varargin)
%ML.Config.default Reset default configuration
%   ML.Config.default() resets MLab configuration to default.
%
%   ML.Config.default(..., 'cfile', CFILE) saves the default
%   configuration in a specific file in the PREFDIR directory. The default
%   value of CFILE is 'MLab'.
%
%   ML.Config.default(..., 'quiet', false) displays a creation message.
%
%   C = ML.Config.default(...) returns the configuration structure.
%
%   See also ML.config.
%
%   More on <a href="matlab:ML.doc('ML.Config.default');">ML.doc</a>

% === Input variables =====================================================

in = ML.Input;
in.cfile('MLab') = @ischar;
in.quiet(true) = @islogical;
in = +in;

% -------------------------------------------------------------------------

fname = [prefdir filesep in.cfile '.mat'];

% =========================================================================

% --- Remove the shortcuts
S = com.mathworks.mlwidgets.shortcuts.ShortcutUtils;
if ~isempty(S.getShortcutsByCategory('MLab'))
    tmp = arrayfun(@char, S.getShortcutsByCategory('MLab').toArray, 'UniformOutput', false);
    for i = 1:numel(tmp)
        S.removeShortcut('MLab', tmp{i});
    end
end

% --- Create default configuration structure
config = struct();

config.version = 1;

config.charset = 'UTF8';

tmp = mfilename('fullpath');
config.path = tmp(1:end-19);

config.startup = struct('autostart', true, ...
    'update', true, ...
    'disp_message', true, ...
    'message', 'Hello <user:name>');

config.start = struct('update', false);

config.updates = struct('repository', 'https://github.com/MLab-admin/MLab.git', ...
    'plugin_base', 'https://github.com/MLab-admin/Plugin-');

config.shortcut = struct();
config.shortcut.start = struct('value', false, ...
    'desc', 'Start', ...
    'code', ['tmp = load([prefdir filesep ''MLab.mat'']);' char(10) ...
    'addpath(tmp.config.path, ''-end'');' char(10) ...
    'ML.start;'], ...
    'icon', 'Images/Shortcuts/Start.png');
config.shortcut.stop = struct('value', false, ...
    'desc', 'Stop', ...
    'code', ML.Config.failsafe_shortcut('ML.stop;'), ...
    'icon', 'Images/Shortcuts/Stop.png');
config.shortcut.state = struct('value', false, ...
    'desc', 'State', ...
    'code', ['P = strsplit(path, '':''); ' char(10) ...
    'tmp = load([prefdir filesep ''MLab.mat'']);' char(10) ...
    'if any(strcmp(tmp.config.path(1:end-1), P))' char(10) ...
    '    fprintf(''MLab is started.\n'')' char(10) ...
    'else' char(10) ...
    '    fprintf(''MLab is not started.\n'')' char(10) ...
    'end' char(10)], ...
    'icon', 'Images/Shortcuts/State.png');
config.shortcut.config = struct('value', false, ...
    'desc', 'Config', ...
    'code', ML.Config.failsafe_shortcut('ML.config;'), ...
    'icon', 'Images/Shortcuts/Config.png');
config.shortcut.update = struct('value', false, ...
    'desc', 'Update', ...
    'code', ML.Config.failsafe_shortcut('ML.update;'), ...
    'icon', 'Images/Shortcuts/Update.png');
config.shortcut.plugins = struct('value', false, ...
    'desc', 'Plugins', ...
    'code', ML.Config.failsafe_shortcut('ML.plugins;'), ...
    'icon', 'Images/Shortcuts/Plugins.png');

config.user = struct('name', '', 'email', '');

% --- Save configuration structure
save(fname, 'config');

% --- Message display
if ~in.quiet
    printf('The configuration file ''%s'' has been reset to default.', in.cfile);
end

% --- Output
if nargout
    out = config;
end