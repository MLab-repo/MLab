function index = container(this, varargin)

% --- Inputs --------------------------------------------------------------

in = ML.Input;
in.parentPosition = 'numeric,integer,>=0';
in.tagname = 'str';
in.attributes(struct([])) = 'str,struct';
in.outline(true) = 'logical';
in.inline(false) = 'logical';
in = in.process;

% --- Processing ----------------------------------------------------------

% --- Parent and position

switch numel(in.parentPosition)
    case 1
        
        if in.parentPosition==0
            
            parent = 0;
            pos = 1;
            
        else
            
            parent = in.parentPosition;
            pos = numel(this.Tree(parent).content)+1;
        end
        
    case 2
        
        parent = in.parentPosition(1);
        pos = min(in.parentPosition(2), numel(this.Tree(parent).content)+1);
        
end

% --- Index
index = numel(this.Tree)+1;

% --- Parse options

if ischar(in.attributes)
    
    att = strsplit(in.attributes, ',');
    in.attributes = struct();
    for i = 1:numel(att)
        tmp = cellfun(@strtrim, strsplit(att{i}, '='), 'UniformOutput', false);
        in.attributes.(tmp{1}) = tmp{2};
    end
    
end

% --- Add element in the tree
this.Tree(index).parent = parent;
this.Tree(index).position = pos;
this.Tree(index).type = 'container';
this.Tree(index).tagname = in.tagname;
this.Tree(index).attributes = in.attributes;
this.Tree(index).content = [];
this.Tree(index).inline = in.inline;

% --- Update parenthood
if parent>0
    if pos<=numel(this.Tree(parent).content)
        this.Tree(parent).content = [this.Tree(parent).content(1:pos-1) index this.Tree(parent).content(pos:end)];
    else
        this.Tree(parent).content(pos) = index;
    end
end

if ~in.outline
    this.Tree(parent).inline = true;
end