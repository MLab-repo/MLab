function out = table(varargin)
% ML.text.table Command-window text table
%   ML.text.table(C) displays the content of the cell C in a tabular form
%   in the command window. The elements of C can be strings, numbers
%   (including boolean, NaN, Inf and all numeric types) or cells. For
%   cells, a multi-line element is created, with one row per cell element.
%   Rich text (<strong>, <a>) are gracefully handled.
%
%   ML.text.table(..., 'row_headers', RH) adds row headers. The number of
%   elements in RH have to match the first dimension of C. RH can contain a
%   mix of strings and numbers.
%
%   ML.text.table(..., 'col_headers', CH) adds column headers. The number 
%   of elements in CH have to match the first dimension of C. CH can 
%   contain a mix of strings and numbers.
%
%   ML.text.table(..., 'style', ST) specifies the table structure style. ST
%   is a string that can be:
%       - 'normal' (default)
%       - 'compact'
%
%   ML.text.table(..., 'border', B) specifies the table border style. B is 
%   a string that can be:
%       - 'none'
%       - 'ascii'
%       - 'single' (default)
%       - 'rounded'
%       - 'bold'
%       - 'hbold'
%       - 'vbold'
%       - 'double'
%       - 'hdouble'
%       - 'vdouble'
%
%   OUT = ML.text.table(...) outputs the table as a string and does not
%   display it in the command window.
%
%   See also
%
%   More on <a href="matlab:ML.doc('ML.text.Table');">ML.doc</a>

% --- Input
in = ML.Input;
in.cont = @iscell;
in.row_headers({}) = @iscell;
in.col_headers({}) = @iscell;
in.style('normal') = @(x) any(strcmpi(x, {'normal', 'compact'}));
in.border('single') = @(x) any(strcmpi(x, {'none', 'ascii', 'single', 'rounded', 'bold', 'hbold', 'vbold', 'double', 'hdouble', 'vdouble'}));
in.hpad(' ') = @ischar;
in = +in;

% -------------------------------------------------------------------------
s = '';

