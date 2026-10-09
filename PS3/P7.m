clear variables; 
close all;
clc;

%% Setup
fs = 46.08e6;    % Sampling frequency (Hz)
nfft = 2^10;     % Size of FFT used in power spectrum estimation

start_idx = 10000;
n_samps = 400;
phase_rotation = -50;
t_vec = 0:n_samps;
t_vec = t_vec * 1/fs * 10^6; % time in microseconds

y_amp = 1.3;
c_amp = 0.95;

ratio = c_amp/y_amp

load(['prn31_22apr03_01hrs40min00sec_gmt_fl1_46_08mhz_250msec.mat']);

Y_look = Y(start_idx:start_idx+n_samps) * exp(j*deg2rad(phase_rotation));

figure;
plot(real(Y_look), imag(Y_look), 'b.');
xline(0, "k--", "alpha", 0.3);
yline(0, "k--", "alpha", 0.3);
xline([-c_amp, c_amp]*1e-4, "m-.", "alpha", 0.5);
yline([-y_amp, y_amp]*1e-4, "m-.", "alpha", 0.5);

figure;
subplot(211);
plot(t_vec, real(Y_look));
title("P(Y)");
subplot(212);
plot(t_vec, imag(Y_look));
title("C/A");
xlabel("Time (us)")