function index = comment(this, varargin)

% --- Inputs --------------------------------------------------------------

in = ML.Input;
in.parentPosition = 'numeric,integer,>=0';
in.content = 'char';
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

% --- Add element in the tree

this.Tree(index).parent = parent;
this.Tree(index).position = pos;
this.Tree(index).type = 'comment';
this.Tree(index).tagname = '';
this.Tree(index).attributes = struct([]);
this.Tree(index).content = in.content;
this.Tree(index).inline = false;

% --- Update parenthood
if parent>0
    if pos<=numel(this.Tree(parent).content)
        this.Tree(parent).content = [this.Tree(parent).content(1:pos-1) index this.Tree(parent).content(pos:end)];
    else
        this.Tree(parent).content(pos) = index;
    end
end