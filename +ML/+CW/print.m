function print(varargin)
%ML.CW.print Command window print
%   ML.CW.PRINT(formatSpec, A1,..., An) formats data and displays the
%   result in the command window. formatSpec is a string containing
%   formatting operators (see fprintf) and MLtags. A1, ... An can be
%   strings or numerical values.
%
%   ML.CW.PRINT(formatSpec, Opt, A1,..., An) where Opt is a structure array
%   applies options to the whole string. Opt fields are:
%   - 'color': a RGB triplet or any color format accepted by ML.color.
%   - 'bold': a boolean.
%   - 'underline': a boolean.
%
%   --- Notes
%
%   Due to Matlab limitations, it is not possible to have text which is
%   both bolded and underlined. If both options are set to true, the
%   'underline' options will be automatically set to false and a warning
%   will be generated.
%
%   It is generally a bad pracice to use underlined colored text, since it
%   ressembles hyperlinks.
%
%   Custom-colored hyperlinks are possible, but they have to be underlined 
%   and cannot be boldfaced.
%
%   --- MLTags syntax
%
%   MLTags are composed of a '~', one or two letters, a color array (in
%   square brackets, optional) and a text (in curly braces). Letter options
%   are:
%   - 'b': for bold text
%   - 'u': for underlined text
%   - 'c': for colored text. If 'c' is present a color have to be
%   specified in square brackets, in a format accepted by ML.color.
%
%   --- Exemples
%
%   ML.CW.print('Exemple 1\n', struct('color', 'm', 'bold', true));
%   ML.CW.print('~b{Bold} is the new chic.\n');
%   ML.CW.print('This is ~u{really} important.\n');
%   ML.CW.print('The quick ~c[pink]{brown} fox jumps over the lazy dog.\n');
%   ML.CW.print('The quick ~uc[139 69 19]{brown} fox jumps over the lazy dog.\n');
%
%   See also fprintf, ML.CW.numel
%
%   More on <a href="matlab:ML.doc('ML.CW.print');">ML.doc</a>

%! TO DO
%   - Check the * in "Hyperlinks colored with a custom color are possible,
%   but they have to be underlined *"

% --- Inputs --------------------------------------------------------------

% --- Options
if nargin>=2 && isstruct(varargin{2})
    options = varargin{2};
    varargin(2) = [];
else
    options = false;
end

% --- Checks --------------------------------------------------------------

% --- Deployed mode
if isdeployed
    
    % TO DO: Remove tags
    
    fprintf(varargin{1}, varargin{2:end});
    return;
    
end

% --- Text processing -----------------------------------------------------

str = sprintf(varargin{1}, varargin{2:end});

% --- Display
if isstruct(options)
    
    if ~isfield(options, 'color'), options.color = 'k'; end
    if ~isfield(options, 'bold'), options.bold = false; end
    if ~isfield(options, 'underline'), options.underline = false; end
    
    cprintf(str, ...
        'color', options.color, ...
        'bold', options.bold, ...
        'underline', options.underline);
    
else
    
    % --- Parse text
    [start, stop, tokens] = regexp(str, '\~(b?)(u?)((c\[[^\]]*\])?)\{([^\}])*\}', ...
        'start', 'end', 'tokens');
    
    if isempty(start)
        fprintf(str);
    else
        pos = 1;
        for i = 1:numel(start)
            fprintf(str(pos:start(i)-1));
            
            opt = struct('color', 'k', 'bold', false, 'underline', false);
            if ~isempty(tokens{i}{1}), opt.bold = true; end
            if ~isempty(tokens{i}{2}), opt.underline = true; end
            if ~isempty(tokens{i}{3}), opt.color = tokens{i}{3}(3:end-1); end
            
            if isempty(regexp(opt.color, '[a-zA-Z]', 'once'))
                tmp = str2num(opt.color);
                if ~isempty(tmp)
                    if any(tmp>1)
                        opt.color = uint8(tmp);
                    else
                        opt.color = tmp;
                    end
                end
            end
            cprintf(tokens{i}{4}, opt);
            pos = stop(i)+1;
        end
        fprintf(str(pos:end));
        
    end
