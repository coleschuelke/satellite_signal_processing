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