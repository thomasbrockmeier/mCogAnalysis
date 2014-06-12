function output = generalCompRT( general, rhythm, timbre )
% Compare general to R&T data.
% Output contains pair number, p-value general vs. rhythm, p-value general 
% vs. timbre and the 'winner' (lower p-value -> this dimension is 
% considered more concordant with general sim.), from rows one to four 
% respectively.
%
% Console input:
% output = generalCompRT( 'general20140522.xlsx', 'rhythmmerged20140522.xlsx', 'timbremerged20140522.xlsx' );

% Import raw data from Survey Gizmo output.
import1 = importdata(general);
importData1 = import1.data;

import2 = importdata(rhythm);
importData2 = import2.data;

import3 = importdata(timbre);
importData3 = import3.data;

% Truncate input to only contain ratings.
% N.B.: ratings2 contains no judgements with confidence value '1'.
[ ratings1s1_noCheck, ~ ] = reformat(importData1);

[ ratings1s2_noCheck, ~ ] = reformat(importData2);

[ ratings1s3_noCheck, ~ ] = reformat(importData3);

% Remove safety pairs from rhythm and timbre matrices.
% (General contains none).
ratings1s2_noCheck(:, 1) = [];
ratings1s2_noCheck(:, end) = [];

ratings1s3_noCheck(:, 1) = [];
ratings1s3_noCheck(:, end) = [];

% Clear R and T matrices of all data, but the pairs that are available in
% the G matrix as well.
genPairID = [47 149 184 111 176 190 17 59 21 94 151 119 39 7 62 188 178 53];
genPairID = sort(genPairID);
generalMat = ratings1s1_noCheck;
rhythmMat = nan(1,18);
timbreMat = nan(1,18);

for i = 1:size(rhythmMat, 2)
    for k = 1:size(ratings1s2_noCheck(:, genPairID(i), 1))
        rhythmMat(k, i) = ratings1s2_noCheck(k, genPairID(i));
        timbreMat(k, i) = ratings1s3_noCheck(k, genPairID(i));
    end
end

output = cell(4, size(rhythmMat, 2));

for j = 1:size(rhythmMat, 2)
    % Pair number.
    output{1, j} = genPairID(j);
    % Wilcoxon general vs. rhythm.
    [ pGR, ~, ~ ] = ranksum(generalMat(:, j), rhythmMat(:, j));
    output{2, j} = pGR;
    
    % Wilcoxon general vs. timbre.
    [ pGT, ~, ~ ] = ranksum(generalMat(:, j), timbreMat(:, j));
    output{3, j} = pGT;
    
    % Assign higher similarity of rhythm or timbre data to general
    % experiment to the lower p-value. Also check for significance.
    if pGR < pGT && pGR <= 0.05
        output{4, j} = 'RHYTHM';
    elseif pGT < pGR && pGT <= 0.05
        output{4, j} = 'TIMBRE';
    else
        output{4, j} = 'TIE';
    end
end
end