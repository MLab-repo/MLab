function [B, Fmt] = iscolor(varargin)
%ML.iscolor Color check
%   B = ML.iscolor(Color) Checks if Color is valid. Color can be an array,
%   a string or a cell of vectors and strings. B is a boolean array.
%   Valid formats are:
%   - 'RGB':    n-by-3 numerical array, with values comprised between 0 and
%               1. The class of the array has to be 'double'.
%   - 'RGB_8':  Same as 'RGB', but with intensity ranging from 0 to 255.
%               The array class can be 'double' or 'uint8'.
%   - 'CYMK':   To do.
%   - 'HSV':    To do.
%   - 'cmap':   A n-by-1 numerical array of doubles comprised between 0 and
%               1. The colors are defined with respect to the current
%               colormap, or to a given colormap specified by the
%               'colormap' argument. The class of the array has to be
%               'double'.
%   - 'cmap_8': Same as 'cmap', but with intensity ranging from 0 to 255.
%               The array class can be 'double' or 'uint8'.
%   - 'nm':     A n-by-1 numerical array of doubles representing
%               wavelengths, specified in nanometers.
%   - 'html':   A string containing any of the 140 html colors supported by
%               all browsers. The list extends Matlab's default color long 
%               names and can be obtained with the command 
%               <a href="matlab:ML.color('list_html');">ML.color('list_html')</a>.
%   - 'short':  A string  containing single characters. The list extends 
%               Matlab's default short names and can be obtained with the 
%               command <a href="matlab:ML.color('list_short');">ML.color('list_short')</a>.
%   - 'hex':    A string starting with a '#' and followed by three or six 
%               hexadecimal digits.
%
%   [B, Format] = ML.iscolor(...) also returns the color format in the cell
%   Format. Without other specification it is automatically detected 
%   according to the following rules:
%   - A n-by-1 array of doubles is 'cmap'.
%   - A n-by-1 array of uint8 is 'cmap_8'.
%   - A n-by-3 array of doubles is 'RGB'.
%   - A n-by-3 array of uint8 is 'RGB_8'.
%   - A n-by-4 numerical array is 'CYMK'.
%   - A single character is 'short'.
%   - A string starting with a '#' is 'hex'.
%   - Other strings are 'html'.
%   - A cell of single characters is 'short'.
%   - A cell of strings starting with '#' is 'hex'.
%   - A cell of other strings is 'html'.
%
%   ML.iscolor(..., 'format', FMT) specifies the format to check. With this
%   option, the second output is automatically set to this format. In the
%   case of a multiple-color request, FMT can be either a string or a cell 
%   array of strings with the same number of colors as in the first input.
%
%   ML.iscolor(..., 'colormap', CM) specifies the colormap. With this
%   option, the format is automatically set to cmap (double) or cmap_8
%   (uint8), depending on the class of the first input. Valid colormaps are
%   Matlab's default colormaps ('parula', 'jet', etc.) and the output of
%   the <a href="matlab:help ML.colormap;">ML.colormap</a> function.
%
%   ML.iscolor(..., 'warnings', true) displays warnings whenever the input
%   is not a valid color. The default is false.
%
%   See also ML.color, ML.colormap
%
%   More on <a href="matlab:ML.doc('ML.CW.iscolor');">ML.doc</a>

% --- Inputs
in = ML.Input;
in.Color = @(x) true;
in.format('') = @(x) ischar(x) || iscellstr(x);
in.colormap('') = @ischar; %@ML.iscolormap;
in.warning(false) = @islogical;
in = +in;

% --- Cellification

% Color
if iscell(in.Color)
    in.Color = in.Color(:);
else
    if size(in.Color,1)==1
        in.Color = {in.Color};
    else
        in.Color = mat2cell(in.Color, ones(size(in.Color,1),1), size(in.Color,2));
    end
end

% Format
if ischar(in.format)
    Fmt = repmat({in.format}, size(in.Color));
else
    Fmt = in.format;
end

% --- Check format
if ~all(cellfun(@(x) ischar(x) && ismember(x,{'', 'RGB', 'RGB_8', 'cmap', 'cmap_8', 'CYMK', 'HSV', 'nm', 'html', 'short', 'hex'}), Fmt))
    error('ML:iscolor:WrongFormat', 'The format list could not be parsed.');
