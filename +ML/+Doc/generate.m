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
in.Source{'MLab'} = @ischar;
in = in.process;

% Get sources
if strcmp(in.Source, 'MLab')
    conf = ML.config;
    in.Source = {conf.path};
end

% --- Preparation ---------------------------------------------------------

% --- Get Html folders

fprintf('Get Html folders ...'); tic

in.Html = cellfun(@(x) [x 'Documentation' filesep 'Html' filesep], in.Source, 'UniformOutput', false);

fprintf(' %.02f sec\n', toc);

% --- Purge Html folders

fprintf('Purge Html folders ...'); tic

for i = 1:numel(in.Html)
    
    FileList = ML.dir(in.Html{i});
    n = 0;
    
    for j = 1:numel(FileList)
        [~,~,ext] = fileparts(FileList(j).name);
        if ismember(ext, {'.script', '.function', '.package', '.class', '.method', '.glossary', '.plugin', '.tutorial'})
            delete([in.Html{i} FileList(j).name]);
            n = n+1;
        end
    end
    
end

fprintf(' %.02f sec (%i files removed)\n', toc, n);

% --- List files to process

fprintf('Listing files to process ...'); tic

FileList = {};

for i = 1:numel(path)
    
    in.Source{i}
    
    
    
end


fprintf(' %.02f sec\n', toc);
