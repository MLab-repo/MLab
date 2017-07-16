function [in, unmin] = process(this)
%ML.Input/uplus Input argument parsing
%   IN = ML.Input/uplus executes the PARSE method of the parent class 
%   <a href="matlab:help inputParser;">inputParser</a> and returns an input structure IN.
%
%   [~, UNMIN] = ML.Input/uplus returns a cell containing the unmatched 
%   inputs.
%
%   See also ML.Input, uplus
%
%   More on <a href="matlab:ML.doc('ML.Input.uplus');">ML.doc</a>

% --- Parsing -------------------------------------------------------------

% Keep unmatched if asked for
if nargout>=2
    this.KeepUnmatched = true;
end

% Parse
this.parse(this.args{:});

% Get input structure
in = this.Results;

% --- Post validation -----------------------------------------------------

F = fieldnames(this.postvalidation);
for i = 1:numel(F)
    
    % --- Get classes and attributes
    
    L = cellfun(@strtrim, strsplit(this.postvalidation.(F{i}), ','), ...
        'UniformOutput', false);
    
    Classes = {};
    Attributes = {};
    
    % Comparison function handle
    comp = @(x, s) numel(x)>=numel(s) && strcmp(x(1:numel(s)),s);
    
    for j = 1:numel(L)
        
        % --- Key / value pairs -------------------------------------------
        % size, numel, ncols, nrows, ndims
        
        tmp = strsplit(L{j}, ':');
        if numel(tmp)==2
            Attributes{end+1} = tmp{1};
            Attributes{end+1} = eval(tmp{2});
            continue
        end
        
        % --- Comparison --------------------------------------------------
        % <, <=, >, >=
        
        if comp(L{j}, '<') || comp(L{j}, '>')
            if strcmp(L{j}(2), '=')
                Attributes{end+1} = L{j}(1:2);
                Attributes{end+1} = eval(L{j}(3:end));
            else
                Attributes{end+1} = L{j}(1);
                Attributes{end+1} = eval(L{j}(2:end));
            end
            continue
        end
        
        % --- Other Matlab attibutes --------------------------------------
        
        if ismember(L{j}, {'2d', '3d', 'column', 'row', 'scalar', ...
                'scalartext', 'vector', 'square', 'diag', 'nonempty', ...
                'nonsparse', 'binary', 'even', 'odd', 'integer', 'real', ...
                'finite', 'nonnan', 'nonnegative', 'nonzero', 'positive', ...
                'decreasing', 'increasing', 'nondecreasing', 'nonincreasing'})
            Attributes{end+1} = L{j};
            continue
        end

        % --- MLab attributes ---------------------------------------------
        
        % TO DO
        %   - color
        
        % --- Classes -----------------------------------------------------
        
        % Classes
        Classes{end+1} = L{j};
        
    end
    
    % --- Validation
    validateattributes(in.(F{i}), Classes, Attributes, this.FunctionName, F{i});

end


% --- Unmatched inputs ----------------------------------------------------

if nargout>=2
    unmin = this.Unmatched;
end

%! ------------------------------------------------------------------------
%! Author: Raphaël Candelier
%! Version: 1.1
%
%! Revisions
%   1.1     (2015/04/01): Created help and improved the support of 
%               KeepUnmatched.
%   1.0     (2015/01/01): Initial version.
%
%! ------------------------------------------------------------------------
%! Doc
%   <title>To do</title>