function display(this)

disp(this);
return

% clc

% --- Check
if isempty(this.Name), return; end

% --- List all properties
Prop = properties(this);

% --- Extract public properties and pseudomethods
Public = {};
Pseudo = {};

for i = 1:numel(Prop)
    
    % Properties to skip
    if ismember(Prop{i}, {'Type', 'Name', 'Path', 'Category', 'Extension'})
        continue
    end
    
    % Find property
    p = findprop(this, Prop{i});
    
    % Separate publics properties and pseudo-methods
    if isempty(p.GetMethod)
        if strcmp(p.GetAccess, 'public')
            Public{end+1} = Prop{i};
        end
    else
        Pseudo{end+1} = Prop{i};
    end
    
end

% --- Display

if isprop(this, 'Extension')
    ext = this.Extension;
else
    ext = '';
end

ML.CW.print('--- ~bc[50 100 150]{%s}~c[gray]{%s} (%s / %s)\n', this.Name, ext, this.Category, this.Type);
ML.CW.print('~c[100 175 175]{%s}\n\n', this.Path);

for i = 1:numel(Public)
    ML.CW.print('~c[gray]{%s} %s\n', Public{i}, this.(Public{i}));
end

for i = 1:numel(Pseudo)
    
    % Get (stringified) result
    res = this.(Pseudo{i});
    switch class(res)
        case 'logical'
            res = ML.logical2str(res);            
    end
    
    % Display pseudomethod
    ML.CW.print('~c[gray]{%s} %s\n', Pseudo{i}, res);
    
end