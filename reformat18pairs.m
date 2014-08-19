function [ outputA, outputB ] = reformat18pairs( matrix )
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

outputAtemp = matrix;
outputBtemp = matrix;

% Define pair numbers in first row. Safety pairs are labeled '0'.
for i = size(outputAtemp, 2) - 1:-2:1

    % Remove entries with confidence value '1' from outputB.
    confID = i + 1;
    confIndex = find(outputBtemp(:, confID) == 1);
    
    for j = 1:length(confIndex)
        outputBtemp(confIndex(j), i) = NaN;
        outputBtemp(confIndex(j), i + 1) = NaN;
    end
    
    % Remove confidence ratings from matrices.
    outputAtemp(:, confID) = [];
    outputBtemp(:, confID) = [];
    
end

% Get only pairs that were used in general/WPC experiments.
desiredPairs = [ 1 7 17 21 39 47 53 59 62 94 111 119 149 151 ...
    176 178 184 188 190 191 ];

outputA = zeros(size(outputAtemp, 1), length(desiredPairs));
outputB = zeros(size(outputBtemp, 1), length(desiredPairs));

for x = 1:length(desiredPairs)
    outputA(:, x) = outputAtemp(:, desiredPairs(x) + 1);
    outputB(:, x) = outputBtemp(:, desiredPairs(x) + 1);
end



end

