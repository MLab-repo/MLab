function out = build(this, varargin)

% --- Code checking -------------------------------------------------------

%#ok<*AGROW>

% --- Built text ----------------------------------------------------------

out = '';
nbuild(1,0);

% === Nested building =====================================================

    function nbuild(index, level)
        
        switch this.Tree(index).type
            
            case 'container'
            
                % Indentation
                if this.indent && ~this.Tree(index).inline
                    out = [out repmat(this.spacer, [1 level])];
                end
                
                % --- Opening tag
                    
                % Open
                out = [out this.opener{1}];
                
                % Tagname
                if this.lowtag
                    out = [out lower(this.Tree(index).tagname)];
                else
                    out = [out this.Tree(index).tagname];
                end
                
                % Attributes
                F = fieldnames(this.Tree(index).attributes);
                for i = 1:numel(F)
                    if this.lowatt
                        out = [out ' ' lower(F{i})];
                    else
                        out = [out ' ' F{i}];
                    end                    
                    out = [out '=' this.attquote this.Tree(index).attributes.(F{i}) this.attquote]; 
                end
                
                % Close
                out = [out this.opener{2}];
                                
                 % Indentation
                if ~this.condensed && ~this.Tree(index).inline
                    out = [out newline];
                end
                
                % --- Content
                
                % Inline aspiration rule
                outline = false;
                if any([this.Tree(this.Tree(index).content).inline])
                    for i = 1:numel(this.Tree(index).content)
                        this.Tree(this.Tree(index).content(i)).inline = true;
                    end
                    outline =  ~this.Tree(index).inline;
                end

                if this.indent && outline
                    out = [out repmat(this.spacer, [1 level+1])];
                end
                
                % Push content
                for i = this.Tree(index).content
                    nbuild(i, level+1);
                end
                
                if ~this.condensed  && outline
                    out = [out newline];
                end
                
                % --- Closing tag
            
                % Indentation
                if this.indent && ~this.Tree(index).inline
                    out = [out repmat(this.spacer, [1 level])];
                end
                                
                % Close
                out = [out this.closer{1}];
                
                % Tagname
                if this.lowtag
                    out = [out lower(this.Tree(index).tagname)];
                else
                    out = [out this.Tree(index).tagname];
                end
                
                % Closer
                out = [out this.closer{2}];
                                
                % New line
                if ~this.condensed  && ~this.Tree(index).inline
                    out = [out newline];
                end
                
            case 'single'            
                
                 % Indentation
                if this.indent
                    out = [out repmat(this.spacer, [1 level])];
                end
                                
                % Open and tagname
                out = [out this.singler{1}];
                
                % Tagname
                if this.lowtag
                    out = [out lower(this.Tree(index).tagname)];
                else
                    out = [out this.Tree(index).tagname];
                end
                
                % Attributes
                F = fieldnames(this.Tree(index).attributes);
                for i = 1:numel(F)
                    if this.lowatt
                        out = [out ' ' lower(F{i})];
                    else
                        out = [out ' ' F{i}];
                    end                    
                    out = [out '=' this.attquote this.Tree(index).attributes.(F{i}) this.attquote];
                end
                
                % Close
                out = [out this.singler{2}];
                
                % Indentation
                if ~this.condensed
                    out = [out newline];
                end

            case 'text'
                
                 % Indentation
                if this.indent && ~this.Tree(index).inline
                    out = [out repmat(this.spacer, [1 level])];
                end
                                
                % Text
                out = [out this.Tree(index).content];
                
                % New line
                if ~this.condensed  && ~this.Tree(index).inline
                    out = [out newline];
                end
                
            case 'comment'
                
                 % Indentation
                if this.indent
                    out = [out repmat(this.spacer, [1 level])];
                end
                                
                % Text
                out = [out this.commenter{1} this.Tree(index).content this.commenter{2}];
                
                % Indentation
                if ~this.condensed
                    out = [out newline];
                end
        end
        
    end

end