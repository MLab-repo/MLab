classdef Input < inputParser
%ML.Input Input manager
%   This class simplifies the syntax of the built-in <a href="matlab:doc inputParser;">inputParser</a>, from which
%   it inherits.
%
%   --- Syntax
%
%   ML.Input reates an Input manager object. The varargin cell of the
%   calling function is automatically fetched and feeded as an input to the
%   constructor.
%
%   ML.Input(IN) specifies the inputs. IN can be either a varargin-like 
%   cell of inputs or a structure.
%
%   --- Usage
%
%   Here is a sample usage:
%       function out = myfun(varargin)
%       in = ML.Input;
%       in.param_1      = @islogical;   % addRequired input
%       in.param_2(NaN) = @isnumeric;   % addParameter input
%       in.param_3{' '} = @ischar;      % addOptional input
%       in = +in;
%
%   Parameter names ('param_1', ...) can be any string that can be used as 
%   a structure field (even 'CaseSensitive', 'PartialMatching', or 
%   'StructExpand').
%
%   --- Case sensitivity
%
%   By default the parser is case-insensitive. You can make the parser
%   case-sensitive by setting the CaseSensitive property to true:
%       this.CaseSensitive = true;
%
%   --- Unmatched inputs
%
%   The default behavior is to reject non-defined (unmatched) inputs.
%   However, unmatched inputs can be obtained simply by specifying a second
%   output to the parsing call:
%       [in, unmin] = +this;
%
%   --- Partial Matching
%
%   Partial matching is handled by default. To disable this feature, you
%   can specify:
%       this.PartialMatching = false;
%
%   See also ML.Input/uplus, inputParser
%
%   More on <a href="matlab:ML.doc('ML.Input');">ML.doc</a>
    
    % --- Properties
    properties (SetAccess = protected)
        args = {};
        postvalidation = struct();
    end
    
    % --- Constructor
    methods
        
        function this = Input(varargin)
            
            % FunctionName
            [~, this.FunctionName] = fileparts(ML.Files.whocalled);
            
            % Get arguments
            if numel(varargin)        
                this.args = varargin;
            else
                this.args = evalin('caller', 'varargin');
            end
            
        end
        
    end
end

%! ------------------------------------------------------------------------
%! Author: Raphaël Candelier
%! Version: 1.1
%
%! Revisions
%   1.1     (2015/04/01): Created help, added automatic handling of 
%               FunctionName and management of the 'StructExpand' property.
%   1.0     (2015/01/01): Initial version.
%
%! To_do
%
%! ------------------------------------------------------------------------
%! Doc
%   <title>To do</title>