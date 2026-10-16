function sl = starlinkConstants()

% starlinkConstants
%
% Constant parameters related to the Starlink Ku-band downlink

% Channel bandwidth (not including channel guard intervals) (Hz).  This
% quantity is also the symbol rate of the serial data (information) sequence
% within the useful symbol interval T. It is also the continuous time-domain
% sample rate, including the cyclic prefix, which implies that N + Ng time
% domain samples nominally span the interval Tsym = T + Tg.
sl.Fs = 240e6;
% Channel spacing (Hz)
sl.Fdelta = 250e6;
% Number of subcarriers in bandwidth Fs, size of FFT/IFFT, number of
% samples at rate Fs in the useful symbol interval. 
sl.N = 1024;
% Duration of OFDM symbol guard interval (cyclic prefix), expressed in
% intervals of 1/Fs.  
sl.Ng = 32;
% Frame rate (Hz)
sl.Ff = 750;
% Frame guard interval (s)
sl.Tfg = 68e-6/15;
% Number of complete nonzero OFDM symbol intervals per frame
sl.Nsf = 302;
% Beginning of Starlink Ku downlink band (Hz)
sl.F0 = 10.7e9;

% Useful (non-cyclic) OFDM symbol interval (s)
sl.T = sl.N/sl.Fs;
% Symbol guard interval (s)
sl.Tg = sl.Ng/sl.Fs;
% OFDM symbol duration including guard interval (s)
sl.Tsym = sl.T + sl.Tg;
% Number of samples per frame
sl.Nspf = sl.Fs/sl.Ff;
% Number of complete OFDM symbol intervals per frame
sl.Nsympf = floor(sl.Nspf/(sl.N + sl.Ng));
% Number of occupied (non-guard) OFDM symbol intervals per frame
sl.Nosympf = sl.Nsympf - 1;
% Frame period (s)
sl.Tf = 1/sl.Ff;
% Subcarrier spacing (Hz)
sl.F = sl.Fs/sl.N;
% Width of guard band between channels (Hz)
sl.Fg = sl.Fdelta - sl.Fs;

% Backward-compatible behavior (assign into base workspace if no output).
if nargout == 0
    assignin('caller', 'sl', sl);
    clear sl  % prevent return to console
end

end