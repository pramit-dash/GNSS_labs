function C = fftsearch(data, sat_id, fs, fc, n_data)

%Generate CA code
Ts = 1/fs;
CA = sampleCA(sat_id,Ts);
%Time vector
t = (0:(n_data-1))/fs;
%In-phase component
I_comp = cos(2*pi*fc.*t).*data';
%Quadrature component
Q_comp = sin(2*pi*fc.*t).*data';
%FFT of I and Q components
X = fft(I_comp + 1i*Q_comp);
% conj(FFT) of CA code
F_CA = conj(fft(CA));
% Multiply in freq domain and perform IFFT,
% then get the squared magnitude
C = abs(ifft(X.*F_CA)).^2;
end
