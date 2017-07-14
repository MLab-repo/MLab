function display(this, varargin)

% --- Inputs --------------------------------------------------------------

in = ML.Input;
in.numCols(4) = @isnumeric;
in = +in;

% -------------------------------------------------------------------------

% --- Category
switch this.Category
    case 'Toolbox'
        cat = [this.Toolbox ' toolbox'];
    case 'MLab'
        cat = 'MLab';
    case 'Plugin'
        cat = 'MLab plugin';
    otherwise
        cat = lower(this.Category);
end

% --- Header
ML.CW.print(' ~bc[50 100 150]{%s} (package / %s)\n', this.Name, cat);
ML.CW.print('~c[100 175 175]{%s}\n', this.Fullpath);

% --- Properties

Prop = cell(1,2);

Prop{1,1} = '~c[gray]{Syntax}';
Prop{1,2} = this.Syntax;

% Package
if isprop(this, 'Package')
    Prop{end+1,1} = '~c[gray]{Package}';
    pack = ML.search(this.Package, 'first');    
    Prop{end,2} = [this.slnk(pack.Fullpath, this.Package) '\n'];
end

ML.Text.table(Prop, 'style', 'compact', 'border', 'none');

% Content

ML.CW.print('~bc[gray]{Content}');
if isempty(this.Content)
    
    fprintf('\tEmpty\n');
    
else
    
    tmp = cellfun(@format_link, this.Content, 'UniformOutput', false);
    
    numRows = ceil(numel(tmp)/in.numCols);
    if numel(tmp)<numRows*in.numCols
        tmp{numRows*in.numCols} = [];
    end
    tmp = reshape(tmp, [in.numCols numRows])';
    
    fprintf('\n');
    ML.Text.table(tmp, 'style', 'compact', 'border', 'none')

end

    % --- Nested functions ------------------------------------------------
    function out = format_link(in)
        
        [~, x] = fileparts(in);
        if strcmp(x(1), '+'), x = x(2:end); end
        out = this.slnk([this.Fullpath filesep in], x);
        
    end

end