function index = NewElm(this, varargin)

% --- Inputs --------------------------------------------------------------

in = ML.Input;
in.ppos = 'numeric,integer,>=0';
in.type = 'str';
in.options(struct([])) = 'str,struct';
in = in.process;

% --- Processing ----------------------------------------------------------

% Index
index = numel(this.Tree)+1;

% --- Parent and position
if strcmp(in.type, 'Root')
    
    parent = NaN;
    pos = 1;
    
else
    
    switch numel(in.ppos)
        case 1
            parent = in.ppos;
            pos = numel(this.Tree(parent).children)+1;
            
        case 2
            parent = in.ppos(1);
            pos = min(in.ppos(2), numel(this.Tree(parent).children)+1);
    end
    
end



% --- Parse options

if ~ismember(in.type, {'Root', 'text'}) && ischar(in.options)

    opt = strsplit(in.options, ',');
    in.options = struct();
    for i = 1:numel(opt)
        tmp = strsplit(opt{i}, '=');
        in.options.(tmp{1}) = tmp{2};
    end
    
end

% --- Add element in the tree

this.Tree(index).parent = parent;
this.Tree(index).pos = pos;
this.Tree(index).children = [];
this.Tree(index).type = in.type;
this.Tree(index).options = in.options;

% --- Update parenthood

if ~isnan(parent)
    if pos<=numel(this.Tree(parent).children)
        this.Tree(parent).children = [this.Tree(parent).children(1:pos-1) NaN this.Tree(parent).children(pos:end)];
    end
    this.Tree(parent).children(pos) = index;
end