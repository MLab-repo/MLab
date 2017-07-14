function this = subsasgn(this, S, B)
%ML.Input/subsasgn Assignation overload
%   ML.Input/subsasgn(this, S, B) Assignation overload. This method allows 
%   for the following syntaxes:
%       - this.param = @checkfun            % Required value input (positional)
%       - this.param{default} = @checkfun   % Optional value input (positional)
%       - this.param(default) = @checkfun   % Optional parameter/value input
%
%   See also ML.Input, subsasgn
%
%   More on <a href="matlab:ML.doc('ML.Input.subsasgn');">ML.doc</a>

switch numel(S)
    
    % --- Required input
    case 1

        if ML.isfunction_handle(B)
            this.addRequired(S(1).subs, B);
        else
            switch S(1).subs
                case 'CaseSensitive'
                    this.CaseSensitive = B;
                case 'PartialMatching'
                    this.PartialMatching = B;
                case 'StructExpand'
                    this.StructExpand = B;
            end
        end
        
    % --- Optional input
    case 2
       
    switch S(2).type
    
        case '()'
            
            if verLessThan('matlab', '8.5.0') 
                this.addParamValue(S(1).subs, S(2).subs{1}, B);
            else
                this.addParameter(S(1).subs, S(2).subs{1}, B);
            end
            
        case '{}'
            this.addOptional(S(1).subs, S(2).subs{1}, B);
            
    end
end

%! ------------------------------------------------------------------------
%! Author: Raphaël Candelier
%! Version: 1.1
%
%! Revisions
%   1.1     (2015/04/01): Created help, improved the support of 
%               KeepUnmatched, handled the 'CaseSensitive', 'StructExpand' 
%               and 'PartialMatching' properties and replaced addParamValue 
%               with addParameter for releases >8.5.0.
%   1.0     (2015/01/01): Initial version.
%
%! ------------------------------------------------------------------------
%! Doc
%   <title>To do</title>