if ~isempty(in.cont)
    
    % --- Checks
    if ~isempty(in.row_headers) && numel(in.row_headers)~=size(in.cont,1)
        error('ML:text:table:NumHeaderRows', ['The number of row headers (' ...
            num2str(numel(in.row_headers)) ') is different from the number of rows (' ...
            num2str(size(in.cont,1)) ')']);
    end
    
    if ~isempty(in.col_headers) && numel(in.col_headers)~=size(in.cont,2)
        error('ML:text:table:NumHeaderCols', ['The number of column headers (' ...
            num2str(numel(in.col_headers)) ') is different from the number of columns (' ...
            num2str(size(in.cont,2)) ')']);
    end
    
    % --- Main part
    cont = in.cont;
    
    % Rows (convert, bold-style and store)
    if ~isempty(in.row_headers)
        tmp = cellfun(@fmt, in.row_headers, 'UniformOutput', false);
        rows = cellfun(@(y) cellfun(@(x) ['~b{' x '}'], y, 'UniformOutput', false), tmp, 'UniformOutput', false);
        cont = [rows(:) cont];
    end
        
    % Cols (convert, bold-style and store)
    if ~isempty(in.col_headers)
        tmp = cellfun(@fmt, in.col_headers, 'UniformOutput', false);
        cols = cellfun(@(y) cellfun(@(x) ['~b{' x '}'], y, 'UniformOutput', false), tmp, 'UniformOutput', false);
        cols = cols(:)';
        if ~isempty(in.row_headers), cols = [{''} cols]; end
        cont = [cols ; cont];
    end
    
    % --- Get elements
    elms = cell(size(cont));
    selm = NaN([size(cont) 2]);
    n = cell(size(cont));
    
    for i = 1:size(cont,1)
        for j = 1:size(cont,2)
            
            % Get element
            elms{i,j} = fmt(cont{i,j});
            
            % Get elements' sizes
            selm(i,j,1) = numel(elms{i,j});
            n{i,j} = NaN(numel(elms{i,j}),1);
            for k = 1:numel(elms{i,j})
                n{i,j}(k) = ML.CW.numel(elms{i,j}{k});
            end
            selm(i,j,2) = max(n{i,j});
            
        end
    end
    
    % --- Get row heights and col widths
    rh = max(selm(:,:,1), [], 2);
    cw = max(selm(:,:,2), [], 1);
    
    switch in.border
        
        case 'none'
            
            C = struct('h', ' ', ...
                'v', ' ', ...
                'tl', ' ', ...
                'tr', ' ', ...
                'bl', ' ', ...
                'br', ' ', ...
                't', ' ', ...
                'b', ' ', ...
                'l', ' ', ...
                'r', ' ', ...
                'm', ' ');
        
        case 'ascii'
            
            C = struct('h', '-', ...
                'v', '|', ...
                'tl', '+', ...
                'tr', '+', ...
                'bl', '+', ...
                'br', '+', ...
                't', '-', ...
                'b', '-', ...
                'l', '|', ...
                'r', '|', ...
                'm', '+');
            
        case 'single'
            
            C = struct('h', char(9472), ...
                'v', char(9474), ...
                'tl', char(9484), ...
                'tr', char(9488), ...
                'bl', char(9492), ...
                'br', char(9496), ...
                't', char(9516), ...
                'b', char(9524), ...
                'l', char(9500), ...
                'r', char(9508), ...
                'm', char(9532));
            
        case 'rounded'
            
            C = struct('h', char(9472), ...
                'v', char(9474), ...
                'tl', char(9581), ...
                'tr', char(9582), ...
                'bl', char(9584), ...
                'br', char(9583), ...
                't', char(9516), ...
                'b', char(9524), ...
                'l', char(9500), ...
                'r', char(9508), ...
                'm', char(9532));
            
        case 'bold'
            
            C = struct('h', char(9473), ...
                'v', char(9475), ...
                'tl', char(9487), ...
                'tr', char(9491), ...
                'bl', char(9495), ...
                'br', char(9499), ...
                't', char(9523), ...
                'b', char(9531), ...
                'l', char(9507), ...
                'r', char(9515), ...
                'm', char(9547));
            
        case 'hbold'
            
            C = struct('h', char(9473), ...
                'v', char(9474), ...
                'tl', char(9485), ...
                'tr', char(9489), ...
                'bl', char(9493), ...
                'br', char(9497), ...
                't', char(9519), ...
                'b', char(9527), ...
                'l', char(9501), ...
                'r', char(9509), ...
                'm', char(9535));
            
        case 'vbold'
            
            C = struct('h', char(9472), ...
                'v', char(9475), ...
                'tl', char(9486), ...
                'tr', char(9490), ...
                'bl', char(9494), ...
                'br', char(9498), ...
                't', char(9520), ...
                'b', char(9528), ...
                'l', char(9504), ...
                'r', char(9512), ...
                'm', char(9538));
            
        case 'double'
            
            C = struct('h', char(9552), ...
                'v', char(9553), ...
                'tl', char(9556), ...
                'tr', char(9559), ...
                'bl', char(9562), ...
                'br', char(9565), ...
                't', char(9574), ...
                'b', char(9577), ...
                'l', char(9568), ...
                'r', char(9571), ...
                'm', char(9580));
            
        case 'hdouble'
            
            C = struct('h', char(9552), ...
                'v', char(9474), ...
                'tl', char(9554), ...
                'tr', char(9557), ...
                'bl', char(9560), ...
                'br', char(9563), ...
                't', char(9572), ...
                'b', char(9575), ...
                'l', char(9566), ...
                'r', char(9569), ...
                'm', char(9578));
            
        case 'vdouble'
            
            C = struct('h', char(9472), ...
                'v', char(9553), ...
                'tl', char(9555), ...
                'tr', char(9558), ...
                'bl', char(9561), ...
                'br', char(9564), ...
                't', char(9573), ...
                'b', char(9576), ...
                'l', char(9567), ...
                'r', char(9570), ...
                'm', char(9579));
            
    end
    % Horizontal padding
    C.hpad = in.hpad;
    
    % --- Build table
    
    % Separating lines
    for i = 1:numel(cw)
        if i == 1
            slt = C.tl;
            slm = C.l;
            slb = C.bl;
        end
        slt = [slt repmat(C.h, [1 cw(i)+2*numel(C.hpad)])];
        slm = [slm repmat(C.h, [1 cw(i)+2*numel(C.hpad)])];
        slb = [slb repmat(C.h, [1 cw(i)+2*numel(C.hpad)])];
        if i == numel(cw)
            slt = [slt C.tr];
            slm = [slm C.r];
            slb = [slb C.br];
        else
            slt = [slt C.t];
            slm = [slm C.m];
            slb = [slb C.b];
        end
    end
    
    % Build loop
    switch in.style
        
        case 'normal'
            
            add('%s', slt);
            for i = 1:size(elms,1)
                for k = 1:rh(i)
                    add('\n%s', C.v);
                    for j = 1:size(elms,2)
                        if numel(elms{i,j})>=k
                            tmp = elms{i,j}{k};
                            num = n{i,j}(k);
                        else
                            tmp = '';
                            num = 0;
                        end
                        tmp = [tmp repmat(C.hpad,[1 cw(j)-num])];
                        add('%s%s%s%s', C.hpad, tmp, C.hpad, C.v);
                    end
                end
                                
                if i < size(elms,1)
                    add('\n%s', slm);
                else
                    add('\n%s\n', slb);
                end
            end
            
        case 'compact'
            
            add('%s', slt);
            for i = 1:size(elms,1)
                for k = 1:rh(i)
                    add('\n%s', C.v);
                    for j = 1:size(elms,2)
                        if numel(elms{i,j})>=k
                            tmp = elms{i,j}{k};
                            num = n{i,j}(k);
                        else
                            tmp = '';
                            num = 0;
                        end
                        tmp = [tmp repmat(C.hpad,[1 cw(j)-num])];
                        add('%s%s%s%s', C.hpad, tmp, C.hpad, C.v);
                    end
                end
                 
                if i==~isempty(in.col_headers)
                    add('\n%s', slm);
                elseif i==size(elms,1)
                    add('\n%s\n', slb);
                end
            end
    end