end

% --- Prepare lists
H = ML.color('list', 'html');
S = ML.color('list', 'short');

% --- Prepare outputs
B = true(size(in.Color,1),1);

for i = 1:numel(in.Color)
    
    if size(in.Color{i},1)~=1
        B{i} = false;
        continue
    end
    
    switch class(in.Color{i})
        
        case 'double'
            
            switch size(in.Color{i},2)
                
                case 1
                    
                    % Check format
                    if isempty(Fmt{i}) 
                        Fmt{i} = 'cmap';
                    elseif ~ismember(Fmt{i}, {'cmap', 'nm'})
                        if in.warning
                            warning('ML:iscolor:UnmatchedFormat', ['The input is a double scalar and the specified format is ''' Fmt{i} '''.']);
                        end
                        B(i) = false;
                    end
                    
                    % Check values
                    switch Fmt{i}
                        case 'cmap'
                            if in.Color{i}<0
                                if in.warning
                                    warning('ML:iscolor:OutOfRange', ['A ''' Fmt{i} ''' color cannot be negative.']);
                                end
                                B(i) = false;
                            elseif in.Color{i}>1
                                if in.warning
                                    warning('ML:iscolor:OutOfRange', ['A ''' Fmt{i} ''' color cannot be above 1.']);
                                end
                                B(i) = false;
                            end
                        case 'nm'
                            if in.Color{i}<0
                                if in.warning
                                    warning('ML:iscolor:OutOfRange', ['A ''' Fmt{i} ''' color cannot be negative.']);
                                end
                                B(i) = false;
                            end
                    end
                    
                case 3
                   
                    % Check format
                    if isempty(Fmt{i}) 
                        Fmt{i} = 'RGB';
                    elseif ~ismember(Fmt{i}, {'RGB', 'HSV'})
                        if in.warning
                            warning('ML:iscolor:UnmatchedFormat', ['The input is a 3-elements double vector and the specified format is ''' Fmt{i} '''.']);
                        end
                        B(i) = false;
                    end
                    
                    % Check values
                    if any(in.Color{i}<0)
                        if in.warning
                            warning('ML:iscolor:OutOfRange', ['Components of a ''' Fmt{i} ''' color cannot be negative.']);
                        end
                        B(i) = false;
                    elseif any(in.Color{i}>1)
                        if in.warning
                            warning('ML:iscolor:OutOfRange', ['Components of a ''' Fmt{i} ''' color cannot be above 1.']);
                        end
                        B(i) = false;
                    end
                    
                case 4
                    
                    % Check format
                    if isempty(Fmt{i}) 
                        Fmt{i} = 'CYMK';
                    elseif ~strcmp(Fmt{i}, 'CYMK')
                        if in.warning
                            warning('ML:iscolor:UnmatchedFormat', ['The input is a 4-elements double vector and the specified format is ''' Fmt{i} '''.']);
                        end
                        B(i) = false;
                    end
                    
                    % Check values
                    if any(in.Color{i}<0)
                        if in.warning
                            warning('ML:iscolor:OutOfRange', ['Components of a ''' Fmt{i} ''' color cannot be negative.']);
                        end
                        B(i) = false;
                    elseif any(in.Color{i}>1)
                        if in.warning
                            warning('ML:iscolor:OutOfRange', ['Components of a ''' Fmt{i} ''' color cannot be above 1.']);
                        end
                        B(i) = false;
                    end
            end
            
        case 'uint8'
            
            switch size(in.Color{i},2)
                
                case 1
                    
                    % Check format
                    if isempty(Fmt{i}) 
                        Fmt{i} = 'cmap_8';
                    elseif ~strcmp(Fmt{i}, 'cmap_8')
                        if in.warning
                            warning('ML:iscolor:UnmatchedFormat', ['The input is a uint8 scalar and the specified format is ''' Fmt{i} '''.']);
                        end
                        B(i) = false;
                    end
                    
                    % Check values
                    if any(in.Color{i}<0)
                        if in.warning
                            warning('ML:iscolor:OutOfRange', ['A ''' Fmt{i} ''' color cannot be negative.']);
                        end
                        B(i) = false;
                    elseif any(in.Color{i}>255)
                        if in.warning
                            warning('ML:iscolor:OutOfRange', ['A ''' Fmt{i} ''' color cannot be above 255.']);
                        end
                        B(i) = false;
                    end
                    
                case 3
                    
                    % Check format
                    if isempty(Fmt{i}) 
                        Fmt{i} = 'RGB_8';
                    elseif ~strcmp(Fmt{i}, 'RGB_8')
                        if in.warning
                            warning('ML:iscolor:UnmatchedFormat', ['The input is a 3-elements uint8 vector and the specified format is ''' Fmt{i} '''.']);
                        end
                        B(i) = false;
                    end
                    
                case 4
                    
                     % Check format
                    if isempty(Fmt{i}) 
                        Fmt{i} = 'CYMK_8';
                    elseif ~strcmp(Fmt{i}, 'CYMK_8')
                        if in.warning
                            warning('ML:iscolor:UnmatchedFormat', ['The input is a 4-elements uint8 vector and the specified format is ''' Fmt{i} '''.']);
                        end
                        B(i) = false;
                    end
                    
                    % Check values
                    if any(in.Color{i}<0)
                        if in.warning
                            warning('ML:iscolor:OutOfRange', ['Components of a ''' Fmt{i} ''' color cannot be negative.']);
                        end
                        B(i) = false;
                    elseif any(in.Color{i}>255)
                        if in.warning
                            warning('ML:iscolor:OutOfRange', ['Components of a ''' Fmt{i} ''' color cannot be above 255.']);
                        end
                        B(i) = false;
                    end
            end
            
        case 'char'
            
            if numel(in.Color{i})==1
                
                % Check format
                if isempty(Fmt{i})
                    Fmt{i} = 'short';
                elseif ~strcmp(Fmt{i}, 'short')
                    if in.warning
                        warning('ML:iscolor:UnmatchedFormat', ['The input is a single char and the specified format is ''' Fmt{i} '''.']);
                    end
                    B(i) = false;
                end
                
                % Check values
                if ~ismember(in.Color{i}, S(:,1))
                    if in.warning
                        warning('ML:iscolor:UnmatchedShort', 'The input is not a valid short color');
                    end
                    B(i) = false;
                end
                
            elseif strcmp(in.Color{i}(1), '#')
                
                % Check format
                if isempty(Fmt{i})
                    Fmt{i} = 'hex';
                elseif ~strcmp(Fmt{i}, 'hex')
                    if in.warning
                        warning('ML:iscolor:UnmatchedFormat', ['The input is an hexadecimal string and the specified format is ''' Fmt{i} '''.']);
                    end
                    B(i) = false;
                end
                
                % Check values
                h = in.Color{i}(2:end);
                switch numel(h)
                    case {3,6}
                        try
                            hex2dec(h);
                        catch
                            if in.warning
                                warning('ML:iscolor:WrongHex', 'The input is not a valid hexadecimal string');
                            end
                            B(i) = false;
                        end
                    otherwise
                        if in.warning
                            warning('ML:iscolor:WrongHex', ['The input string has a wrong number of characters (' num2str(numel(h)) ')']);
                        end
                        B(i) = false;
                end
                                       
            else
                
                % Check format
                if isempty(Fmt{i})
                    Fmt{i} = 'html';
                elseif ~strcmp(Fmt{i}, 'html')
                    if in.warning
                        warning('ML:iscolor:UnmatchedFormat', ['The input is a string and the specified format is ''' Fmt{i} '''.']);
                    end
                    B(i) = false;
                end
                
                % Check values
                if ~ismember(in.Color{i}, H(:,1))
                    if in.warning
                        warning('ML:iscolor:UnmatchedHtml', 'The input is not a valid html color');
                    end
                    B(i) = false;
                end
                
            end
            
    end
end

%! ------------------------------------------------------------------------
%! Author: Raphaël Candelier
%! Version: 1.1
%
%! Revisions
%   1.1     (2015/05/07): Full implementation.
%   1.0     (2015/05/06): Initial version.
%
%! To do
%   Make lists persistent (to improve speed ?)
%! ------------------------------------------------------------------------
%! Doc
%   <title>To do</title>