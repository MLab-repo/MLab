function index = single(this, varargin)

% --- Inputs --------------------------------------------------------------

in = ML.Input;
in.parentPosition = 'numeric,integer,>=0';
in.tagname = 'str';
in.attributes({}) = 'str,cell,struct';
in.outline(true) = 'logical';
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

switch class(in.attributes)
    
    case 'cell'
        
        if size(in.attributes, 2)==1
            in.attributes = reshape(in.attributes, [2 numel(in.attributes)/2])';
        end
        
    case 'char'
    
        att = strsplit(in.attributes, ',');
        in.attributes = struct();
        for i = 1:numel(att)
            tmp = strsplit(att{i}, '=');
            in.attributes.(tmp{1}) = tmp{2};
        end
        
end

% --- Add element in the tree

this.Tree(index).parent = parent;
this.Tree(index).position = pos;
this.Tree(index).type = 'single';
this.Tree(index).tagname = in.tagname;
this.Tree(index).attributes = in.attributes;
this.Tree(index).content = [];
this.Tree(index).inline = false;

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