end

% --- Output
if nargout
    out = s;
else
    ML.CW.print('%s',s);
end

    % --- Nested functions ------------------------------------------------
    function add(varargin)
        s = [s sprintf(varargin{:})];
    end

end

% --- Local functions -----------------------------------------------------
function out = fmt(in)

     if iscell(in)
        I = cellfun(@isnumeric, in);
        in(I) = cellfun(@num2str, in(I), 'UniformOutput', false);
        out = in;
     elseif ischar(in)
         out = {in};
     elseif isnumeric(in)
         out = {num2str(in)};
     else
         warning('ML:text:table:UnsupportedClass', ['Unsupported element of class ' class(in) '.']);
         out = {};
     end

end

%! ------------------------------------------------------------------------
%! Author: Raphaël Candelier
%! Version: 1.2
%
%! Revisions
%   1.2     (2015/04/07): Corrected a bug in 'compact' display, added the
%               'none', 'rounded', 'bold', 'hbold', 'vblod', 'hdouble' and 
%               'vdouble' border styles, unified C.hpad.
%   1.1     (2015/04/06): Merged into one single function, created help,
%               added check for empty input, allowed for no-display output,
%               allowed for row and column headers simultaneously, support 
%               for numbers in rows/cols, support for multi-line elements.
%   1.0     (2010/01/01): Initial version.
%
%! To_do
%   Check for hyperlinks in the rows/cols (disable bolding) & update help
%   MLdoc
%! ------------------------------------------------------------------------
%! Doc
%   <title>To do</title>