function [k, p] = kappaFormat( dataMatrix )
% Convert input matrix to format suitable for kappa analysis and calculate
% Fleiss' kappa.
%
% N.B., Officially no missing data allowed!
% N.B.B., DOES WORK WITH SPARSE MATRICES, BUT MAKE SURE THE MINIMUM AMOUNT
%         OF RATERS FOR A GIVEN PAIR >= N = 10!

[ ~, ~, nRaters, ~ ] = descriptives( dataMatrix );
nOptions = size(unique(dataMatrix(~isnan(dataMatrix))), 1);
nPairs = size(dataMatrix, 2);

if size(unique(nRaters), 2) ~= 1
    dataMatrix = kappaSeed(dataMatrix, nRaters);
end


% Create M x N matrix with M = amount of pairs and N = amount of unique
% ratings.
kappaMatrix = zeros(nPairs, nOptions);

for i = 1:nPairs
    % Get data for pair 'i' and remove NaN values.
    currentPair = dataMatrix(:, i);
    
    % Check if ratings are sampled down to true/false. If so, convert
    % all 4's into 2's.
    if nOptions == 2
        sampleCoords = find(currentPair == 4);
        currentPair(sampleCoords) = 2;
    end

    
    for j = 1:nOptions
        % Get total amount of ratings 'j' for pair 'i' and enter into
        % output matrix.
        kappaMatrix(i, j) = size(find(currentPair == j), 1);
    end
end

Calculate kappa statistic.
[k, p ] = fleiss(kappaMatrix)

end