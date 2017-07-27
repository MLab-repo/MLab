function out = export(this, varargin)

% --- Inputs --------------------------------------------------------------

in = ML.Input;
in.filename = 'char,nonempty';
in = in.process;

% --- Built text ----------------------------------------------------------

fid = fopen(in.filename, 'w');
fprintf(fid, '%s', this.build);
fclose(fid);