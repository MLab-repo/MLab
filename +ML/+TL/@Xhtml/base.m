function out = base(this, varargin)

% --- Input ---------------------------------------------------------------
in = ML.Input;
in.href = 'char';
in.target{''} = @(x) ismember(x, {'_self', '_blank', '_parent', '_top'});
in = in.process;

% --- Processing ----------------------------------------------------------

if isempty(in.target)
    in = rmfield(in, 'target'); 
end

out = this.single(this.Index.head, 'base', 'attributes', in);