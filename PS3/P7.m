clear variables;
close all;
clc;

% Create a long RBS
seq = randi([0, 1], 2^14, 1);
bit_rate = 1e6; % Assumed
f_s = 15.5e6; % 15.5 samples per bit

T = length(seq) / bit_rate;
N_s = floor(T * f_s);
t_samp = (0:N_s -1) / f_s;
bit_sample = min(floor(t_samp * bit_rate) + 1, length(seq));

samp = seq(bit_sample);

pwelch(samp)
