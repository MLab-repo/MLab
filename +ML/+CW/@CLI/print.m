function print(this, varargin)
%ML.CW.CLI/print
%   ML.CW.CLI/print() prints the grid of the CLI in the command window.
%
%   ML.CW.CLI/print(..., 'option', OPT) specifies options to modify the
%   default printing behavior, like row/column headers or appearance. The
%   possible options are the one accepted by <a href="matlab:help ML.Text.table;">ML.Text.table</a>.
%
%   See also ML.CW.CLI, ML.CW.CLI/text, ML.CW.CLI/input, ML.CW.CLI/select, ML.CW.CLI/action
%
%   More on <a href="matlab:ML.doc('ML.CW.CLI.print');">ML.doc</a>

% --- Definitions
if this.hlmode
    ci = '';
    cf = '';
else
    ci = '\033[1;33;40m';
    cf = '\033[0m';
end

% --- First call: store informations
if this.isfirst
    this.print_param = varargin;
else
    varargin = this.print_param;
end

% --- Structure definition
if ismethod(this, 'structure')
    this.structure;
end

this.isfirst = false;

while true
    
    % ---
    T = cell(size(this.elms));
    for i = 1:numel(this.elms)
        if ~isempty(this.elms{i})
            
            switch this.elms{i}.type
                
                case 'text'
                    T{i} = this.elms{i}.text;
                    
                case 'input'
                    
                    T{i} = {};
                    if ~isempty(this.elms{i}.desc)
                        T{i}{1} = this.elms{i}.desc;
                    end
                    
                    code = ['ML.CW.CLIm(''name'', ''' this.name ''', ''action'', ''input'', ''param'', ' num2str(i) ');'];
                    
                    if this.hlmode
                        T{i}{end+1} = ['<a href="matlab:' code '">[' this.elms{i}.value ']</a>'];
                    else
                        k = numel(this.clal)+1;
                        this.clal{k} = code;
                        T{i}{end+1} = ['[' ci num2str(k) cf '] "' this.elms{i}.value '"'];
                        
                    end
                    
                case 'select'
                    
                    T{i} = {};
                    if ~isempty(this.elms{i}.desc)
                        T{i}{1} = this.elms{i}.desc;
                    end
                    
                    for j = 1:numel(this.elms{i}.list)
                        
                        code = ['ML.CW.CLIm(''name'', ''' this.name ''', ''action'', ''select'', ''param'', {' num2str(i) ',' num2str(j) '});'];
                        
                        if this.hlmode
                            
                            T{i}{end+1} = ['<a href="matlab:' code '">' this.elms{i}.symbols{this.elms{i}.values(j)+1} '</a> ' this.elms{i}.list{j}];
                            
                        else
                            
                            k = numel(this.clal)+1;
                            this.clal{k} = code;
                            
                            T{i}{end+1} = ['[' ci num2str(k) cf '] ' this.elms{i}.symbols{this.elms{i}.values(j)+1} ' - ' this.elms{i}.list{j}];
                            
                        end
                    end
                    
                case 'action'
                    
                    code = ['ML.CW.CLIm(''name'', ''' this.name ''', ''param'', ' num2str(i) ');'];
                    
                    if this.hlmode
                        
                        T{i} = ['<a href="matlab:' code '">' this.elms{i}.desc '</a>'];
                        
                    else
                        
                        k = numel(this.clal)+1;
                        this.clal{k} = code;
                        T{i} = ['[' ci num2str(k) cf '] ' this.elms{i}.desc];
                        
                    end
                    
            end
        end
    end
    
    % --- Display
    clc
    if ~isempty(this.title), ML.CW.line(this.title); end
    if ~isempty(this.desc), ML.CW.print(['\n' this.desc '\n\n']); end
    ML.Text.table(T, varargin{:});
    
    % --- Stop here in CW mode
    if this.hlmode, break; end
    
    % --- Prompt (CL mode)
    fprintf('Please choose an action: [Enter to quit]\n');
    z = input('?> ', 's');
    
    % --- Check and convert input
    if isempty(z), break; end
    
    if isempty(regexp(z, '^[0-9]*$', 'once'))
        this.clal = {};
        continue;
    else
        z = str2double(z);
        if z<1 || z>numel(this.clal)
            this.clal = {};
            continue; 
        end
    end
   
    % --- Action
    eval(['c = ' this.clal{round(z)}]);
    
    % --- Stop ?
    if ~c, break; end
    
    % --- Reset
    this.clal = {};
        
end