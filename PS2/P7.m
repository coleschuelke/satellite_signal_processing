clear variables; 
close all; 
clc;


%----- Setup
Tfull = 0.5; % Time interval of data to load
fsampIQ = 5.0e6; % IQ sampling frequency (Hz)
t = linspace(0, Tfull, fsampIQ*Tfull);
N = floor(fsampIQ*Tfull);
nfft = 2^9; % Size of FFT used in power spectrum estimation
%----- Load data
fid = fopen('niData01head_5MHz.bin','r','l');
Y = fread(fid, [2,N], 'int16')';
Y = Y(:,1) + j*Y(:,2);
fclose(fid);

[pxx_orig, f_orig] = pwelch(Y, [], [], [], fsampIQ, "twosided");

Y_IF = iq2if(real(Y), imag(Y), 1/fsampIQ, 2.5e6);
[pxx_up, f_up] = pwelch(Y_IF, [], [], [], fsampIQ);

Ybase = if2iq(Y_IF, 1/fsampIQ, 2.5e6);
[pxx_down, f_down] = pwelch(Ybase, [], [], [], fsampIQ);

figure;
plot(t, abs(Y));

figure;
hold on;
plot(f_orig, abs(pxx_orig));
xline(0, 'r--');

figure;
hold on;
plot(f_up, pxx_up);
xline(2.5e6, 'r--');

figure;
hold on;
plot(f_down, pxx_down);
xline(0, 'r--');