% reconstruction.m
%
% Studying the effects of different techniques for analog signal
% reconstruction from digital samples.

clear;clc;
%% Setup
% Analog signal sampling interval (s)
Ta = 1e-4;
% Bandwidth of analog signal (Hz)
W = 8;
% Bandwidth of hypothetical ideal filter used for reconstruction
Wprime = 1.25*W;
% Digital signal sampling interval (s)
T = 1/(2*Wprime);
% Duration of signal (s)
Td = 100;

%% Generate a random analog signal with bandwidth W
Nxa = ceil(Td/Ta);
% Generate unfiltered random analog signal
xau = randn(Nxa,1);
% Low-pass filter xau to produce xa
Fs = 1/Ta;
order = 6;
Wn = W/(Fs/2);
[bVec,aVec]=butter(order, Wn, 'low');
xa = filter(bVec,aVec,xau);

%% Examine the analog signal's time-domain representation
figure(1); clf;
subplot(311)
txa = [0:Nxa-1]'*Ta;
plot(txa,xa);
xlabel('Time (s)');
ylabel('$x_a$','Interpreter', 'latex', 'Fontsize', 14);
ylim(0.2*[-1,1]);

%% Examine the analog signal's power spectrum
Nfft = floor(Nxa/50);
[Sx,fVec] = pwelch(xa,kaiser(Nfft,3),Nfft/2,Nfft,Fs,'psd','centered');
% Normalize so that passband appears near 0 dB/Hz
Sx = Sx/Ta;
figure(2);clf;
plot(fVec,10*log10(Sx));
grid on;
xlabel('Frequency (Hz)');
ylabel('(dB/Hz)');
title('Normalized power spectral density $S_x(f)$', ...
      'Interpreter', 'latex','Fontsize', 14);
xlim([-30 30]);

%% Sample the analog signal
Nx = ceil(Td/T);
tx = [0:Nx-1]'*T;
x = interp1(txa,xa,tx,'linear');

%% Examine the digital signal's time-domain representation
figure(1); 
subplot(312)
plot(tx,x);
xlabel('Time (s)');
ylabel('$x$','Interpreter', 'latex','Fontsize', 14);
ylim(0.2*[-1,1]);

%% Reconstruct the analog signal from the digital signal
% Discard Ndiscard samples from the beginning and end of the analog signal to
% avoid edge effects.
Ndiscard = floor(Nxa/10);
xar_indices = [Ndiscard + 1 : Nxa - Ndiscard + 1]';
% Generate the time points for the reconstructed analog signal
txar = txa(xar_indices);
% Reconstruct the analog signal
distortion_avg = 0;
for k=1:10
    xar = zeros(size(txar));
    for n=1:length(x)
        xar = xar + 2*Wprime*T*x(n)*sinc(2*Wprime*(txar-tx(n)));
    end
    dx = xar - xa(xar_indices);
    distortion_avg = distortion_avg + rms(dx);
end
distortion_avg = distortion_avg * 100 / 10
%
% EEE: Experiment here with different reconstruction techniques
% xar = interp1(tx,x,txar,'previous');

figure(1);
subplot(313)
plot(txar,xar);
xlabel('Time (s)');
ylabel('$x_ar$','Interpreter', 'latex', 'Fontsize', 14);
ylim(0.2*[-1,1]);

% %% Measure the distortion of the reconstructed signal
% dx = xar - xa(xar_indices);
% distortion = rms(dx);
% fprintf('Distortion metric: %5.3f\n', 100*distortion);
