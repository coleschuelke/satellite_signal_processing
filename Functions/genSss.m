function [sssTimeDomainVec, sssFreqDomainVec] = genSss()
% genSss : Generates the Starlink Ku-band downlink secondary synchronization
% sequence (SSS).
%
%
% OUTPUTS
%
% sssTimeDomainVec ----- (N + Ng)-by-1 SSS expressed in the time domain with a
% length-Ng cyclic prefix, scaled such that the norm
% squared of the N-by-1 time domain vector before
% cyclic prefix pre-pending is N - 4. Such scaling,
% which accounts for the absent modulation in the
% 4-subcarrier mid-channel gutter, ensures that the
% magnitude of the SSS produced by this function is
% commensurate with that of the the PSS produced by
% genPss.
%
% sssFreqDomainVec ----- N-by-1 SSS expressed in the frequency domain with
% QPSK symbols (aligned along real and imaginary axes)
% having unit coordinates.
%
%+==============================================================================+%

sl = starlinkConstants();

hex_str = ['BD565D5064E9B3A94958F28624DED5' ...
    '60946199F5B40F0E4FB5EFCB473B4C24' ...
    'B2D1E0BD01A6A04D5017DE91A8ECC0DA' ...
    '09EBFE57F9F1B44C532F161C583A4249' ...
    '0A5C09F2A117F9A28F9B2FD547A74C44' ...
    'BABB4BE85DA6A62B1235E2AD084C0018' ...
    '0142A8F7F357DEC4F31316BC58FA4049' ...
    '09A3FCA7F88E421902B6A2580AE80308' ...
    '03F65809DB347F590DBC46F010EBE3A2' ...
    '5C060D74429FC46BDF9B63719279798D' ...
    '232C5ABA274122FF66AD7E449F44CB40' ...
    'C49C24A1E2629F5BFE82CE531FDC34F8' ...
    'C64A43A963F40D5B71BDE6FB2F13492D' ...
    '6F2E8544B21D449722C635180342CD00' ...
    '26A1E7F7E80E91B175E852F919767E5A' ...
    'F9B6E909AF362F5218E2B908DC005803'];

q_sss = java.math.BigInteger(hex_str, 16);

k = 0:(sl.N-1);

mask = java.math.BigInteger('3');
s_k = arrayfun(@(k) double(q_sss.shiftRight(2*k-4).and(mask).intValue()), k);
theta_k = s_k * pi/2;
mask = [0, 0, ones(1, sl.N-4), 0, 0];
X_m1k = exp(1j*theta_k).*mask;

X_m1k_time = sqrt(sl.N - 4) * ifft(X_m1k).';

sssTimeDomainVec = [X_m1k_time(sl.N-sl.Ng+1:end); X_m1k_time];
sssFreqDomainVec = X_m1k.';