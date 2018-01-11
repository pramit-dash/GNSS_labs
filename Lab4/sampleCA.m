% Description: Generate C/A Gold code sampled by ADC sequence for any PRN (1-32)
% Inputs: 
%       PRN - PRN  in ranage from 1 to 32,
%       Ts - sampling interval [sec]
% Output : sampled_code  [n_samples x 1] - Sampled C/A Gold code sequence
% Requirement: ca.m code



function [sampled_CA] = sampleCA(PRN, Ts)
fs = 1/Ts;            % sampling frequency [Hz]
Tp_CA = 0.001;        % time period of C/A code = 1 msec 
n_samples = fs * Tp_CA;     % #samples in 1ms with fs sampling freq
n_samples = fix(n_samples);

sampled_CA = zeros(n_samples,1);


    if (PRN < 1 || PRN > 32)  
        disp ('invalid PRN. PRN value must be between 1 and 32')
    else
        
    % Generate C/A code
    ca_code = ca(PRN);
    % change from -1/+1 to  0/1 for easier rounding after resampling
    ca_code(ca_code == -1) = 0;
    
    % Resample C/A code 
    sampled_CA = resample(ca_code, n_samples, 1023); % resample from 1023 to fs Hz
    sampled_CA = round(sampled_CA);
    sampled_CA(sampled_CA >  1) = 1;
    sampled_CA(sampled_CA <= 0) = 0;
    
    sampled_CA(sampled_CA == 0) = -1; % change  0/1 -> -1/+1
       
    end 
end