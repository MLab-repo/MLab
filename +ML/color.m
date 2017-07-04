function Out = color(varargin)
%ML.color Color conversion
%   RGB = ML.color(Color) converts valid MLab Color in a RGB triplet. If 
%   Color is a single value (scalar, triplet, quadruplet or string), the
%   output is a 1-by-3 triplet. If Color is a n-by-1/3/4 array or a 
%   cell of n valid colors, the output is a n-by-3 array. Depending on the 
%   class and size of Color, the default input formats are:
%   - double scalar: 'cmap'
%   - uint8 scalar: 'cmap_8'
%   - 1-by-3 double array: 'RGB'
%   - 1-by-3 uint8 array: 'RGB_8'
%   - 1-by-4 double array: 'CYMK'
%   - 1-by-4 uint8 array: 'CYMK_8'
%   - single character: 'short'
%   - string starting with a '#': 'hex'
%   - other strings: 'html'
%
%   RGB = ML.color(Color, Format) specifies the input format. 
%   Supported formats are:
%   - 'RGB':    1-by-3 vector of doubles, with all components laying in the 
%               range [0,1].
%   - 'RGB_8':  1-by-3 vector of uint8. The components thus lay in the 
%               range [0 255].
%   - 'CYMK':   To do.
%   - 'HSV':    To do.
%   - 'cmap':   A double scalar, comprised between 0 and 1.
%   - 'cmap_8': A uint8 scalar.
%   - 'nm':     A double scalar indicating a wavelength in nanometers.
%   - 'html':   A string matching any of the 140 html colors supported by 
%               all browsers. The list extends Matlab's default color long 
%               names and can be obtained with the command <a href="matlab:ML.color('list','html');">ML.color('list','html')</a>.
%   - 'short':  A string matching a color shortname. The list extends 
%               Matlab's default short names and can be obtained with the 
%               command <a href="matlab:ML.color('list','short');">ML.color('list','short')</a>.
%   - 'hex':    A string starting with a '#' and followed by three or six 
%               hexadecimal digits.
%
%   OUT = ML.color(..., 'to', OutputFormat) returns colors converted in the
%   format specified by OutputFormat instead of the default output format
%   ('RGB'). Note that only the 'RGB', 'HSV' and 'CYMK' formats ensure a
%   lossless conversion. For all the other formats, some information may be
%   lost during the conversion, and the output color is choosen as the 
%   closest color on the basis of the Euclidian distance between the RGB
%   components (minimization of the root mean square difference).
%
%   ML.color(..., 'warning', true) emits warnings whenever a color or a 
%   format is not valid.
%
%   ML.color('list', LIST) displays a list of possible colors. LIST can be
%   'html' (html names) or 'short' (short names).
%
%   L = ML.color('list', LIST) returns the list in a n-by-2 cell array 
%   without display. The first color contains the html or short names and 
%   the second column the RGB colors. 
%
%   See also ML.iscolor, ML.colormap, ML.CW.print
%
%   More on <a href="matlab:ML.doc('ML.CW.color');">ML.doc</a>

% --- Inputs --------------------------------------------------------------

if numel(varargin) && ischar(varargin{1}) && strcmp(varargin{1}, 'list')
    mode = 'list';
    in = ML.Input(varargin{2:end});
    in.list = @(x) ismember(x, {'html', 'short'});
else
    mode = 'conversion';
    in = ML.Input;
    in.Color = @(x) true;
    if nargin>2 && ismember(varargin{2},{'to'})
        in.format('') = @(x) ischar(x) || iscellstr(x);
    else
        in.format{''} = @(x) ischar(x) || iscellstr(x);
    end
    in.to('RGB') = @(x) ischar(x) || iscellstr(x);
    in.warning(false) = @islogical;
end
in = +in;

% --- Definitions ---------------------------------------------------------

