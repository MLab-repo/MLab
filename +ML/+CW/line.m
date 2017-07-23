function out = line(varargin)
%ML.CW.line Line display
%   ML.CW.line() prints a horizontal line filling the command window.
%
%   ML.CW.line(TXT) prints a horizontal line with the string TXT.
%
%   ML.CW.line(..., 'marker', M) uses the character M to fill the
%   line. The marker has to be a single character string.
%
%   Tip: Use char(9473) to make a bold line.
%
%   ML.CW.line(..., 'length', LEN) specifies the total number of
%   characters to display in the line. The default behavior is to fill the
%   command window horizontally.
%
%   ML.CW.line(..., 'align', 'right') aligns the text on the right side.
%   The default alignment is on the left side.
%
%   OUT = ML.CW.line(...) returns the line without printing it.
%
%   See also fprintf, disp
%
%   More on <a href="matlab:ML.doc('ML.CW.line');">ML.doc</a>

% --- Inputs

in = ML.Input;
in.str{''} = @ischar;
in.marker(char(9472)) = @(s) ischar(s) && numel(s)==1;
in.length(NaN) = @isnumeric;
in.align('left') = @ischar;
in = +in;

% --- Get default length
if isnan(in.length)
    tmp = get(0,'CommandWindowSize');
    in.length = tmp(1);
end

% --- Compute the line

% Initialization
txt = '';

switch in.align
    
    case 'right'
        
        % Add text
        if ~isempty(in.str)
            txt = [' ' in.str ' ' in.marker in.marker];
        end
        
        % Finish line
        N = ML.CW.numel(txt);
        txt = [repmat(in.marker, [1,in.length-N-1]) txt char(10)];
        
    otherwise
        
        % Add text
        if ~isempty(in.str)
            txt = [in.marker in.marker ' ' in.str ' '];
        end
        
        % Finish line
        N = ML.CW.numel(txt);
        txt = [txt repmat(in.marker, [1,in.length-N-1]) char(10)];
        
end

% --- Output
if nargout
    out = txt;
else
    ML.CW.print(txt);
end

% === DOCUMENTATION =======================================================

%! Short: Horizontal line/title in the command-line window
%! Inputs
%! Outputs
%! Description:
%   ML.CW.line
%   ML.CW.line(text)
%   ML.CW.line(..., 'marker', m)
%   ML.CW.line(..., 'length', length)
%   ML.CW.line(..., 'align', side)
%!  Examples
%! Tips
%! See also
