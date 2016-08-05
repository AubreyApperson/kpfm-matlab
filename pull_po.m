function [ po_re, po_name ] = pull_po( filename, horz_res, tab_iter)
%pull_po For mass importing sections of matricies from .txt files (tab
%delimited) from igor.
%   This program seperates the wanted tab of data (from the igor exported 
%   .txt file), returns it in addition to a nice name. tab_iter referes to
%   the tab the data you want is on in igor.  vert_res referes to the
%   number of lines the image was taken with.

% This work supported by NSF Career Award DMR -1056861.
%% Begin Code
% format long  % should a high precision be needed, uncomment this command
%% Seperate out the wanted data
t = load(filename);
% where does the wanted data begin?
begin = horz_res*(tab_iter-1);
% Do the matrix concatenation
po_re = t((begin+1):(begin+horz_res),:);

%% Make the caller a nice variable name to go with it
hld = strsplit(filename, '.'); 
po_name = strcat('po_', hld(1,1));



end