HTML = {'lightsalmon', [255 160 122]/255 ; ...
    'salmon', [250 128 114]/255 ; ...
    'darksalmon', [233 150 122]/255 ; ...
    'lightcoral', [240 128 128]/255 ; ...
    'indianred', [205 92 92]/255 ; ...
    'crimson', [220 20 60]/255 ; ...
    'firebrick', [178 34 34]/255 ; ...
    'red', [255 0 0]/255 ; ...
    'darkred', [139 0 0]/255 ; ...
    'coral', [255 127 80]/255 ; ...
    'tomato', [255 99 71]/255 ; ...
    'orangered', [255 69 0]/255 ; ...
    'gold', [255 215 0]/255 ; ...
    'orange', [255 165 0]/255 ; ...
    'darkorange', [255 140 0]/255 ; ...
    'lightyellow', [255 255 224]/255 ; ...
    'lemonchiffon', [255 250 205]/255 ; ...
    'lightgoldenrodyellow', [250 250 210]/255 ; ...
    'papayawhip', [255 239 213]/255 ; ...
    'moccasin', [255 228 181]/255 ; ...
    'peachpuff', [255 218 185]/255 ; ...
    'palegoldenrod', [238 232 170]/255 ; ...
    'khaki', [240 230 140]/255 ; ...
    'darkkhaki', [189 183 107]/255 ; ...
    'yellow', [255 255 0]/255 ; ...
    'lawngreen', [124 252 0]/255 ; ...
    'chartreuse', [127 255 0]/255 ; ...
    'limegreen', [50 205 50]/255 ; ...
    'lime', [0 255 0]/255 ; ...
    'forestgreen', [34 139 34]/255 ; ...
    'green', [0 128 0]/255 ; ...
    'darkgreen', [0 100 0]/255 ; ...
    'greenyellow', [173 255 47]/255 ; ...
    'yellowgreen', [154 205 50]/255 ; ...
    'springgreen', [0 255 127]/255 ; ...
    'mediumspringgreen', [0 250 154]/255 ; ...
    'lightgreen', [144 238 144]/255 ; ...
    'palegreen', [152 251 152]/255 ; ...
    'darkseagreen', [143 188 143]/255 ; ...
    'mediumseagreen', [60 179 113]/255 ; ...
    'seagreen', [46 139 87]/255 ; ...
    'olive', [128 128 0]/255 ; ...
    'darkolivegreen', [85 107 47]/255 ; ...
    'olivedrab', [107 142 35]/255 ; ...
    'lightcyan', [224 255 255]/255 ; ...
    'cyan', [0 255 255]/255 ; ...
    'aqua', [0 255 255]/255 ; ...
    'aquamarine', [127 255 212]/255 ; ...
    'mediumaquamarine', [102 205 170]/255 ; ...
    'paleturquoise', [175 238 238]/255 ; ...
    'turquoise', [64 224 208]/255 ; ...
    'mediumturquoise', [72 209 204]/255 ; ...
    'darkturquoise', [0 206 209]/255 ; ...
    'lightseagreen', [32 178 170]/255 ; ...
    'cadetblue', [95 158 160]/255 ; ...
    'darkcyan', [0 139 139]/255 ; ...
    'teal', [0 128 128]/255 ; ...
    'powderblue', [176 224 230]/255 ; ...
    'lightblue', [173 216 230]/255 ; ...
    'lightskyblue', [135 206 250]/255 ; ...
    'skyblue', [135 206 235]/255 ; ...
    'deepskyblue', [0 191 255]/255 ; ...
    'lightsteelblue', [176 196 222]/255 ; ...
    'dodgerblue', [30 144 255]/255 ; ...
    'cornflowerblue', [100 149 237]/255 ; ...
    'steelblue', [70 130 180]/255 ; ...
    'royalblue', [65 105 225]/255 ; ...
    'blue', [0 0 255]/255 ; ...
    'mediumblue', [0 0 205]/255 ; ...
    'darkblue', [0 0 139]/255 ; ...
    'navy', [0 0 128]/255 ; ...
    'midnightblue', [25 25 112]/255 ; ...
    'mediumslateblue', [123 104 238]/255 ; ...
    'slateblue', [106 90 205]/255 ; ...
    'darkslateblue', [72 61 139]/255 ; ...
    'lavender', [230 230 250]/255 ; ...
    'thistle', [216 191 216]/255 ; ...
    'plum', [221 160 221]/255 ; ...
    'violet', [238 130 238]/255 ; ...
    'orchid', [218 112 214]/255 ; ...
    'fuchsia', [255 0 255]/255 ; ...
    'magenta', [255 0 255]/255 ; ...
    'mediumorchid', [186 85 211]/255 ; ...
    'mediumpurple', [147 112 219]/255 ; ...
    'blueviolet', [138 43 226]/255 ; ...
    'darkviolet', [148 0 211]/255 ; ...
    'darkorchid', [153 50 204]/255 ; ...
    'darkmagenta', [139 0 139]/255 ; ...
    'purple', [128 0 128]/255 ; ...
    'indigo', [75 0 130]/255 ; ...
    'pink', [255 192 203]/255 ; ...
    'lightpink', [255 182 193]/255 ; ...
    'hotpink', [255 105 180]/255 ; ...
    'deeppink', [255 20 147]/255 ; ...
    'palevioletred', [219 112 147]/255 ; ...
    'mediumvioletred', [199 21 133]/255 ; ...
    'white', [255 255 255]/255 ; ...
    'snow', [255 250 250]/255 ; ...
    'honeydew', [240 255 240]/255 ; ...
    'mintcream', [245 255 250]/255 ; ...
    'azure', [240 255 255]/255 ; ...
    'aliceblue', [240 248 255]/255 ; ...
    'ghostwhite', [248 248 255]/255 ; ...
    'whitesmoke', [245 245 245]/255 ; ...
    'seashell', [255 245 238]/255 ; ...
    'beige', [245 245 220]/255 ; ...
    'oldlace', [253 245 230]/255 ; ...
    'floralwhite', [255 250 240]/255 ; ...
    'ivory', [255 255 240]/255 ; ...
    'antiquewhite', [250 235 215]/255 ; ...
    'linen', [250 240 230]/255 ; ...
    'lavenderblush', [255 240 245]/255 ; ...
    'mistyrose', [255 228 225]/255 ; ...
    'gainsboro', [220 220 220]/255 ; ...
    'lightgray', [211 211 211]/255 ; ...
    'silver', [192 192 192]/255 ; ...
    'darkgray', [169 169 169]/255 ; ...
    'gray', [128 128 128]/255 ; ...
    'dimgray', [105 105 105]/255 ; ...
    'lightslategray', [119 136 153]/255 ; ...
    'slategray', [112 128 144]/255 ; ...
    'darkslategray', [47 79 79]/255 ; ...
    'black', [0 0 0]/255 ; ...
    'cornsilk', [255 248 220]/255 ; ...
    'blanchedalmond', [255 235 205]/255 ; ...
    'bisque', [255 228 196]/255 ; ...
    'navajowhite', [255 222 173]/255 ; ...
    'wheat', [245 222 179]/255 ; ...
    'burlywood', [222 184 135]/255 ; ...
    'tan', [210 180 140]/255 ; ...
    'rosybrown', [188 143 143]/255 ; ...
    'sandybrown', [244 164 96]/255 ; ...
    'goldenrod', [218 165 32]/255 ; ...
    'darkgoldenrod', [184 134 11]/255 ; ...
    'peru', [205 133 63]/255 ; ...
    'chocolate', [210 105 30]/255 ; ...
    'saddlebrown', [139 69 19]/255 ; ...
    'sienna', [160 82 45]/255 ; ...
    'brown', [165 42 42]/255 ; ...
    'maroon', [128 0 0]/255};

