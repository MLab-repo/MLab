function out = config(varargin)
%ML.config MLab configuration
%   ML.config() starts the configuration interface.
%
%   ML.config(MENU) starts the configuration interface on a specific menu.
%
%   C = ML.config() returns the MLab configuration structure.
%
%   C = ML.config(CFILE) returns the configuration structure stored in the
%   CFILE configuration file.
%
%   See also ML.start.
%

% --- Configuration request -----------------------------------------------
if nargout
    
    % --- Inputs
    in = ML.Input;
    in.cfile{'MLab'} = @ischar;
    in = +in;

    % --- Get configuration structure
    tmp = load([prefdir filesep  in.cfile '.mat']);
    out = tmp.config;
    
% --- Configuration interface ---------------------------------------------
else
    
    % --- Inputs
    in = ML.Input;
    in.menu{'main'} = @ischar;
    in = +in;

    % --- Choose interface to launch
    if ~ML.isdesktop
        ML.Config.CLI(in.menu);
    else
        ML.Config.CWI(in.menu);
    end
end