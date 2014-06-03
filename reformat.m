function [ outputA, outputB ] = reformat( matrix )
% Reformat Survey Gizmo output data to fit further analysis. outputB does
% not contain values with confidence value '1'.


% Check if the input file contains general similarity or rhythm/timbre data
% and set bounaries accordingly.
if size(matrix, 2) > 408
    colMax = 408;
    colOne = 25;
else
    colMax = 57;
    colOne = 22;
end

% Truncate input to only contain judgements.
matrix = matrix(:, colOne:colMax);
matrix(1, :) = [];

outputA = matrix;
outputB = matrix;

% Define pair numbers in first row. Safety pairs are labeled '0'.
for i = size(outputA, 2) - 1:-2:1

    % Remove entries with confidence value '1' from outputB.
    confID = i + 1;
    confIndex = find(outputB(:, confID) == 1);
    
    for j = 1:length(confIndex)
        outputB(confIndex(j), i) = NaN;
        outputB(confIndex(j), i + 1) = NaN;
    end
    
    % Remove confidence ratings from matrices.
    outputA(:, confID) = [];
    outputB(:, confID) = [];
    
end






end

