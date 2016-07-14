function [ master, names, num_images ] = batch_pull_po_ui3()
%batch_pull_po_ui Function Does the same as batch_pull_po but with a UI 
%instead of being all command line
%It extracts a folders .txt data into MatLab using pull_po()
%   See notes on pull_po2(), this is an addition to that that does that for
%   an entire folder and names things appropriately.
%example batch_pull_po('C:\Documents and Settings\computation\Desktop\testfolder', 512, 10)

%%
waitfor(msgbox('The entire folder you select next prompt will be added to the workspace.  Be sure only the neccesary files are in the folder.','Caution: This may take awhile'));
pause(.01);

% ui input for path
k = 1;
while k >= 1
    [FileName,path] = uigetfile('*.txt','Select a file inside the folder which contains the .txt igor files.');
    if k ==2  %provide an early termination path
        fprintf('Alright.  Exiting requested fucntion.\n')
        return
    elseif FileName == 0
       f = errordlg('You have to select a file in a folder...  It doesn''t matter which file inside the folder you pick, the file path is all I care about.','Hey now...');
       waitfor(f);
       k =k+1;
    else break;
    end
end

x = inputdlg('What tab in Igor was the Potential data on?', 'Tab in Igor', [1,40], {'10'});
tab_iter = str2double(x); 

x = inputdlg(sprintf('You may have to go back and check the file in Igor. \n1. Open the file in igor (full AFM version)\n2. In the window of height trace, click on the "N" \n3. Report the number under "ScanLines"'), 'Igor Lines', [1,40], {'64'});
vert_res = str2double(x); 

x = inputdlg(sprintf('You may have to go back and check the file in Igor. \n1. Open the file in igor (full AFM version)\n2. In the window of height trace, click on the "N" \n3. Report the number under "ScanPoints"'), 'Igor Points', [1,40], {'256'});
horz_res = str2double(x); 

clear vars x
% we are now finished grabbing the inputs
%% 
cd(path);
strut = dir('*.txt');
len = length(strut);


%% time warning
if (len>=50)
    time = len*0.5;
    f = warndlg(strcat('You have more than 50 items, this could take more than  ', num2str(time), ' min at 0.5 seconds per item.'),'Caution');
    waitfor(f);
    pause(.01);
else
end
tic
%% Do the job
master = zeros(horz_res, vert_res, len); % create an array to hold all the matricies
names = cell(1,len); % create an array to hold all the image names
for i = 1:len
    fprintf('Extracting %s \n', strut(i,1).name);
    [a1,a2] = pull_po3(strut(i,1).name, horz_res, tab_iter); %a1 returns with matrix
    a2 = strcat(a2);
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

