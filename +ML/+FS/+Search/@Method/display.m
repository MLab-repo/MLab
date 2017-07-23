function display(this)

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
ML.CW.print(' ~bc[50 100 150]{%s}~c[gray]{%s} (method / %s)', this.Name, this.Extension, cat);
fprintf('\t\t[<a href="matlab:edit ''%s'';">Edit file</a>]' , this.Fullpath);
fprintf('   [<a href="matlab:help ''%s'';">Help</a>]' , this.Fullpath);
switch this.Category
    case {'Built-in', 'Matlab', 'Toolbox'}
        fprintf('\t\t[<a href="matlab:doc ''%s'';">Doc</a>]\n' , this.Fullpath);
    case {'MLab', 'Plugin'}
        fprintf(' [<a href="matlab:ML.doc(''%s'');">ML.Doc</a>]\n' , this.Fullpath);
end

ML.CW.print(' ~c[100 175 175]{%s}\n', this.Fullpath);

% --- Properties

Prop = cell(1,2);

% Syntax
Prop{1,1} = '~c[gray]{Syntax}';
Prop{1,2} = this.Syntax;

% Class
Prop{end+1,1} = '~c[gray]{Class}';
Prop{end,2} = [this.slnk(fileparts(this.Fullpath), this.Class) '\n'];

% Toolbox
if isprop(this, 'Toolbox')
    Prop{end+1,1} = '~c[gray]{Toolbox}';
    Prop{end,2} = this.Toolbox;
end

% Package
if isprop(this, 'Package')
    Prop{end+1,1} = '~c[gray]{Package}';
    Prop{end,2} = [this.slnk(this.Package) '\n'];
end

ML.Text.table(Prop, 'style', 'compact', 'border', 'none');