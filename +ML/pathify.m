function out = pathify(varargin)
% ML.pathify String "pathification" (adding terminal file separator)
%   OUT = ML.pathify(IN) checks that the path in string IN has a terminal
%   file separator and otherwise adds it.
%
%   OUT = ML.pathify(IN) where IN is a cell array of strings, applies the
%   pathification algorithm to all elements of CIN individually and returns
%   a cell array of pathified strings.
%
%   ML.pathify(IN) makes in-place pathification. The following syntaxes are
%   thus equivalent:
%
%   >> in = ML.pathify(in);
%   >> ML.pathify(in);
%
%   See also cat, filesep
%
%   More on ...

% --- In-place pathification
if ~nargout
    
    v = inputname(1);
    if isempty(v)
        error('In-place pathification requires that the input is a variable.');
    end
    
    evalin('caller', [v ' = ML.pathify(' v ');']);
    return
end

% --- Check input
in = ML.Input;
in.path = @(x) ischar(x) || iscellstr(x);
in = in.process;

% --- Check terminal file separator
switch class(in.path)
    
    case 'char'
        
        if in.path(end)~=filesep
            out = [in.path filesep];
        end
        
    case 'cell'

        out = cell(numel(in.path),1);
        for i = 1:numel(in.path)
            if in.path{i}(end)~=filesep
                out{i} = [in.path{i} filesep];
            end
        end
        
end

