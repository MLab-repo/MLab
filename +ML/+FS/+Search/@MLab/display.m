function display(this, varargin)

% --- Inputs --------------------------------------------------------------

in = ML.Input;
in.numCols(4) = @isnumeric;
in = +in;

% -------------------------------------------------------------------------

% --- Header
ML.CW.print(' ~bc[50 100 150]{MLab}');
fprintf('   [<a href="matlab:ML.doc(''%s'');">ML.Doc</a>]\n', this.Fullpath);

ML.CW.print('~c[100 175 175]{%s}\n\n', this.Fullpath);

% --- Installed plugins

ML.CW.print('~bc[gray]{Installed plugins}');
if isempty(this.Plugins)
    
    fprintf('\tNone   [<a href="matlab:ML.plugins">Manage plugins</a>]\n');
    
else
    
    fprintf('\t[<a href="matlab:ML.plugins">Manage plugins</a>]\n');
    
    tmp = cellfun(@format_link, this.Plugins, 'UniformOutput', false);
    
    numRows = ceil(numel(tmp)/in.numCols);
    if numel(tmp)<numRows*in.numCols
        tmp{numRows*in.numCols} = [];
    end
    tmp = reshape(tmp, [in.numCols numRows])';
    
    ML.Text.table(tmp, 'style', 'compact', 'border', 'none')

end

    % --- Nested functions ------------------------------------------------
    function out = format_link(in)
        
        [~, x] = fileparts(in);
        if strcmp(x(1), '+'), x = x(2:end); end
        out = this.slnk(x);
        
    end

end