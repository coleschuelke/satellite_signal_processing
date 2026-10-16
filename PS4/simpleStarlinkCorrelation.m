clear all; clc;

%% Read in the raw IQ data
[rVec, meta] = readIQslice;

%% Resample the data at sl.Fs
sl = starlinkConstants();
tVec = (0:length(rVec)-1)'/meta.Fs;
[rVec, tVec] = resample(rVec,tVec,sl.Fs);
Nr = length(rVec);

%% Frequency shift the signal
% The center frequency of the ith Starlink channel is given by Fci = 10.7 +
% F/2 + 0.25(i-1/2), in GHz.  Frequency shift the original captured data to
% account for the difference between Fci and center frequency of the
% captured data, which is meta.Fc.
channel = round((meta.Fc/1e9 - sl.F0/1e9 - sl.F/2/1e9)/0.25 + 0.5);
Fchannel = (sl.F0 + sl.F/2 + sl.Fdelta*(channel - 0.5));
fShift0 = meta.Fc - Fchannel;
rVec = rVec.*exp(1j*2*pi*fShift0*tVec);

%% Generate a local replica based on the PSS and SSS
[sssTime, sssFreq] = genSss();
pssTime = genPss();
localReplica = [pssTime; sssTime];

%% Correlate signal in rVec against local replica
[CrVec, lagVec] = xcorr(rVec, localReplica);

%% Plot the correlation function
figure(1);clf;
CrVec = CrVec(Nr:end);
lagVec = lagVec(Nr:end);
plot(1e3*lagVec/sl.Fs, 10*log10(abs(CrVec)));
xlabel('Time (ms)');
ylabel('C_r (dB)');
grid on;
ylim([45,70]);
