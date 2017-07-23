function out = export(this, varargin)

% --- Inputs --------------------------------------------------------------

in = ML.Input;
in.filename{''} = 'char';
in = in.process;

% --- Built html ----------------------------------------------------------

html = '';
build(1,0);

% --- Output --------------------------------------------------------------

if nargout
    out = html;
end

if ~isempty(in.filename)
    fid = fopen(in.filename, 'w');
    fprintf(fid, '%s', html);
    fclose(fid);
end

% === NESTED FUNCTIONS ====================================================

    function build(index, level)

        switch this.Tree(index).type
            
            case 'Root'
                html = [this.Tree(index).options newline];
                build(index+1, level);
                
            case 'text'
                html = [html repmat(this.tab, [1 level]) this.Tree(index).options newline];
                
            otherwise
        
                html = [html repmat(this.tab, [1 level]) ...
                    '<' this.Tree(index).type];
                
                F = fieldnames(this.Tree(index).options);
                for i = 1:numel(F)
                    html = [html ' ' F{i} '=''' this.Tree(index).options.(F{i}) '''']; %#ok<*AGROW>
                end
                
                html = [html '>' newline];
                
                for i = this.Tree(index).children
                    build(i, level+1);
                end
                
                html = [html repmat(this.tab, [1 level]) ...
                    '</' this.Tree(index).type '>' newline];
        end
        
    end

end