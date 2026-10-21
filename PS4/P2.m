clear;clc;

addpath("..\Functions\");

%% Part (a)
N = 1024;
corr_vec = zeros(10000, 1);
% Generate 10,000 codes
for code=1:10000
    X1 = sign(sign(randn(N,1)) + 0.1);
    X2 = sign(sign(randn(N,1)) + 0.1);
    corr0 = X1.' * X2;
    corr_vec(code) = corr0;
end

fprintf('Variance of 10000 BRS cross correlation values:')
corr = var(corr_vec)

%% Part (b)
% Connection vectors
connections = {
    [10, 7];
    [10, 9, 8, 5];
    [10, 9, 8, 7, 5, 4];
    [10, 9, 8, 7, 6, 5, 4, 3];
    [10, 8, 7, 6, 5, 2];
    [10, 8, 4, 3];
    };
% Params
Np = 10;
M = length(connections);
N = 2^Np - 1;
m_codes = zeros(M, N);
correlation = zeros(M * (M-1)/2, N);


% generate the m-codes
for idx=1:M
    m_codes(idx, :) = generateLfsrSequence(Np, connections{idx, :}, ones(1, Np));
end

% generate the correlations
cross = 1;
for start=1:M-1
    for k=start+1:M
        correlation(cross, :) = ccorr(m_codes(start, :), m_codes(k, :));
        cross = cross + 1;
    end
end

max_corr_lb = N * sqrt((M - 1) / (M*N - 1))

max_corr_min = min(max(correlation, [], 2)) % Technically it's above but it's an order of magnitude too big seemingly

%% Part (c)
