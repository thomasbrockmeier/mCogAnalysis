function [ output, rhythmMat ] = generalCompRT_fixed( general, rhythm, timbre )
% Compare general to R&T data.
% Output contains pair number, p-value general vs. rhythm, p-value general 
% vs. timbre, the 'winner' and U and p-values for general vs. rhythm and
% general vs. timbre.
%
% Console input:
% output = generalCompRT_fixed( 'general20140522.xlsx', 'rhythmmerged20140522.xlsx', 'timbremerged20140522.xlsx' );
%
%
% To use this script to calculate kappa, add:
% [ k, p ] = waterDeity(safetyCheck(timbreMat, 1, 1), 1000)
% to code AFTER i loop.

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

output = cell(9, size(rhythmMat, 2));

for j = 1:size(rhythmMat, 2)
    % Pair number.
    output{1, j} = genPairID(j);
    % Wilcoxon general vs. rhythm.
    [ pGR, hGR, uGR ] = ranksum(generalMat(:, j), rhythmMat(:, j));
    output{2, j} = pGR;
    
    nR = sum(~isnan(rhythmMat(:, j)));
    
    % Wilcoxon general vs. timbre.
    [ pGT, hGT, uGT ] = ranksum(generalMat(:, j), timbreMat(:, j));
    output{3, j} = pGT;
    
    nT = sum(~isnan(timbreMat(:, j)));
    
    % Assign higher similarity of rhythm or timbre data to general
    % experiment to the lower p-value. Also check for significance.
    if hGR == 1 && hGT == 0
        output{4, j} = 'TIMBRE';
    elseif hGT == 1 && hGR == 0
        output{4, j} = 'RHYTHM';
    elseif hGT == 0 && hGR == 0
        output{4, j} = 'TIE';
    elseif hGT == 1 && hGR == 1
        if uGR.ranksum > uGT.ranksum
            output{4, j} = 'RHYTHM';
        elseif uGT.ranksum > uGR.ranksum
            output{4, j} = 'TIMBRE';
        else
            output{4, j} = 'TIE';
        end
    else
        output{4, j} = 'TIE';
    end
    
    % Tack on U statistic and N raters.
    output{6, j} = uGR.ranksum;
    output{7, j} = nR;
    output{8, j} = uGT.ranksum;
    output{9, j} = nT;
end
end