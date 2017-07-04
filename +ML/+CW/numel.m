function out = numel(varargin)
%ML.CW.numel Number of characters in command window
%   OUT = ML.CW.numel returns the number of characters currently displayed
%   in the command window.
%
%   N = ML.CW.numel(formatSpec, A1,..., An) returns the number of
%   characters as it should be displayed by the <a href="matlab:ML.doc('ML.CW.print');">ML.CW.print</a>
%   function, excluding the formatting tags (html or MLtag).
%
%   See also ML.CW.print
%
%   More on <a href="matlab:ML.doc('ML.CW.numel');">ML.doc</a>

if ~nargin
    
    % Get a handle to the Command Window component
    mde = com.mathworks.mde.desk.MLDesktop.getInstance;
    cw = mde.getClient('Command Window');
    xCmdWndView = cw.getComponent(0).getViewport.getComponent(0);
    
    % Force command window repaint
    xCmdWndView.repaint;
    pause(0.01);
    
    % Get command window length
    cmdWinDoc = com.mathworks.mde.cmdwin.CmdWinDocument.getInstance;
    out = cmdWinDoc.getLength;
    
else
    
    % --- Inputs
    in = ML.Input;
    in.s = @ischar;
    [in, unmin] = +in;
        
    % --- Outputs
    txt = sprintf(in.s, unmin{:});
    txt = regexprep(txt, '\033\[[0-9;]*m', '');
    txt = regexprep(txt, '</?([^>]*)>', '');
    txt = regexprep(txt, '~b?u?(c\[[^\]]*\])?{([^}]*)}', '$2');
    out = numel(txt);
    
end

%! ------------------------------------------------------------------------
%! Author: Raphaël Candelier
%! Version: 1.2
%
%! Revisions
%   1.2     (2015/05/06): Added the support of strings defined by
%               formatSpec and updated the help.
%   1.1     (2015/04/02): Created help.
%   1.0     (2015/01/01): Initial version.
%
%! ------------------------------------------------------------------------
%! Doc
%   <title>To do</title>