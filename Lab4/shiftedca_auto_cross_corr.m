clc; clear all; close all;
% Verify autocorrelation and cross-correlation properties of CA PRN code

%% Get CA codes for sats PRN 1 and 2
% uses ca.m code
CA1 = ca(1); %CA code for PRN1 GPS satellite
CA2 = ca(2); %CA code for PRN2 GPS satellite
figure(1); hold on;
subplot(2,1,1);
plot(CA1); title('CA Code PRN1');
grid on; xlabel('code bits'); ylabel('CA code value');
subplot(2,1,2);
plot(CA2); title('CA Code PRN2');
grid on; xlabel('code bits'); ylabel('CA code value');



%% Autocorrelation function of PRN1


for shift=0:1022
    shifted_code_CA1= circshift(CA1,shift); %shift PRN1 CA code
    autocorr_1(shift+1) = (CA1'*shifted_code_CA1)./1023; %calculate autcorrelation function    
end

figure(2); hold on;
plot(autocorr_1); 
title('Autocorrelation of PRN1');
xlim([-100 1024]);
xlabel('Shifts');
ylabel('Autocorrelation values');
grid on;
hold off;

%% Cross-correlation function of PRN1 and PRN2


for shift=0:1022
    shifted_code_CA1 = circshift(CA1,shift); %shift PRN1 CA code
    crosscorr_12(shift+1) = (CA2'*shifted_code_CA1)./1023; %calculate cross-correlation function
end

figure(3); hold on;
plot(crosscorr_12);
xlim([-100 1024]);
grid on;
xlabel('shifts');ylabel('Correlation values');
title('Cross-correlations of PRN1 and PRN2 codes');
hold off;