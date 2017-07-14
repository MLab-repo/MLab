function out = export(this, varargin)

% --- Inputs --------------------------------------------------------------

in = ML.Input;
in.filename('') = @ischar;
in = +in;

% --- Preparation ---------------------------------------------------------

% Configuration infos (for path)
conf = ML.config;

% --- Html ----------------------------------------------------------------

html = '';
add('<!DOCTYPE html>');
add('<html>');
add('<head>');
add('  <title>MLab</title>');
add(['  <link rel="stylesheet" type="text/css" href="' conf.path 'Doc' filesep 'Style' filesep 'fonts.css">']);
add(['  <link rel="stylesheet" type="text/css" href="' conf.path 'Doc' filesep 'Style' filesep 'style.css">']);
add(['  <script type="text/javascript" src="' conf.path 'Doc' filesep 'jquery-3.0.0.min.js"></script>']);
add(['  <script type="text/javascript" src="' conf.path 'Doc' filesep 'Doc.js"></script>']);
add('</head>');
add('<body>');
add('  <div id="wrapper">');
add('    <div id="header">');
add('      <div id="header_cont">');
add(['        <img src="' conf.path 'Images' filesep 'Icons' filesep 'MLab.png" height=30px>']);
add('        <span style="color: #555;">MLab</span> <span style="color: grey;">documentation</span>');
add('        <form id="search">');
add('          <input id="searchfield" type="text" value="">');
add('          <input id="searchthis" type="button" value="Search">');
add('        </form>');
add('      </div>');
add('    </div>');
add('      <table id="content">');
add('        <tr>');
add('          <td id="menu">');
add('            <h1>Menu</h1>');
add('            <ul>');
add('              <li></li>');
add('            </ul>');
add('          </td>');
add('          <td id="main">');
add(this.main);
add('          </td>');
add('        </tr>');
add('      </table>');
add('    <div id="footer">');
add('    Footer');
add('    </div>');
add('  </div>');
add('</body>');
add('</html>');

% --- Output --------------------------------------------------------------
if nargout
    out = html;
end

if ~isempty(in.filename)
    fid = fopen(in.filename, 'w');
    fprintf(fid, '%s', html);
    fclose(fid);
end

% -------------------------------------------------------------------------
    function add(txt)
        if ~isempty(html)
            html = [html char(10)];
        end
        html = [html txt];
    end

end