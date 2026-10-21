function [pssTimeDomainVec] = genPss()
% genPss : Generates the Starlink Ku-band downlink primary synchronization sequence
% (PSS).
%
%
% OUTPUTS
%
% pssTimeDomainVec ------ (N + Ng)-by-1 PSS
%
%+==============================================================================+%

sl = starlinkConstants();

hex_str = 'C1B5D191024D3DC3F8EC52FAA16F3958';
q_pss = java.math.BigInteger(hex_str, 16);


l = 0:(sl.N / 8 - 1);

bits = arrayfun(@(idx) double(q_pss.testBit(idx)), l);

b_l = 2 * bits - 1;

k_prime = 0:(sl.N/8-1);

s_k = arrayfun(@(k) sum(b_l(1:k+1)), k_prime);

p_k = exp(1j*pi*(-.25-.5*s_k));

cyc_prefix = p_k(sl.N/8-sl.Ng+1:end);

pssTimeDomainVec = [-cyc_prefix.'; -p_k.'; p_k.'; p_k.'; p_k.'; p_k.'; p_k.'; p_k.'; p_k.'];