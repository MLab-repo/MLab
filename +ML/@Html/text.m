function index = text(this, varargin)

% --- Inputs --------------------------------------------------------------

in = ML.Input;
in.ppos = 'numeric,integer,>=0';
in.text = 'str';
in = in.process;

% --- Processing ----------------------------------------------------------

index = this.NewElm(in.ppos, 'text', 'options', in.text);