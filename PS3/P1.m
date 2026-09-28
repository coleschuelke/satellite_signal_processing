clear variables;
close all;
clc;

% Total Power
tp = pi;

Sx = @(f) (sinc(f).^2);

Sx_main = integral(Sx, -1, 1)

Sx_side = integral(Sx, -2, 2)