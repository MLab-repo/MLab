function out = build(this, varargin)

% --- Add the doctype
out = ['<!DOCTYPE ' this.doctype '>'];
if ~this.condensed
    out = [out newline];
end

% --- Build the block
out = [out build@ML.TL.Block(this, varargin{:})];