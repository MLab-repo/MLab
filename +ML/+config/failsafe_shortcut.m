function out = failsafe_shortcut(code)
%ML.Config.failsafe_shortcut Failsafe code for shortcuts.
%
%   Note: This function is designed for internal MLab use, a regular user
%   should not have to call it. If you have questions about this program,
%   please ask a MLab developper.
%
%   See also ML.config.

nl = char(10);

out = ['try' nl ...
    '    ' code nl ...
    'catch' nl '    '];

if usejava('desktop')
    out = [out 'fprintf(''The shortcut failed. Is MLab started ?\n <a href="matlab:tmp = load([prefdir filesep ''''MLab.mat'''']);' ...
        'addpath(tmp.config.path, ''''-end''''); ML.start;">Click here</a> to (re)-start MLab.\n'');'];
else
    out = [out 'fprintf(''The shortcut failed. Is MLab started ?\n Run the \033[1;33;40mML.start\033[0m script to start MLab.\n'');'];
end

out = [out nl 'end'];