function out = isfunction_handle(x)
%ML.isfunction_handle Determine whether input is function handle
%   TF = ML.ISFUNCTION_HANDLE(A) returns logical 1 (true) if A is a 
%   function handle and logical 0 (false) otherwise.
%
%   See also: is*, isa.

out = isa(x, 'function_handle');