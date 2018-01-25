%% Navigation Labs
% Main Script
% Date: 21.01.2018
% Authors:Özge, Xanthi, Pramit
%% 1. Initialization
clc; clear; close all;
%Read F40
% tic
% F40=importF40matrix('Data\GNSSlab_B_maybe.txt');
% % toc
% % % Read F80
% % tic
% F80= importF80matrix('Data\GNSSlab_B_maybe.txt');
% toc
% % Read F62
% tic
% F62 = importF62('Data\GNSSlab_B_maybe.txt');
% toc
% 
% F62=F62(:,[1:13 15:79]);

load('F40');
load('F80');
load('F62');
%% 2. Histogram
Tracked_Sat=F40(:,12);
figure;
histogram(Tracked_Sat)
title ('The Total Amount of Number of Tracked Satellites ')
xlabel('Number of Satellites')
ylabel('Number of Occurance')
figure;
histogram(Tracked_Sat(22:8270))
title ('Number of Tracked Satellites- Period 1 ')
xlabel('Number of Satellites')
ylabel('Number of Occurance')
figure;
histogram(Tracked_Sat(8271:end))
title ('Number of Tracked Satellites- Period 2 ')
xlabel('Number of Satellites')
ylabel('Number of Occurance')
%% 3. Signal Dynamics 
%------------------------- Range Rate -------------------------------------
RangeRate=F62(:,9:6:end);
RangeRate(RangeRate==0)=NaN;
PRN=F62(:,6:6:end-1);

%-------------- Calculate LOS acceleration---------------------------------
LOS=diff(RangeRate);
LOS(2544,8)=NaN;
LOS(4831,10)=NaN;
LOS(2543,8)=NaN;
LOS(4830,10)=NaN;
JerkVal=diff(LOS);
%% RTN
Pos_40_new=F40(:,5:7);
Pos_40_new(Pos_40_new==0)=NaN;
Vel_40_new=F40(:,8:10);
Vel_40_new(Vel_40_new==0)=NaN;

Pos_80_new1=F80(:,5:7);
Pos_80_new1(Pos_80_new1==0)=NaN;
Vel_80_new=F80(:,8:10);
Vel_80_new(Vel_80_new==0)=NaN;

timestamps_80=F80(:,3);
timestamps_80(Pos_80_new1==0)=NaN;

timestamps_40=F40(:,3);
timestamps_40(Pos_40_new==0)=NaN;

omega=[0; 0; 2*pi/86164];
%v_prime = Vel_40_new + cross(omega,Pos_40_new); %???? cross product?

% ------------------------------- F40 -------------------------------------
for i=1:length(Pos_40_new)
    r_i = Pos_40_new(i,:);
    v_i = Vel_40_new(i,:);
    v_prime = v_i + cross(omega,r_i); %???? cross product?
    eR = r_i/norm(r_i);
    eN = cross(r_i,v_prime)/norm(cross(r_i,v_prime));
    eT = cross(eN,eR);
    rRTN_40(i,:) = eR.*r_i+eT.*r_i+eN.*r_i;
    vRTN_40(i,:) = eR.*v_i+eT.*v_i+eN.*v_i;
end

% ------------------------------- F80 -------------------------------------
for i=1:length(Pos_80_new1)
    r_i = Pos_80_new1(i,:);
    v_i = Vel_80_new(i,:);
    v_prime = v_i + cross(omega,r_i); %???? cross product?
    eR = r_i/norm(r_i);
    eN = cross(r_i,v_prime)/norm(cross(r_i,v_prime));
    eT = cross(eN,eR);
    rRTN_80(i,:) = eR.*r_i+eT.*r_i+eN.*r_i;
    vRTN_80(i,:) = eR.*v_i+eT.*v_i+eN.*v_i;
end

% -------------------- Position Error in RTN ------------------------------
[ ~, ix40, ix80] = intersect(timestamps_40, timestamps_80);
Pos_Error_RTN = rRTN_80(ix80,:) - rRTN_40(ix40,:);
figure(13)
plot(timestamps_80(ix80),Pos_Error_RTN); hold on;
title('Position Error in RTN')
xlabel('GPS time')
ylabel('Position Error (m)')
legend('Radial','Tangential','Normal')
grid on
% -------------------- Velocity Error in RTN ------------------------------
Vel_Error_RTN = vRTN_80(ix80,:) - vRTN_40(ix40,:);
figure(14)
plot(timestamps_80(ix80),Vel_Error_RTN); hold on;
title('Velocity Error in RTN')
xlabel('GPS time')
ylabel('Velocity Error (m/s)')
legend('Radial','Tangential','Normal')
grid on
%% 6. Code Carrier Divergence
% Elevation
timestamps_62=F62(:,3);
timestamps_80=F80(:,3);
[ ~, i80, i62] = intersect(timestamps_80, timestamps_62);
F62_1=F62(i62,:);
F80_1=F80(i80,:);
Pseudorange=F62_1(:,7:6:end-1);
Pseudorange(Pseudorange==0)=NaN;
Pos_80_new1=F80_1(:,5:7);
PRN_1=F62_1(:,6:6:end-1);
CN0=F62_1(:,10:6:end);

id=find(PRN_1(:,4)==5);
id=id(11:end);
rho=Pseudorange(id,4);
rLEO=(Pos_80_new1(id,1).^2+Pos_80_new1(id,2).^2+Pos_80_new1(id,3).^2);
z=acosd((rLEO+rho.^2-20200000^2)./ (2*sqrt(rLEO).*rho));
E=90-z;
figure
yyaxis left; plot(timestamps_62(id),E);  ylabel('Elevation [degrees]');
yyaxis right; plot(timestamps_62(id),CN0(id)); ylabel('C/N_0 [dB-Hz]');
title('Elevation of Channel-4 PRN-5'); grid on;
%
%Code -Carrier

% Calculate wavelengths of the carrier frequencies L1 and L2
Phase=F62_1(:,8:6:end-1);
f0=10.23*10^6;%Hz 
f1=154*f0; lambda1=physconst('LightSpeed')/f1; %m
Phase=Phase*lambda1;
phi=Phase(id,4);

figure; subplot(211)
plot(timestamps_62(id),rho);
hold on; plot(timestamps_62(id),phi);

[~, idx]=min(rho);
differ=rho(idx)-phi(idx);
phi_2=phi+differ; grid on; 
legend('Code', 'Phase'); xlabel('GPS Time [c]'); ylabel('[m]')

Delta=rho-phi_2;
subplot(212); plot(timestamps_62(id),Delta);
xlabel('GPS Time [c]'); ylabel('[m]'); grid;

% 
m = 2.037./ (sqrt((sind(E)).^2+0.076)+sind(E));
figure; 
plot(Delta, m); xlabel('Code-Phase [m]'); ylabel('Mapping Function' )
figure; 
plot(timestamps_62(id), m);xlabel('GPS Time [s]'); ylabel('Mapping Function' )
figure; 
plot(E, m);xlabel('Elevation [deg]'); ylabel('Mapping Function' )