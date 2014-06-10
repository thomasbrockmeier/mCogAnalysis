function [ kappaOut, pOut, kappaCollect ] = waterDeity( dataMatrix, nIterations )
% Reiterates a custom variant of Fleiss' kappa that has been designed to
% work with incomplete data. The variant uses random removal of data points
% to allow correct reformatting of the input data to achieve compatibility
% with the kappa calculations.
%
% Because data is removed randomly, it is advised to set the number of
% iterations to a generous amount.
%
%
% waterDeity( dataMatrix, nIterations) runs a total of nIterations kappa 
% analyses on (incomplete) input dataMatrix.
%
% - kappaOut contains the mean kappa over all iterations.
% - kappaCollect contains all separate kappa values (column 1) and their 
%   corresponding p values (column 2).


kappaCollect = zeros(nIterations, 2);

for i = 1:nIterations
    [ k, p ] = kappaFormat(dataMatrix);
    
    kappaCollect(i, 1) = k;
    kappaCollect(i, 2) = p;
end

kappaOut = mean(kappaCollect(:, 1));
pOut = mean(kappaCollect(:, 2));



end