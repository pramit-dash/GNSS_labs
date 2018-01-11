%Ex_4_GNSS_labs main
% v1.0 - GNSS Lab group2, MSc ESPACE, TU Munich
% 8 Jan 2018
clc; clear all; close all;

fs = 16.3676*10^6;     % [Hz]
Ts = 1/fs;             % [sec]
t_k = [0:Ts:0.001-Ts]; % seconds
f_IF = 4.1304 * 10^6;  % [Hz]

n_samples = fix(fs*0.001); %number of samples with fs sampling freq
fid_1 = fopen('Week1979_tow481651.sim', 'rb'); %assign variable to file
fseek(fid_1, 0, 'bof');
input_signal = fread(fid_1, 'int8')';
len_max = length(input_signal)/n_samples;
results_iter = zeros(32,16367,49); %Result of the non-coherent integrations after the iterations


% histogram
    figure(1), grid on
    hold on
    histogram(input_signal,16)
    
for iter = 1:2    % number of non-coherent integrations
    input_signal_iter = input_signal((iter*n_samples-n_samples+1):(iter*n_samples));
    
    x = input_signal_iter';
    Dop_freq = -6000:250:6000; %Doppler freqs to be searched
    DopBins = (Dop_freq(end)-Dop_freq(1))/(Dop_freq(2)-Dop_freq(1))+1; %# of doppler bins = 12K/250 + 1
    results = zeros(32,n_samples,DopBins); %results of FFT-IFFT search will be saved here
    
    %FFT-IFFT
    tic
    for PRN = 1:32

        sampledCAcode = sampleCA(PRN, Ts);
        conjH = conj(fft(sampledCAcode))/n_samples; %fft of Sampled CA code

        resultPRN = zeros(n_samples,DopBins); %results for the current PRN search
        
        i = 0;
        for f_d = Dop_freq
            i = i + 1;       
            carrier_sin = sin(2*pi*(f_IF + f_d)*t_k)';
            carrier_cos = cos(2*pi*(f_IF + f_d)*t_k)';
            I    = x.*carrier_sin; % In-phase component
            Q = x.*carrier_cos; %Quadrature component

            X = fft(complex(I,Q));    %FFT of I+Q
            Z = X.*conjH;   %FFT of incoming signal*FFT of sampled CA code
            z = ifft(Z);  %IFFT

            corr_result = real(z).^2 + imag(z).^2;
            resultPRN(:,i) = corr_result;
        end
        results(PRN,:,:) = resultPRN; %save PRN search result in correspondsing matrix
    end
    proc_time = toc;
    disp(['Iteration #',num2str(iter),' : Processing time = ', num2str(proc_time)])
    
    results_iter = results_iter + results;
end

