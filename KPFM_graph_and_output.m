%  Outputs the data for a position point (x,y) 
close all % figures
try
    %[A,B,len] = batch_pull_po3('C:\Documents and Settings\computation\Desktop\160711\output', 64, 256, 10); % commandline version
    %[A,B,len] = batch_pull_po_ui3();  % interactive version
catch ME
    if (strcmp(ME.identifier,'MATLAB:load:numColumnsNotSame')) % catch an error and suggest to the user the cause
    %f = errordlg('You may have already run this program and left a .txt file that is not from igor in the target folder. Remove this file and re-run the program.', 'Error in batch_pull_xxx');
    f = errordlg('There appears to be a .txt igor file with an inconsistent number of columns.  Make sure all the tune igor files have been removed.  Also, verify all data was taken at the same resolution. Remove all files that do not conform to this and re-run the program.', 'Error in batch_pull_xxx');
    waitfor(f)
    rethrow(ME)
    end
end
% Exit this program if batch_pull was terminated early
if exist('A', 'var') ==0
    return
end
  
%% Declare Parameters Block
%Use gui? Fill param if no
gui = 1; % 0 is no, 1 is yes, values below will be ignored if yes.

V_start = 10; % gate bias params
V_end = -10;

pointAx = 1; % point to monitor
pointAy = 1;
pointBx = 1;
pointBy = 1;

plots = 0;
name_output = 'default_output'; % name of output file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% gui
if gui ==1
    prompt = {'Enter the KPFM starting voltage:','Enter KPFM ending voltage:', 'Enter the x position of point A that will be monitored:', 'Enter the y position of point A that will be monitored:', 'Enter the x position of a second point to monitor:', 'Enter the y position of a second point to monitor:', 'Do you want to see the graph?', 'What should the output file be called?'};
    dlg_title = 'Input Required';
    num_lines = [1,40];
    defaultans = {'-10','-110','32','40','150','40', 'y', 'default_output'};
    answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
    pause(.05)
    
    % convert answers and add to workspace
    V_start = str2double(answer(1));
    V_end = str2double(answer(2));
    pointAx = str2double(answer(3));
    pointAy = str2double(answer(4));
    pointBx = str2double(answer(5));
    pointBy = str2double(answer(6));
    plots = strjoin(answer(7));
    if strcmpi(plots,'y') || strcmpi(plots,'yes')
        plots = 1;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Do Not edit under this line
V = linspace(V_start,V_end,len); % create array for gate bias

% Create array for data from pointA
dataA = zeros(1,len); 
for i = 1:len
    dataA(i) = A(pointAx, pointAy, i);
end

dataB = zeros(1,len);
for i = 1:len
    dataB(i) = A(pointBx, pointBy, i);
end

if plots ==1 % plot points A and B
    % Plot Point A
    figure
    plot(V, dataA, '-')
    set(gca, 'fontsize', 13)  % change the font size to 16
    %set(gca,'xdir','reverse') % tell the x-axis to count down instead of up
    xlabel('Gate Bias (Volts)')
    ylabel('Surface Potential (Volts)')
    title('KPFM \alpha-6T on HMDS on 300nm SiO_2')
    
    % Plot Point B
    hold on
    plot(V,dataB, '-m')
    legend(['(x=', num2str(pointAx),', y=', num2str(pointAy), ')'], ['(x=', num2str(pointBx),', y=', num2str(pointBy), ')'], 'Location', 'southwest')
end

%% Output to file
% create file name
name_output = strcat(name_output, '.rtf');

fid=fopen(name_output,'w'); % open/create file
fprintf(fid, 'This is surface potential data for position (%3.0f,%3.0f)', [pointAx pointAy]);
fprintf(fid, [ '\ngate bias' '\t' 'surface potential' '\n']);
for i = 1:len
    fprintf(fid, '%3.3f \t %3.20f \n', [V(i) dataA(i)]);
end
fclose(fid);

