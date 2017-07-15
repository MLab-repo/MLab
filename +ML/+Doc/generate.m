function generate(varargin)
% TO DO
 
% Decide what are the source folders and the corresponding Html (output) folders
% Remove all non-.html files in all Html folders
% 	For each source folder:
% List all the functions / packages / classes / methods by recursively exploring the subfolders
% Apply ML.Doc.m2htmlab.m for each of these items to create individual documentation files
% Create a FolderName.glossary file.

% --- Inputs
in = ML.Input;
in.source{pwd} = @ischar;
in = in.process;

% --- Decide the source
if strcmp(in.source, 'MLab')
    conf = ML.config;
    in.source = conf.path;
end

% Cellification & pathification
in.source = ML.pathify(ML.cellify(in.source));

% --- Decide Html folders
Hpath = cellfun(@(x) [x 'Html' filesep], in.source, 'UniformOutput', false)