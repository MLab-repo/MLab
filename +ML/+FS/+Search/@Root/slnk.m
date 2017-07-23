function out = slnk(varargin)

% --- Inputs --------------------------------------------------------------

in = ML.Input;
in.mhref = @ischar;
in.text{''} = @ischar;
in = +in;

% -------------------------------------------------------------------------

if isempty(in.text)
    in.text = in.mhref;
end

out = ['<a href="matlab:ML.FS.path2obj(''' in.mhref ''')">' in.text '</a>'];