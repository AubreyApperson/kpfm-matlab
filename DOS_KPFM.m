% calculate the DOS info from a KPFM voltage bias run

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

%% import data using batch_pull_poX
% Comment out the line below after variables are loaded (assuming workspace
% line below runs only if A, B, or len does not exist to prevent having to
% reimport variables and take up lots of time. Use clearvars to clear all
% variables if necessary.
if (exist('A', 'var')==0) || (exist('B', 'var')==0) || (exist('len', 'var')==0)  % run this code only if A, B, or len does not exist
    [A,B,len] = batch_pull_po_ui3();  
end

%% Find desired point in Data set (A)
V = linspace(V_start,V_end, len); % create array for gate bias
% find data for point A: uses data_std.m file/function

try % grab the data for point A and check to make sure it is inside the data set
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

%disp(Vg_CPD(1:21,:))  % we don't actually need to see the data... comment it out.
%% Calculate DOS
dSP = diff(Vg_CPD(1:n+1,2));
dVg = diff(Vg_CPD(1:n+1,1));
prefactor = C_ox/(d_org*q^2)*(1.6e-10);
DOS = prefactor*(((dSP./dVg).^(-1))-1);

%% Plot Data
scatter(Vg_CPD(1:n,2),DOS,'filled')
title('Plot of DOS??')
%xlabel('')
%ylabel('')
figure
scatter(Vg_CPD(1:n,1),Vg_CPD(1:n,2),'filled')
title('Plot of Normalized Data??') 
%xlabel('')
%ylabel('')