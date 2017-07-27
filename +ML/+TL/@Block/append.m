function append(this, varargin)

% --- Inputs --------------------------------------------------------------

in = ML.Input;
in.parentPosition = 'numeric,integer,>=0';
in.block = 'ML.TL.Block';
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
ref = numel(this.Tree);

% --- Add elements in the tree

for i = 1:numel(in.block.Tree)

    this.Tree(ref+i).parent = parent;
    this.Tree(ref+i).pos = pos;
    this.Tree(ref+i).type = in.block.Tree(i).type;
    this.Tree(ref+i).tagname = in.block.Tree(i).tagname;
    this.Tree(ref+i).attributes = in.block.Tree(i).attributes;
    this.Tree(ref+i).inline = in.block.Tree(i).inline;
    
    switch in.block.Tree(i).type
        case 'container'
            this.Tree(ref+i).content = in.block.Tree(i).content + ref;
        otherwise
            this.Tree(ref+i).content = in.block.Tree(i).content;
    end
    
end

% --- Update parenthood

if parent>0
    if pos<=numel(this.Tree(parent).content)
        this.Tree(parent).content = [this.Tree(parent).content(1:pos-1) ref+1 this.Tree(parent).content(pos:end)];
    else
        this.Tree(parent).content(pos) = ref+1;
    end
end