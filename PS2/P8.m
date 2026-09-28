clear variables;
close all;
clc;

fL1 = 1575.42;
B = 4;
fH = fL1 + B/2;
fL = fL1 - B/2;

figure;
for k=350:400
    lb = 2*fH/k;
    ub = 2*fL/(k-1);
    xline(lb, 'r');
    xline(ub, 'g');
    if lb > ub
        disp(k)
        break;
    end
end