function out = export(this, varargin)

% --- Inputs --------------------------------------------------------------

in = ML.Input;
in.filename{''} = 'char';
in = in.process;

% --- Built text ----------------------------------------------------------

text = '';
build(1,0);

% --- Output --------------------------------------------------------------

if nargout
    out = text;
end

if ~isempty(in.filename)
    fid = fopen(in.filename, 'w');
    fprintf(fid, '%s', text);
    fclose(fid);
end

% === NESTED FUNCTIONS ====================================================

    function build(index, level)

        switch this.Tree(index).type
            
            case 'Root'
                text = [this.Tree(index).options newline];
                build(index+1, level);
                
            case 'text'
                text = [text repmat(this.tab, [1 level]) this.Tree(index).options newline];
                
            otherwise
        
                text = [text repmat(this.tab, [1 level]) ...
                    '<' this.Tree(index).type];
                
                F = fieldnames(this.Tree(index).options);
                for i = 1:numel(F)
                    text = [text ' ' F{i} '=''' this.Tree(index).options.(F{i}) '''']; %#ok<*AGROW>
                end
                
                text = [text '>' newline];
                
                for i = this.Tree(index).children
                    build(i, level+1);
                end
                
                text = [text repmat(this.tab, [1 level]) ...
                    '</' this.Tree(index).type '>' newline];
        end
        
    end

end