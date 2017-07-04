function out = isdesktop
% ML.isdesktop Determine whether Matlab desktop is running
%   OUT = ML.isdesktop returns true (1) when Matlab's desktop is running 
%   and false (0) otherwise.
%
%   See also usejava, isdeployed
%
%   More on <a href="matlab:ML.doc('ML.isdesktop');">ML.doc</a>

try 
    out = usejava('desktop'); 
catch
    out = false;
end