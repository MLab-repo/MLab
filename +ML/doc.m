function doc(varargin)
% ML.doc MLab documentation in Matlab Web browser
%   ML.doc Opens MLab documentation at the default page.
%
%   ML.doc(FCM) displays the documentation of a function, class or method
%   in MLab's help browser. If the browser is already opened, a new tab is
%   created.
%
%   See also doc
%
%   More on <a href="matlab:ML.doc('ML.doc');">ML.doc</a>

% --- Get configuration
conf = ML.config;

fpath = [conf.path 'Documentation' filesep 'Html' filesep 'MLab_home.html'];

web(fpath, '-noaddressbox');

