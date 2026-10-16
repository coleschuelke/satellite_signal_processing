% correlationPrimer.m
%
% A brief primer on correlation of discrete signals 

addpath("..\Functions\");

%% Setup
% Suppose xVec and yVec hold discretely-sampled time histories of two signals.
% At first, we'll assume signals with independent, identically distributed
% Gausian samples.  Later, we'll filter the signals, thereby introducing
% correlation between samples.
nSamps = 100;
xVec = randn(nSamps,1);
yVec = randn(nSamps,1);
% We'll assume the sampling rate is 100 Hz
Fs = 100;

%% Correlate original signals
% We can correlate xVec and yVec against each other (cross-correlation) or
% against themselves (auto-correlation).  We can invoke standard
% correlation via Matlab's built-in xcorr function, or circular correlation
% via the ccorr function.
[Rxx,iixx] = xcorr(xVec,xVec);
[Ryy,iiyy] = xcorr(yVec,yVec);
[Rxy,iixy] = xcorr(xVec,yVec);
[Cxx,kkxx] = ccorr(xVec,xVec);
[Cyy,kkyy] = ccorr(yVec,yVec);
[Cxy,kkxy] = ccorr(xVec,yVec);

%% Plot
% Sampling interval
Ts = 1/Fs;  
figure(1);clf;
subplot(311);
plot(iixx*Ts,Rxx);
ylabel('$R_{xx}(\tau)$', 'interpreter', 'latex', 'FontSize', 12);
title('Standard Auto- and Cross-Correlation of Original Signals')
subplot(312);
plot(iiyy*Ts,Ryy);
ylabel('$R_{yy}(\tau)$', 'interpreter', 'latex', 'FontSize', 12);
subplot(313);
plot(iixy*Ts,Rxy);
ylabel('$R_{xy}(\tau)$', 'interpreter', 'latex', 'FontSize', 12);
xlabel('$\tau$ (s)', 'interpreter', 'latex', 'FontSize', 12);

figure(2);clf;
subplot(311);
plot(kkxx*Ts,Cxx);
ylabel('$C_{xx}(\tau)$', 'interpreter', 'latex', 'FontSize', 12);
title('Circular Auto- and Cross-Correlation of Original Signals')
subplot(312);
plot(kkyy*Ts,Cyy);
ylabel('$C_{yy}(\tau)$', 'interpreter', 'latex', 'FontSize', 12);
subplot(313);
plot(kkxy*Ts,Cxy);
ylabel('$C_{xy}(\tau)$', 'interpreter', 'latex', 'FontSize', 12);
xlabel('$\tau$ (s)', 'interpreter', 'latex', 'FontSize', 12);

clc;
fprintf('Displaying auto- and cross-correlation plots for original signals.\n\n');
fprintf(['Hit any key to view the auto- and cross-correlation plots for the ' ...
         'filtered signals.\n']);
pause();

%% Filter
% Now suppose we low-pass filter xVec and yVec so that their autocorrelation
% functions drop off more gradually.  We will configure a Butterworth filter
% for xVec to pass frequencies below 30 Hz and one for yVec to pass
% frequencies below 10 Hz.  We will apply 8th-order filters to get a clean
% cutoff.
orderFilter = 8;
[B,A] = butter(orderFilter,30/(Fs/2),'low'); 
xVecF = filter(B,A,xVec);
[B,A] = butter(orderFilter,10/(Fs/2),'low'); 
yVecF = filter(B,A,yVec);

%% Correlate filtered signals
% We can correlate xVec and yVec against each other (cross-correlation) or
% against themselves (auto-correlation).  We can invoke standard
% correlation via Matlab's built-in xcorr function, or circular correlation
% via the ccorr function.
[Rxx,iixx] = xcorr(xVecF,xVecF);
[Ryy,iiyy] = xcorr(yVecF,yVecF);
[Rxy,iixy] = xcorr(xVecF,yVecF);
[Cxx,kkxx] = ccorr(xVecF,xVecF);
[Cyy,kkyy] = ccorr(yVecF,yVecF);
[Cxy,kkxy] = ccorr(xVecF,yVecF);

%% Plot
figure(1);clf;
subplot(311);
plot(iixx*Ts,Rxx);
ylabel('$R_{xx}(\tau)$', 'interpreter', 'latex', 'fontsize', 12);
title('Standard Auto- and Cross-Correlation of Filtered Signals')
subplot(312);
plot(iiyy*Ts,Ryy);
ylabel('$R_{yy}(\tau)$', 'interpreter', 'latex', 'FontSize', 12);
subplot(313);
plot(iixy*Ts,Rxy);
ylabel('$R_{xy}(\tau)$', 'interpreter', 'latex', 'FontSize', 12);
xlabel('$\tau$ (s)', 'interpreter', 'latex', 'FontSize', 12);

figure(2);clf;
subplot(311);
plot(kkxx*Ts,Cxx);
ylabel('$C_{xx}(\tau)$', 'interpreter', 'latex', 'FontSize', 12);
title('Circular Auto- and Cross-Correlation of Filtered Signals')
subplot(312);
plot(kkyy*Ts,Cyy);
ylabel('$C_{yy}(\tau)$', 'interpreter', 'latex', 'FontSize', 12);
subplot(313);
plot(kkxy*Ts,Cxy);
ylabel('$C_{xy}(\tau)$', 'interpreter', 'latex', 'FontSize', 12);
xlabel('$\tau$ (s)', 'interpreter', 'latex', 'FontSize', 12);

    