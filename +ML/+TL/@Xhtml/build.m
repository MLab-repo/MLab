function out = build(this, varargin)

% --- Add the doctype
out = ['<!DOCTYPE ' this.doctype '>' newline];

% --- Build the block
out = [out build@ML.TL.Block(this, varargin{:})];