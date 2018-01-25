%% DopplerMS2Hz

% converts input doppler shifts in m/s to hz
% assumes GPS L1 carrier to be the incoming frequency

function[doppler_hz] = DopplerMS2Hz(doppler_ms)

freq_f0 = 10.23e6; %GPS oscillator freq
freq_l1 = 154*freq_f0 ; %GPS L1 signal freq
lambda_l1 = physconst('lightspeed')/freq_l1; %GPS L1 signal wavelength

doppler_hz = doppler_ms/lambda_l1; %doppler shift in hertz


end
