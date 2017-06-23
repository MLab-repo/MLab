function [in, unmin] = uplus(this)
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

if nargout>=2
    this.KeepUnmatched = true;
end

% Parse
this.parse(this.args{:});

% Input structure
in = this.Results;

% Unmatched inputs
if nargout>=2
    unmin = getfield([fields(this.Unmatched) struct2cell(this.Unmatched)]', {':'});
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