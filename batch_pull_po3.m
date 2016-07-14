function [ master, names, num_images ] = batch_pull_po3( path, vert_res, horz_res, tab_iter )
%batch_pull_po2 Function extracts a folders .txt data into MatLab
%   Master contains all the matricies, names contains the names of the 
%   files that have been added, num_images is exactly what you think it is.
%   See notes on pull_po2()
%example batch_pull_po('C:\Documents and Settings\computation\Desktop\testfolder', 64, 256, 10)

%%
f = warndlg('The entire folder will be added to the workspace.  Be sure only the neccesary files are in the folder.','Caution: This may take awhile');
waitfor(f);
pause(.01);

cd(path);
strut = dir('*.txt');
len = length(strut);

%% time warning
if (len>=50)
    time = len*0.5;
    f = warndlg(strcat('You have more than 50 items, this could take more than  ', time, ' min'),'Caution');
    waitfor(f);
    pause(.01);
else
end
tic
%% Do the job
master = zeros(vert_res, vert_res, len); % create an array to hold all the matricies
names = cell(1,len); % create an array to hold all the image names
for i = 1:len
    fprintf('Extracting %s \n', strut(i,1).name);
    [a1,a2] = pull_po3(strut(i,1).name, horz_res, tab_iter); %a1 returns with matrix
    a2 = strcat(a2); % a2
    names(i) = a2; % add the name to the cell array 'names'
    master(:,:,i) = a1;
    fprintf('Done\n')
    pause(0.01)
end
num_images = len;
fprintf('\nHey hey! Finished!\n')
fprintf('Returning %d items.\n', len)
toc
fprintf('That''s %d seconds per item.\n', toc/len)
end