end


% =========================================================================
function cprintf(str,varargin)
% Manages low-level aspects of colored/bold/underline display.
% This function has been inspired by the "cprintf" function proposed by
% Yair Altman (http://www.mathworks.com/matlabcentral/fileexchange/24093).

% --- Inputs --------------------------------------------------------------
in = ML.Input;
in.color('k') = @ML.iscolor;
in.bold(false) = @islogical;
in.underline(false) = @islogical;
in = +in;

if ML.isdesktop
    
    % --- Checks --------------------------------------------------------------
    
    % Bold and underline
    if in.bold && in.underline
        warning('MLab:cprintf:BoldAndUnderline', 'Matlab cannot represent text that is bolded and underlined. The bold option is set to false.');
        in.bold = false;
    end
    
    % --- Print text ----------------------------------------------------------
    
    % --- Prepare color
    
    % Convert to RGB_8
    in.color = ML.color(in.color, 'to', 'RGB_8');
    
    % Define java color
    style = sprintf('[%d,%d,%d]', in.color);
    com.mathworks.services.Prefs.setColorPref(style, java.awt.Color(in.color(1), in.color(2), in.color(3)));
    
    % --- Manage CW output
    
    % Get the current CW position
    cmdWinDoc = com.mathworks.mde.cmdwin.CmdWinDocument.getInstance;
    lastPos = cmdWinDoc.getLength;
    
    % Get a handle to the Command Window component
    mde = com.mathworks.mde.desk.MLDesktop.getInstance;
    cw = mde.getClient('Command Window');
    xCmdWndView = cw.getComponent(0).getViewport.getComponent(0);
    
    % Store the CW background color as a special color pref
    com.mathworks.services.Prefs.setColorPref('CW_BG_Color',xCmdWndView.getBackground);
    
    % Display the text in the Command Window
    if in.bold, str = ['<strong>' str '</strong>']; end
    if in.underline, str = ['<a href="">' str '</a>']; end
    
    fprintf(2, [str ' ']);
    
    drawnow;
    docElement = cmdWinDoc.getParagraphElement(lastPos+1);
    
    % Get the Document Element(s) corresponding to the latest fprintf operation
    while docElement.getStartOffset < cmdWinDoc.getLength
        
        tokens = docElement.getAttribute('SyntaxTokens');
        if numel(tokens)>=2
            styles = tokens(2);
            styles(end-1) = java.lang.String(style);
            %         styles(end) = java.lang.String(style);
        end
        
        % Make empty URLs un-hyperlinkable
        urls = docElement.getAttribute('HtmlLink');
        if ~isempty(urls)
            urlTargets = urls(2);
            for urlIdx = 1 : length(urlTargets)
                if isa(urlTargets(urlIdx), 'java.lang.String') && urlTargets(urlIdx).length<1
                    urlTargets(urlIdx) = [];
                end
            end
        end
        
        tmp = cmdWinDoc.getParagraphElement(docElement.getEndOffset+1);
        if isequal(docElement,tmp)
            break
        else
            docElement = tmp;
        end
    end
    
    if ~in.bold && ~in.underline
        fprintf(char(8));
    end
    
    % Force Command-Window repaint
    xCmdWndView.repaint;
    
    if in.bold || in.underline
        fprintf(char(8));
    end
    
else
    
    % --- Prepare appearence
    s = '';
    if in.bold, s = [s '1;']; end
    if in.underline, s = [s '4;']; end
    
    % --- Prepare color
    C = {[0 0 0] '30' ; ...
         [1 0 0] '31' ; ...
         [0 1 0] '32' ; ...
         [1 1 0] '33' ; ...
         [0 0 1] '34' ; ...
         [1 0 1] '35' ; ...
         [0 1 1] '36' ; ...
         [1 1 1] '37'};
    
    [~, I] = min(sum((ones(size(C,1),1)*ML.color(in.color) - reshape([C{:,1}], [3 size(C,1)])').^2,2));
    s = [s C{I,2}];
    
    % --- Display
    fprintf('\033[%sm%s\033[0m', s, str);
end