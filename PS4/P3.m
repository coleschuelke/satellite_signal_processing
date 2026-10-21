clear variables; 
close all;
clc;


%% Setup
nStages = 10;                 % Number of stages in LFSR
Tc = 1e-6;                    % Chip interval in seconds
delChip = 3/217;              % Sampling interval in chips
delOffset  = 0;               % Offset of first sample
delt = delChip*Tc;            % Sampling interval in seconds
fs = 1/delt;                  % Sampling frequency in Hz
Np = 2^nStages - 1;           % Period of the sequence in chips
Nr = 20;                      % Number of repetitions of the sequence
Nsp = floor(Np/delChip);      % Number of samples in a period
Ns = round(Nr*Np/delChip);    % Number of samples of the sequence 
Tp = Np*Tc;
delf = 1/(delt*Ns);
Nsep = 1/Tp/delf;

%% Signal generation
% Generate the m-sequences
ciVec1 = [10, 9, 5, 2];
ciVec2 = [10, 9, 8, 6, 3, 2];
a0Vec = [1; zeros(nStages-1, 1)];
X1 = generateLfsrSequence(nStages, ciVec1, a0Vec);
X2 = generateLfsrSequence(nStages, ciVec2, a0Vec);
X1 = 2*X1 - 1;
X2 = 2*X2 - 1;

% Oversample and repeat them 20x 
X1os = oversampleSpreadingCode(X1,delChip,delOffset,Ns,Np);
X2os = oversampleSpreadingCode(X2,delChip,delOffset,Ns,Np);

% Check they look like they should 
figure(1);
subplot(211);
plot(X1os);
subplot(212);
plot(X2os);

%% Compute power spectra
% The scaling here ensures that sum(Si*delf) = 1 W, as expected, for i = 1, 2.
S1 = abs(delt*fft(X1os)).^2/(Ns*delt);
S2 = abs(delt*fft(X2os)).^2/(Ns*delt);
delf = 1/(delt*Ns);
fVec = [0:Ns-1]'*(delf);

% Create the sinc^2 signals 
S1_ideal = zeros(length(fVec), 1);
for k = 1:30
    S1_ideal = S1_ideal + Tc*sinc(Tc*(fVec - k/Tp)).^2;
end


figure(2);clf;
subplot(211)
hold on;
plot(fVec/1e3,10*log10(S1));
plot(fVec/1e3,10*log10(S1_ideal));
grid on;
xlim([0 30]);
ylim([-100,0]);
title('X1 and X2 power spectral densities')
ylabel('S_{X1}(f) (dBW/Hz)');
subplot(212)
plot(fVec/1e3,10*log10(S2));
grid on;
xlim([0 30]);
ylim([-100,0]);
ylabel('S_{X2}(f) (dBW/Hz)');
xlabel('Frequency (kHz)');


figure(3);
plot(fVec/1e3,10*log10(S1_ideal));