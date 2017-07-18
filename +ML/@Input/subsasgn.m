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
        
        switch class(B)
            
            case 'logical'
                switch S(1).subs
                    case {'CaseSensitive', 'PartialMatching', 'StructExpand'}
                        this.(S(1).subs) = B;
                    otherwise
                        warning('ML:Input', ['The input parser didn''t recognized the token ' S(1).subs]);
                end
                
            case 'function_handle'
                this.addRequired(S(1).subs, B);
                
            case 'char'
                this.addRequired(S(1).subs, @(x) true);
                this.postvalidation.(S(1).subs) = B;
        end
        
        % --- Optional input
    case 2
        
        switch S(2).type
            
            case '()'
                
                switch class(B)
                    
                    case 'function_handle'
                        if verLessThan('matlab', '8.5.0')
                            this.addParamValue(S(1).subs, S(2).subs{1}, B);
                        else
                            this.addParameter(S(1).subs, S(2).subs{1}, B);
                        end
                        
                    case 'char'
                        if verLessThan('matlab', '8.5.0')
                            this.addParamValue(S(1).subs, S(2).subs{1}, @(x) true);
                        else
                            this.addParameter(S(1).subs, S(2).subs{1}, @(x) true);
                        end
                        this.postvalidation.(S(1).subs) = B;
                end
        
            case '{}'
                
                switch class(B)
                    
                    case 'function_handle'
                        this.addOptional(S(1).subs, S(2).subs{1}, B);
                        
                    case 'char'
                        
                        this.addOptional(S(1).subs, S(2).subs{1}, @(x) true);
                        this.postvalidation.(S(1).subs) = B;
                end
                
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