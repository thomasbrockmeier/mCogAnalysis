function [ dataOut, seed ] = kappaSeed( dataMatrix, n )
% Generate a kappa-compatible dataset from incomplete data by random
% removal of data points.
% seed contains the coordinates of the removed ratings per pair. Every
% row(n) corresponds to pair(n) in the experiment.

maxRatings = max(n);
minRatings = min(n);
nPairs = size(dataMatrix, 2);
dataOut = dataMatrix;
seed = nan(nPairs, maxRatings - minRatings);

for i = 1:nPairs
    randCoor = nan(1, maxRatings - minRatings);
    if n(i) > minRatings
        % Amount of ratings to be removed.
        nRemove = n(i) - minRatings;
        
        % Get locations of ratings of pair 'i'.
        pairData = dataMatrix(:, i);
        dataCoor = find(~isnan(pairData));
        
        % Remove an nRemove amount of data points from dataMatrix.
        % N.B., The coordinates specified in randCoor must be extracted
        % from dataCoor, these can then be removed from dataOut.
        randCoor(1:nRemove) = randperm(size(dataCoor, 1), nRemove);
        randCoorTemp = randCoor(~isnan(randCoor));
        targetCoor = dataCoor(randCoorTemp);
        dataOut(targetCoor, i) = NaN;
    end
    % Return randomly removed data points.
    seed(i, :) = randCoor;
end

end