%Define Parameters
eps_0 = 8.854e-12;
eps_SiO2 = 3.9;
d_ox = 300e-9;
C_ox = eps_0*eps_SiO2/d_ox;
q = 1.602e-19;
d_org = 8e-9;

n = 8;
%Normalize Data
RawData = p121_28;
Vg_CPD(:,1) = RawData(:,1)-RawData(1,1);
Vg_CPD(:,2) = RawData(:,2)-RawData(1,2);
disp(Vg_CPD(1:21,:))
figure
%Calculate DOS
dSP = diff(Vg_CPD(1:n+1,2));
dVg = diff(Vg_CPD(1:n+1,1));
prefactor = C_ox/(d_org*q^2)*(1.6e-10);
DOS = prefactor*(((dSP./dVg).^(-1))-1);

%Plot Data
scatter(Vg_CPD(1:n,2),DOS,'filled')
figure
scatter(Vg_CPD(1:n,1),Vg_CPD(1:n,2),'filled')