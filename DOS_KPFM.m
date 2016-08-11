% calculate the DOS info from a KPFM voltage bias run
% prgram will load necessary files from igor .txt files
% This work supported by NSF Career Award DMR -1056861.

clearvars -except A B len % reset all variables except A, B, and len
close all % close any open plots

%% Define Parameters
eps_0 = 8.854e-12;
eps_SiO2 = 3.9;
d_ox = 300e-9;
C_ox = eps_0*eps_SiO2/d_ox;
q = 1.602e-19;
d_org = 8e-9;

n = 8;
% additional info
pointAx = 64;  %point to be monitored
pointAy = 5;
square = 1;  % average the point A with sides of length "square" w/ the point in the upper left
V_start = 10; % starting voltage in kpfm sweep
V_end = -100;
name_output = 'datapointA';

%% import data using batch_pull_poX
% line below runs only if A, B, or len does not exist to prevent having to
% reimport variables and take up lots of time. Use clearvars to clear all
% variables if necessary.
if (exist('A', 'var')==0) || (exist('B', 'var')==0) || (exist('len', 'var')==0)  % run this code only if A, B, or len does not exist
    [A,B,len] = batch_pull_po_ui();  
end

%% Find desired point in Data set (A)
V = linspace(V_start,V_end, len); % create array for gate bias
% find data for point A: uses data_std.m file/function

try % grab the data for point A (out of the A matrix) and check to make sure it is inside the data set
    [dataA, stdA] = data_std(A, square, len, pointAx, pointAy);
catch ME
    if (strcmp(ME.identifier,'MATLAB:badsubscript')) % catch an error and suggest to the user the cause
        k = size(A);
        f = errordlg({['The point entered for A appears to be out of the range of the matrix of aquired data.  Reduce this (x =' num2str(pointAx) ',y =' num2str(pointAy) ' ) coordinate to be inside the (scanlines = ' num2str(k(1)) ', scanpoints = ' num2str(k(2)) ') range.'],  ['Note: range may also be exceeded when doing square averaging.']}, 'Error: Point A Out of Range');
        waitfor(f)
        clear vars k
    end
    rethrow(ME)
end

%% Normalize Data
Vg_CPD(:,1) = V; % correct names to confirm
Vg_CPD(:,2) = dataA;

%disp(Vg_CPD(1:21,:))  % we don't actually need to see the data?... commented out.
%% Calculate DOS
dSP = diff(Vg_CPD(1:n+1,2));
dVg = diff(Vg_CPD(1:n+1,1));
prefactor = C_ox/(d_org*q^2)*(1.6e-10);
DOS = prefactor*(((dSP./dVg).^(-1))-1);

%% Plot Data
%set(gca, 'fontsize', 15) %change font size if necessary
scatter(Vg_CPD(1:n,2),DOS,'filled')
title('Plot of DOS??')
%xlabel('')
%ylabel('')
figure
scatter(Vg_CPD(1:n,1),Vg_CPD(1:n,2),'filled')
title('Plot of Normalized Data??') 
%xlabel('')
%ylabel('')

%% Output to file
% create file name
%NOTE: Output file will save beside this file (in whatever directory we are
%currently in)
%To output to a new directory, uncomment and change the following line to
%the requested folder path
cd('C:\Documents and Settings\computation\Desktop')
name_output = strcat(name_output, '.rtf'); %technically .txt but using rtf to differentiate from imported data
fprintf('Output file going to \n %s\\%s \n', pwd, name_output) 

fid=fopen(name_output,'a'); % open/create file with w=(over)write permission a=append permission
fprintf(fid, 'This is surface potential data for position (%3.0f,%3.0f)', [pointAx pointAy]);
fprintf(fid, [ '\ngate bias' '\t' 'surface potential' '\t' 'standard deviation (for square averaging)' '\n']);
for i = 1:n % if you want all the data points, change 'n' to 'len'
    fprintf(fid, '%3.3f \t %3.20f \t %3.5f \n', [V(i) dataA(i) stdA(i)]);
end
fclose(fid);  % close the file from memory
