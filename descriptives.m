function [ mu, sd ] = descriptives( input )
% Get descriptive statistics from data.

n = size(input, 2);
mu = zeros(1, n);
sd = zeros(1, n);

for i = 1:n
    pairData = input(:, i);
    
    % Remove NaN values.
    pairData = pairData(~isnan(pairData));
    
    mu(i) = mean(pairData);
    sd(i) = std(pairData);
    
end









end