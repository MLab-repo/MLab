function out = CLIm(varargin)
%ML.CLIm CLI manager
%
%   This function is reserved for internal use, and regular users should
%   not use it. If you have any question about this function, please ask a
%   MLab developper.
%
%   See also ML.CW.CLI, ML.Session.get

% --- Inputs
in = ML.Input;
in.name('') = @isvarname;
in.action('action') = @(x) ismember(x, {'action', 'input', 'select'});
[in, unmin] = +in;

% --- Find object
this = ML.Session.get('MLab_CLI', in.name);

% --- Perform action
switch in.action
    
    case 'select'
        
        this.toggle(unmin{2}{1}, unmin{2}{2});
        
    case 'input'
        
        this.get_input(unmin{2});
        
    case 'action'
        
        elm = this.elms{unmin{2}};
        out = this.(elm.action)(elm.args{:});
        
        % --- Display
        if this.hlmode && out
            this.print;
        elseif ismethod(this, 'structure')
            this.structure;
        end
        
        return
        
end

% Registration
ML.Session.set('MLab_CLI', this.name, this);

% Output
if nargout
    out = true;
end