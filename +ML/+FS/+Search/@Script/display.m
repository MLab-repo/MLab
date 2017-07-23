function display(this)

% --- Header
ML.CW.print(' ~bc[50 100 150]{%s}~c[gray]{%s} (script / %s)', this.Name, this.Extension, lower(this.Category));
fprintf('\t\t[<a href="matlab:edit ''%s'';">Edit file</a>]' , this.Fullpath);
fprintf('   [<a href="matlab:help ''%s'';">Help</a>]' , this.Fullpath);
switch this.Category
    case {'Built-in', 'Matlab', 'Toolbox'}
        fprintf('   [<a href="matlab:doc ''%s'';">Doc</a>]\n' , this.Fullpath);
    case {'MLab', 'Plugin'}
        fprintf('   [<a href="matlab:ML.doc(''%s'');">ML.Doc</a>]\n' , this.Fullpath);
end
% --- Properties

Prop = cell(1,2);

Prop{1,1} = '~c[gray]{Syntax}';
Prop{1,2} = this.Syntax;

% Package
if isprop(this, 'Package')
    Prop{end+1,1} = '~c[gray]{Package}';
    pack = ML.FS.search(this.Package, 'first');    
    Prop{end,2} = [this.slnk(pack.Fullpath, this.Package) '\n'];
end

ML.Text.table(Prop, 'style', 'compact', 'border', 'none');