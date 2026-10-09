% bigDishPSD.m
%
% Compute the power spectrum of the Stanford "big dish" data


clear; clc;
%% Setup
fs = 46.08e6;    % Sampling frequency (Hz)
nfft = 2^10;     % Size of FFT used in power spectrum estimation

%% Load data
load(['prn31_22apr03_01hrs40min00sec_gmt_fl1_46_08mhz_250msec.mat']);

%% Compute power spectrum estimate
% Here we invoke Matlab's implementation of Welch's power spectral density
% estimate to obtain Syy, the PSD of the input complex data Y.  We use a
% Hanning window of length nfft, the default 50% overlap between segments,
% nfft discrete Fourier transform (DFT) points, and we indicate that the
% sampling frequency for Y is fs.
[Syy,fVec] = pwelch(Y,hann(nfft),[],nfft,fs);

%% Plot results
yLow = -180;
yHigh = -130;
T = nfft/fs;
delf = 1/T;
fcenter = (nfft/2)*delf;
fVec = fVec - fcenter;
Syy = [Syy(nfft/2 + 1 : end); Syy(1:nfft/2)];
area(fVec/1e6,10*log10(Syy),yLow);
ylim([yLow,yHigh]);
grid on;
shg;
xlabel('Frequency (MHz)');
ylabel('Power density (dB/Hz)');
title('Power spectral density estimate of GPS L1 Signal');
shg;
