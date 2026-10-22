% plotIQpsd.m - Power spectral density of the IQ slice in this folder.
%
% The flat block filling the middle 240 MHz is the Starlink channel; the outer
% 10 MHz of the 250 MHz sampled is the guard between channels.

close all

[y, meta] = readIQslice;

pwelch(y, hann(4096), [], 4096, meta.Fs, 'centered')