SHORT = {'a', [240 255 255]/255 ; ... % Azure
    'b', [0 0 255]/255 ; ...        % Blue
    'c', [0 255 255]/255 ; ...      % Cyan
    'd', []/255 ; ...
    'e', []/255 ; ...
    'f', []/255 ; ...
    'g', [0,255,0]/255 ; ...        % Lime
    'h', []/255 ; ...
    'i', []/255 ; ...
    'j', []/255 ; ...
    'k', [0 0 0]/255 ; ...          % Black
    'l', []/255 ; ...
    'm', [255 0 255]/255 ; ...      % Magenta
    'n', [0 0 128]/255 ; ...        % Navy
    'o', [255 165 0]/255 ; ...      % Orange
    'p', [128 0 128]/255 ; ...      % Purple
    'q', []/255 ; ...
    'r', [255 0 0]/255 ; ...        % Red
    's', [250 128 114]/255 ; ...    % Salmon
    't', []/255 ; ...
    'u', []/255 ; ...
    'v', []/255 ; ...
    'w', [255 255 255]/255 ; ...    % White
    'x', []/255 ; ...
    'y', [255 255 0]/255 ; ...      % Yellow
    'z', []/255 ; ...
    'A', []/255 ; ...
    'B', []/255 ; ...
    'C', []/255 ; ...
    'D', []/255 ; ...
    'E', []/255 ; ...
    'F', []/255 ; ...
    'G', [0 128 0]/255 ; ...        % Green
    'H', []/255 ; ...
    'I', []/255 ; ...
    'J', []/255 ; ...
    'K', []/255 ; ...
    'L', []/255 ; ...
    'M', [128 0 0]/255 ; ...        % Maroon
    'N', []/255 ; ...
    'O', []/255 ; ...
    'P', [255 192 203]/255 ; ...    % Pink
    'Q', []/255 ; ...
    'R', []/255 ; ...
    'S', []/255 ; ...
    'T', []/255 ; ...
    'U', []/255 ; ...
    'V', []/255 ; ...
    'W', []/255 ; ...
    'X', []/255 ; ...
    'Y', []/255 ; ...
    'Z', []/255};

SHORT = SHORT(~cellfun(@isempty,SHORT(:,2)),:);

