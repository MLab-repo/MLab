function index = div(this, varargin)

% --- Inputs --------------------------------------------------------------

in = ML.Input;
in.ppos = 'numeric,integer,>=0';
in.options{struct([])} = 'str,struct';
in = in.process;

% --- Processing ----------------------------------------------------------

index = this.NewElm(in.ppos, 'div', 'options', in.options);