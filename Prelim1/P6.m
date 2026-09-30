% reconstruction.m
%
% Studying the effects of different techniques for analog signal
% reconstruction from digital samples.

clear;clc;
%% Setup
% Whether to run MC
run_monte_carlo = true;
rng(1142);
% Analog signal sampling interval (s)
Ta = 1e-4;
% Duration of signal (s)
Td = 100;
% Interpolation techniques
interp_techs = ["previous", "nearest", "linear", "spline"];
% W'/W values
filter_coeffs = [1, 1.25, 1.5, 2];
% Number of runs over which to average
N_avg = 10;

mc_results = zeros(length(interp_techs),length(filter_coeffs));

for i=1:length(interp_techs);
    for j=1:length(filter_coeffs);
        for k=1:N_avg

            % MC Setup
            % Bandwidth of analog signal (Hz)
            W = 8;
            % Bandwidth of hypothetical ideal filter used for reconstruction
            Wprime = filter_coeffs(j)*W;
            % Digital signal sampling interval (s)
            T = 1/(2*Wprime);

            % Generate a random analog signal with bandwidth W
            Nxa = ceil(Td/Ta);
            % Generate unfiltered random analog signal
            xau = randn(Nxa,1);
            % Low-pass filter xau to produce xa
            Fs = 1/Ta;
            order = 6;
            Wn = W/(Fs/2);
            [bVec,aVec]=butter(order, Wn, 'low');
            xa = filter(bVec,aVec,xau);
            txa = [0:Nxa-1]'*Ta;
            
            % Examine the analog signal's power spectrum
            Nfft = floor(Nxa/50);
            [Sx,fVec] = pwelch(xa,kaiser(Nfft,3),Nfft/2,Nfft,Fs,'psd','centered');
            % Normalize so that passband appears near 0 dB/Hz
            Sx = Sx/Ta;
            
            
            % Sample the analog signal
            Nx = ceil(Td/T);
            tx = [0:Nx-1]'*T;
            x = interp1(txa,xa,tx,'linear');
            
            % Reconstruct the analog signal from the digital signal
            % Discard Ndiscard samples from the beginning and end of the analog signal to
            % avoid edge effects.
            Ndiscard = floor(Nxa/10);
            xar_indices = [Ndiscard + 1 : Nxa - Ndiscard + 1]';
            % Generate the time points for the reconstructed analog signal
            txar = txa(xar_indices);
            % Reconstruct the analog signal
            %
            % EEE: Experiment here with different reconstruction techniques
            xar = interp1(tx,x,txar,interp_techs(i));
            
            % Measure the distortion of the reconstructed signal
            dx = xar - xa(xar_indices);
            distortion = rms(dx);
            mc_results(i, j) = mc_results(i, j) + distortion;
        end
    end
end

mc_results = mc_results * 100 / N_avg;