function stop(varargin)
%ML.stop MLab stop
%   ML.stop() stops MLab. All dependencies are automatically removed from
%   Matlab's path.
%
%   See also ML.start
%
%   More on <a href="matlab:ML.doc('ML.stop');">ML.doc</a>

%! TO DO:
%   - ML.doc

% --- Inputs
in = ML.Input;
in.plugin({}) = @(x) ischar(x) || iscellstr(x);
in = +in;

% Cellification
if ischar(in.plugin), in.plugin = {in.plugin}; end

% Load configuration
config = ML.config;

if isempty(in.plugin)
    
    % --- Remove all plugins
    
    %! TO DO
    
    % --- Remove MLab from path
    rmpath(config.path);

    % --- Stop message
    cws = get(0,'CommandWindowSize');
    ML.CW.print('%s~bc[red]{MLab is stopped}\n', repmat(' ', [1 cws(1)-16]));
    ML.CW.line;

    % -- Bye bye message
    
    %! TO DO
    
    
else
    
    %! TO DO
    
end

rehash