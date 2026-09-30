clear variables; 
close all; 
clc;

addpath("../Functions/");

%----- Setup
Tfull = 0.5; % Time interval of data to load
fsampIQ = 10.0e6; % IQ sampling frequency (Hz)
t = linspace(0, Tfull, fsampIQ*Tfull);
N = floor(fsampIQ*Tfull);
nfft = 2^9; % Size of FFT used in power spectrum estimation
%----- Load data
fid = fopen('niData03head_10MHz.bin','r','l');
Y = fread(fid, [2,N], 'int16')';
Y = Y(:,1) + j*Y(:,2);
fclose(fid);

[pxx_orig, f_orig] = pwelch(Y, [], [], nfft, fsampIQ, 'centered');

Y_IF = sqrt(2) * iq2if(real(Y), imag(Y), 1/fsampIQ, 5e6);
[pxx_up, f_up] = pwelch(Y_IF, [], [], nfft, 2*fsampIQ, 'one-sided');

[YbaseI, YbaseQ] = if2iq(Y_IF, 1/(2*fsampIQ), 5e6);
Ybase = sqrt(2) * (YbaseI + YbaseQ);
[pxx_down, f_down] = pwelch(Ybase, [], [], nfft, fsampIQ, 'centered');

figure;
plot(t, abs(Y));
title("Time Domain");

figure;
hold on;
plot(f_orig, 10*log10(abs(pxx_orig)));
xline(0, 'r--');
title("Original Signal Power Spectrum");
xlabel("Frequency (Hz)");
ylabel("Power Density (W/Hz)");
ylim([-100, 0]);

figure;
hold on;
plot(f_up, 10*log10(pxx_up));
xline(5e6, 'r--');
title("Upconverted Signal Power Spectrum");
xlabel("Frequency (Hz)");
ylabel("Power Density (W/Hz)");
ylim([-100, 0]);

figure;
hold on;
plot(f_down, 10*log10(pxx_down));
xline(0, 'r--');
title("Downconverted Signal Power Spectrum");
xlabel("Frequency (Hz)");
ylabel("Power Density (W/Hz)");
ylim([-100, 0]);