clear variables;
close all;
clc;

addpath("..\Functions\");

lfsr = generateLfsrSequence(10, [1, 3, 4, 8, 9], [0, 1, 1, 0, 0, 0, 1, 0, 1, 1]);