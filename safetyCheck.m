function [ output, nRemoved ] = safetyCheck(matrix, concLevel, inclNS)
% This function checks for inconsitencies in the assessments of the safety
% pairs (the first and last columns). concLevel must be either 1, 2, or 3
% and inclNS must be 1 or 0 (see documentation below).
%
% concLevel = 1: full concordance; assessments must be exactly the same.
%
% concLevel = 2: down-sampled concordance; (somewhat) similar vs.
%                (somewhat) dissimilar.
%
% concLevel = 3: 'adjacency concordance'; adjacent concordance values
%                (1 & 2, 2 & 3, 3 & 4) are counted as concordant.
%
% concLevel = 4: 'adjacency concordance + down-sampling'; adjacent concordance values
%                (1 & 2, 2 & 3, 3 & 4) are counted as concordant, data is down sampled after.
%
%
% inclNS = 1: include participants who did not rate safety pairs in the
%             output.
% inclNS = 0: exclude participants who did not rate safety pairs from the
%             output.


% Check for proper formatting of input.
while concLevel ~= 1 && concLevel ~= 2 && concLevel ~= 3 && concLevel ~= 4
    input('Error! Please enter a valid input for concLevel.');
end

while inclNS ~= 1 && inclNS ~= 0
    input('Error! Please enter a valid input for inclNS.');
end


% Change NaN values for absent safety pairs to 99 to prevent these from
% being filtered out.
if inclNS == 1
    nanIndex = isnan(matrix(:, 1));
    matrix(nanIndex, 1) = 99;
    matrix(nanIndex, size(matrix, 2)) = 99;
end


% Run concordance checks cf. discription above.
if concLevel == 1
    [ row, ~ ] = find(matrix(:,1) ~= matrix(:, end));
    matrix(row, :) = [];
    
elseif concLevel == 2
    matrix(matrix == 2) = 1;
    matrix(matrix == 3) = 4;
    [ row, ~ ] = find(matrix(:,1) ~= matrix(:, end));
    matrix(row, :) = [];
    
elseif concLevel == 3
    counter = 0;
    
    for i = 1:size(matrix, 1)
        
        if matrix(i, 1) == matrix(i, size(matrix, 2)) || ...
                matrix(i, 1) == matrix(i, size(matrix, 2)) + 1 || ...
                matrix(i, 1) == matrix(i, size(matrix, 2)) - 1
            counter = counter + 1;
            row(counter) = i;
        end
    end
elseif concLevel == 4
    counter = 0;
    
    for i = 1:size(matrix, 1)
        
%         if matrix(i, 1) == matrix(i, size(matrix, 2)) || ...
%                 matrix(i, 1) == matrix(i, size(matrix, 2)) + 1 || ...
%                 matrix(i, 1) == matrix(i, size(matrix, 2)) - 1

        if (matrix(i, 1) == (matrix(i, size(matrix, 2)))) || ...
                (matrix(i, 1) == 1 && matrix(i, size(matrix, 2)) == 2) || ...
                (matrix(i, 1) == 2 && matrix(i, size(matrix, 2)) == 1) || ...
                (matrix(i, 1) == 2 && matrix(i, size(matrix, 2)) == 3) || ...
                (matrix(i, 1) == 3 && matrix(i, size(matrix, 2)) == 2) || ...
                (matrix(i, 1) == 3 && matrix(i, size(matrix, 2)) == 4) || ...
                (matrix(i, 1) == 4 && matrix(i, size(matrix, 2)) == 3)
            counter = counter + 1;
            keepRow(counter) = i;
        end
    end
    
    matrix = matrix(keepRow, :);
    
    matrix(matrix == 2) = 1;
    matrix(matrix == 3) = 4;
    row = 1:size(matrix, 1) - counter;
    disp(row)
end


% Remove safety pairs from output.
matrix(:, 1) = [];
matrix(:, end) = [];
% nRemoved = length(row);


output = matrix;







end