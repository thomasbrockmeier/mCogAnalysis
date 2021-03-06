function [ mu, sd, n, zAvg ] = descriptives( input )
% Get descriptive statistics from data.

nPairs = size(input, 2);
mu = zeros(1, nPairs);
sd = zeros(1, nPairs);
n = zeros(1, nPairs);
zAvg = zeros(1, nPairs);

for i = 1:nPairs
    pairData = input(:, i);
    
    % Remove NaN values.
    pairData = pairData(~isnan(pairData));
    
    mu(i) = mean(pairData);
    sd(i) = std(pairData);
    n(i) = sum(~isnan(pairData));
    zAvg(i) = mean(zscore(pairData));
    
end








end