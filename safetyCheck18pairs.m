function output = safetyCheck18pairs(matrix, concLevel, inclNS)
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
%
% inclNS = 1: include participants who did not rate safety pairs in the
%             output.
% inclNS = 0: exclude participants who did not rate safety pairs from the
%             output.


% Check for proper formatting of input.
while concLevel ~= 1 && concLevel ~= 2 && concLevel ~= 3
    input('Error! Please enter a valid input for concLevel.');
end

while inclNS ~= 1 && inclNS ~= 0
    input('Error! Please enter a valid input for inclNS.');
end


% Change NaN values for absent safety pairs to 99 to prevent these from
% being filtered out.
% % if inclNS == 1
% %     nanIndex = isnan(matrix(:, 1));
% %     matrix(nanIndex, 1) = 99;
% %     matrix(nanIndex, size(matrix, 2)) = 99;
% % end


% Run concordance checks cf. description above.
if concLevel == 1
    [ row, ~ ] = find(matrix(:,1) ~= matrix(:, end));
    matrix(row, :) = [];
    
elseif concLevel == 2
    matrix(matrix == 2) = 1;
    matrix(matrix == 3) = 4;
    
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
end


output = matrix;


% for y = size(output, 2):-1:1
%     if sum(~isnan(output(:, y))) == 0
%         output(:, y) = output(:, y + 1);
%         output(:, y + 1) = [];
%     end
% end



end