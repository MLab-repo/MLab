function display(this, varargin)

% --- Inputs --------------------------------------------------------------

in = ML.Input;
in.numCols(4) = @isnumeric;
in = +in;

% -------------------------------------------------------------------------

% --- Header
% ML.CW.print(' ~bc[50 100 150]{%s} (Plugin - <a href="">Open folder</a>)\n', this.Name);
ML.CW.print(' ~bc[50 100 150]{%s} (Plugin)\n', this.Name);
ML.CW.print('~c[100 175 175]{%s}\n\n', this.Fullpath);

% --- Content

ML.CW.print('~bc[gray]{Content}');
if isempty(this.Content)
    
    fprintf('\tEmpty\n');
    
else
    
    fprintf('\n');
    ML.CW.print(disp_content(this.Content, 'ML.', 1));
    fprintf('\n\n');

end

    % --- Nested functions ------------------------------------------------
    function out = disp_content(in, pref, level)
        
        out = '';
        for i = 1:numel(in)
            
            tmp = in(i).Name;
            if ismember(in(i).Type, {'Package', 'Class'})
                tmp(1) = ''; 
            else
                [~,tmp] = fileparts(tmp);
            end            
            name = this.slnk([pref tmp], in(i).Name);
            
            out = [out char(10) repmat('    ', [1 level]) name];
            
            if ismember(in(i).Type, {'Package', 'Class'})
                out = [out disp_content(in(i).Content, [pref in(i).Name(2:end) '.'], level+1)];
            end
            
        end
    end

end