function [C,line] = whocalled(N)
%ML.Files.whocalled Name of the calling script/function
%   C = ML.Files.whocalled(N) returns the name of the calling script or 
%   function, at the level N. The default level is N=1, the output being 
%   the first parent of the current m-file. If the function is called from
%   the command line, an empty string is returned.
%
%   Note: ML.Files.whocalled(0) returns the name of the current running 
%   program, and is thus similar to mfilename.
%
%   [C, LINE] = ML.Files.whocalled(N) also returns the line number at which
%   the call is performed.
%
%   See also dbstack, mfilename
%
%   More on <a href="matlab:ML.doc('ML.Files.whocalled');">ML.doc</a>

% Default value
if ~nargin, N = 1; end
    
N = N+2;
[ST,I] = dbstack('-completenames');
if N>numel(ST)
    if N==3
        C = '';
        line = NaN;
        return
    else
        warning('ML:Files:whocalled:OutOfRange', ['N is too high. Max: ' num2str(numel(ST)-2) '.']);
    end
end

C = ST(N).file;
line = ST(N).line;

%! ------------------------------------------------------------------------
%! Author: Raphaël Candelier
%! Version: 1.1
%
%! Revisions
%   1.1     (2015/04/19): Created help.
%   1.0     (2010/01/01): Initial version.
%
%! To_do
%   Write ML.doc.
%! ------------------------------------------------------------------------
%! Doc
%   <title>To do</title>