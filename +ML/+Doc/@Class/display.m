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

if this.isclassdef
    cls = 'class';
else
    cls = 'non-classdef class';
end

% --- Header
ML.CW.print(' ~bc[50 100 150]{%s} (%s / %s)', this.Name, cls, cat);
fprintf('\t\t[<a href="matlab:edit ''%s'';">Edit file</a>]' , this.Fullpath);
fprintf('   [<a href="matlab:help ''%s'';">Help</a>]' , this.Fullpath);
switch this.Category
    case {'Built-in', 'Matlab', 'Toolbox'}
        fprintf('   [<a href="matlab:doc ''%s'';">Doc</a>]\n' , this.Fullpath);
    case {'MLab', 'Plugin'}
        fprintf('   [<a href="matlab:ML.doc(''%s'');">ML.Doc</a>]\n' , this.Fullpath);
end

ML.CW.print('~c[100 175 175]{%s}\n', this.Fullpath);

% --- Properties

Prop = cell(1,2);

Prop{1,1} = '~c[gray]{Syntax}';
Prop{1,2} = this.Syntax;

% Parenthood
if isprop(this, 'Parents')
    if numel(this.Parents)==1
        Prop{end+1,1} = '~c[gray]{Parent}';
    else
        Prop{end+1,1} = '~c[gray]{Parents}';
    end
    
    tmp = [];
    for i = 1:numel(this.Parents)
        parent = ML.FS.search(this.Parents{i}, 'first');
        tmp = [tmp this.slnk(parent.Fullpath, this.Parents{i}) '   '];
    end
    Prop{end,2} = tmp;
end


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

% --- Properties and methods ----------------------------------------------

if this.isclassdef
    
    % Get meta class
    mcls = meta.class.fromName(this.Syntax);
    
    % --- Properties
    Paxs = cell(numel(mcls.PropertyList),1);
    Prop = cell(numel(mcls.PropertyList),1);
    if numel(mcls.PropertyList)
        Paxs(:) = {''};
        Prop(:) = {''};
    end
    
    for i = 1:numel(mcls.PropertyList)
        
        % Get acess
        if strcmp(mcls.PropertyList(i).GetAccess, 'public')
            Paxs{i} = [Paxs{i} 'G'];
        else
            Paxs{i} = [Paxs{i} '~c[gray]{G}'];
        end
        
        % Set acess
        if strcmp(mcls.PropertyList(i).SetAccess, 'public')
            Paxs{i} = [Paxs{i} 'S'];
        else
            Paxs{i} = [Paxs{i} '~c[gray]{S}'];
        end
        
        % Property
        if mcls.PropertyList(i).Hidden
            Prop{i} = ['~c[gray]{' mcls.PropertyList(i).Name '}'];
        else
            Prop{i} = mcls.PropertyList(i).Name;
        end
        
    end
    
    % --- Methods
    
    Maxs = {};
    Meth = {};
    
    for i = 1:numel(mcls.MethodList)
        
        if ~exist([this.Fullpath filesep mcls.MethodList(i).Name '.m'], 'file') && ...
                ~exist([this.Fullpath filesep mcls.MethodList(i).Name '.p'], 'file')
            continue;
        end
        
        % Get acess
        if strcmp(mcls.MethodList(i).Access, 'public')
            Maxs{end+1,1} = 'P';
        else
            Maxs{end+1,1} = '~c[gray]{P}';
        end
        
        % Method
        if mcls.MethodList(i).Hidden
            Meth{end+1,1} = ['~c[gray]{' mcls.MethodList(i).Name '}'];
        else
            Meth{end+1,1} = this.slnk([this.Fullpath filesep mcls.MethodList(i).Name], mcls.MethodList(i).Name);
        end
        
    end
    
    % Display table
    Nrows = max(numel(Prop), numel(Meth));
    if numel(Prop)<Nrows
        Paxs(Nrows) = {''};
        Prop(Nrows) = {''};
    end
    if numel(Meth)<Nrows
        Maxs(Nrows) = {''};
        Meth(Nrows) = {''};
    end
    
    T = [Paxs Prop Maxs Meth];
    
    ML.Text.table(T, 'style', 'compact', 'border', 'none', ...
        'col_headers', {'' 'Properties' '' 'Methods'});
    
end