function out = pathify(in)
% TO DO

% --- Manage cell of paths
if iscellstr(in)
    cellfun(@ML.pathify, in);
end


