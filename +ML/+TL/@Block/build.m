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
                switch class(this.Tree(index).attributes)
                    
                    case 'struct'
                        
                        F = fieldnames(this.Tree(index).attributes);
                        for i = 1:numel(F)
                            if this.lowatt
                                out = [out ' ' lower(F{i})];
                            else
                                out = [out ' ' F{i}];
                            end
                            out = [out '=' this.attquote mkstr(this.Tree(index).attributes.(F{i})) this.attquote];
                        end
                        
                    case 'cell'
                        
                        for i = 1:size(this.Tree(index).attributes, 1)
                            if this.lowatt
                                out = [out ' ' lower(this.Tree(index).attributes{i,1})];
                            else
                                out = [out ' ' this.Tree(index).attributes{i,1}];
                            end
                            out = [out '=' this.attquote mkstr(this.Tree(index).attributes{i,2}) this.attquote];
                        end
                        
                end
                
                % Close
                out = [out this.opener{2}];
                                
                 % Spacings
                if ~this.condensed 
                    
                    % Newline
                    if ~this.Tree(index).inline
                        out = [out newline];
                    end
                    
                    % Indentation
                    if this.indent && ~this.Tree(index).inline
                        out = [out repmat(this.spacer, [1 level+1])];
                    end
                    
                end
                
                % --- Content
               
                % Push content
                for i = 1:numel(this.Tree(index).content)
                    
                    nbuild(this.Tree(index).content(i), level+1);
                    
                    if ~this.condensed && ...
                            ~this.Tree(index).inline && ...
                            i<numel(this.Tree(index).content)
                        
                        out = [out newline];
                        if this.indent
                            out = [out repmat(this.spacer, [1 level+1])];
                        end
                        
                    end
                end
                
                % Spacings
                if ~this.condensed
                    
                    % Newline
                    if ~this.Tree(index).inline
                        out = [out newline];
                    end
                    
                    % Indentation
                    if this.indent && ~this.Tree(index).inline
                        out = [out repmat(this.spacer, [1 level-1])];
                    end
                    
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
                                
            case 'single'            
                                                
                % Open and tagname
                out = [out this.singler{1}];
                
                % Tagname
                if this.lowtag
                    out = [out lower(this.Tree(index).tagname)];
                else
                    out = [out this.Tree(index).tagname];
                end
                
                % Attributes
                switch class(this.Tree(index).attributes)
                    
                    case 'struct'
                        
                        F = fieldnames(this.Tree(index).attributes);
                        for i = 1:numel(F)
                            if this.lowatt
                                out = [out ' ' lower(F{i})];
                            else
                                out = [out ' ' F{i}];
                            end
                            out = [out '=' this.attquote mkstr(this.Tree(index).attributes.(F{i})) this.attquote];
                        end
                        
                    case 'cell'
                        
                        for i = 1:size(this.Tree(index).attributes, 1)
                            if this.lowatt
                                out = [out ' ' lower(this.Tree(index).attributes{i,1})];
                            else
                                out = [out ' ' this.Tree(index).attributes{i,1}];
                            end
                            out = [out '=' this.attquote mkstr(this.Tree(index).attributes{i,2}) this.attquote];
                        end
                        
                end
                
                % Close
                out = [out this.singler{2}];
                
            case 'text'
                                
                % Text
                out = [out this.Tree(index).content];
                                
            case 'comment'
                                
                % Text
                out = [out this.commenter{1} this.Tree(index).content this.commenter{2}];
                
        end
        
    end

end

% === Local functions =====================================================

function a = mkstr(a)
if isnumeric(a), a = num2str(a); end
end