% -------------------------------------------------------------------------
switch mode
    
    case 'list'
        
        switch in.list
            
            case 'html'
                if nargout
                    Out = HTML;
                else
                    T = cell(0,3);
                    for i = 1:size(HTML,1)
                        T{i,1} = HTML{i,1};
                        T{i,2} = ['~c[' num2str(HTML{i,2}*255) ']{#}'];
                        tfun = @(x) [repmat(' ', [1,3-numel(x)]) x];
                        T{i,3} = [tfun(num2str(HTML{i,2}(1)*255)) ' ' ...
                            tfun(num2str(HTML{i,2}(2)*255)) ' ' ...
                            tfun(num2str(HTML{i,2}(3)*255))];
                        
                    end
                    ML.Text.table(T, 'style', 'compact');
                    
                end
                
            case 'short'
                if nargout
                    Out = SHORT;
                else
                    
                    T = cell(0,3);
                    for i = 1:size(SHORT,1)
                        T{i,1} = SHORT{i,1};
                        T{i,2} = ['~c[' num2str(SHORT{i,2}*255) ']{#}'];
                        tfun = @(x) [repmat(' ', [1,3-numel(x)]) x];
                        T{i,3} = [tfun(num2str(SHORT{i,2}(1)*255)) ' ' ...
                            tfun(num2str(SHORT{i,2}(2)*255)) ' ' ...
                            tfun(num2str(SHORT{i,2}(3)*255))];
                        
                    end
                    ML.Text.table(T, 'style', 'compact');
                    
                end
        end
        
    case 'conversion'
        
        % --- Cellification
        if ~iscell(in.Color)
            MakeOutputArray = 1;
            if size(in.Color,1)==1
                in.Color = {in.Color};
            else
                in.Color = mat2cell(in.Color, ones(size(in.Color,1),1), size(in.Color,2));
            end
        else
            MakeOutputArray = 0;
        end
        
        % --- Check colors
        [B, Fmt] = ML.iscolor(in.Color, 'format', in.format, 'Warning', in.warning);
        I = find(B);
        
        % --- Check output format
        if ischar(in.to)
            OutFmt = repmat({in.to}, size(in.Color));
        else
            OutFmt = in.to;
        end

        if ~all(cellfun(@(x) ischar(x) && ismember(x,{'RGB', 'RGB_8', 'cmap', 'cmap_8', 'CYMK', 'HSV', 'nm', 'html', 'short', 'hex'}), OutFmt))
            error('ML:color:WrongFormat', 'The output format list could not be parsed.');
        end
        
        % --- Conversion
        Out = cell(size(in.Color));
        for i = 1:numel(I)
            
            if strcmp(Fmt{I(i)}, OutFmt{I(i)})
                Out{I(i)} = in.Color{I(i)};
            else
            
                fname = [Fmt{I(i)} '2' OutFmt{I(i)}];
                if exist(fname, 'file')
                    f = str2func(fname);
                    Out{I(i)} = f(in.Color{I(i)});
                else
                    f2RGB = str2func([Fmt{I(i)} '2RGB']);
                    RGB2f = str2func(['RGB2' OutFmt{I(i)}]);
                    Out{I(i)} = RGB2f(f2RGB(in.Color{I(i)}));
                end
                
            end
            
        end
        
        if MakeOutputArray
            Out = cell2mat(Out);
        end
end

end

% -------------------------------------------------------------------------
function out = cmap2RGB(in)
    
end

% -------------------------------------------------------------------------
function out = cmap_82RGB(in)
    
end

% -------------------------------------------------------------------------
function out = RGB_82RGB(in)
    out = double(in)/255;
end

% -------------------------------------------------------------------------
function out = HSV2RGB(in)
    out = hsv2rgb(in);
end

% -------------------------------------------------------------------------
function out = CYMK2RGB(in)
    
end

% -------------------------------------------------------------------------
function out = nm2RGB(in)
    
end

% -------------------------------------------------------------------------
function out = short2RGB(in)

    L = ML.color('list', 'short');
    [~,I] = ismember(in, L(:,1));
    out = L{I,2};
    
end

% -------------------------------------------------------------------------
function out = hex2RGB(in)
    
end

% -------------------------------------------------------------------------
function out = html2RGB(in)
    L = ML.color('list', 'html');
    [~,I] = ismember(in, L(:,1));
    out = L{I,2};
end

% -------------------------------------------------------------------------
function out = RGB2RGB_8(in)
    out = uint8(in*255);
end

% -------------------------------------------------------------------------
function out = RGB2HSV(in)
    out = rgb2hsv(in);
end

%! ------------------------------------------------------------------------
%! Author: Raphaël Candelier
%! Version: 1.0
%
%! Revisions
%   1.0     (2015/05/06): Initial version.
%
%! To do
%   Make lists persistent (to improve speed ?)
%! ------------------------------------------------------------------------
%! Doc
%   <title>To do</title>