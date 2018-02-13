function generate(varargin)
% TO DO
 
% Decide what are the source folders and the corresponding Html (output) folders
% Remove all non-.html files in all Html folders
% 	For each source folder:
% List all the functions / packages / classes / methods by recursively exploring the subfolders
% Apply ML.Doc.m2htmlab.m for each of these items to create individual documentation files
% Create a FolderName.glossary file.

clc

% --- Inputs --------------------------------------------------------------

in = ML.Input;
in.Source{'MLab'} = 'str,nonempty,topath';
in.DocDir('') = 'str,topath';
in = in.process;

% --- Default sources
switch in.Source(1:end-1)
    case 'MLab'
        conf = ML.config;
        in.Source = conf.path;
        in.ContentDir = [conf.path '+ML' filesep];
    otherwise
        in.ContentDir = in.Source;
end

% --- Default documentation folder
if strcmp(in.DocDir, filesep)
    in.DocDir = [in.Source 'Documentation' filesep];
end

% --- Html folder
in.HtmlDir = [in.DocDir 'Html' filesep];
if ~exist(in.HtmlDir, 'dir'), mkdir(in.HtmlDir); end

% --- Preparation ---------------------------------------------------------

% --- Display information

ML.CW.line('~b{ML.doc generation}');

ML.text.table({in.ContentDir ; in.HtmlDir}, ...
    'row_headers', {'Source' ; 'Html'}, ...
    'style', 'compact', 'border', 'none');

% --- List Html files

fprintf('List Html files ...'); tic

Html = ML.FS.dir(in.HtmlDir);

fprintf(' %.02f sec\n', toc);

% --- List content

fprintf('Listing content to process ...'); tic

Content = ML.FS.rdir(in.ContentDir);

fprintf(' %.02f sec\n', toc);

% --- Compare

for i = 12 %:numel(Content)
   
    % Get object
    Obj = ML.FS.path2obj(Content(i).fullname);
    
    % Get html file name
    tmp = strsplit(class(Obj), '.');
    hname = [in.HtmlDir Obj.Syntax '.' lower(tmp{end})];
    
    % Take decision: generate or not?
% % %     gen = false;
% % %     if ~exist(hname, 'file')
% % %         gen = true;
% % %     else
% % %         warning('TO DO');        
% % %     end
    
    % Create html file
    page = ML.Doc.Page(Obj);
    page.export(hname);
    
    web(hname, '-noaddressbox');
    
end

