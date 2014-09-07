function [ output, rhythmMat ] = generalCompRT_fixed( general, rhythm, timbre )
% Compare general to R&T data.
% Output contains pair number, p-value general vs. rhythm, p-value general 
% vs. timbre, the 'winner' and N and U values for general vs. rhythm and
% general vs. timbre.
%
% Console input:
% output = generalCompRT_fixed( 'general20140714.xls', 'rhythmmerged20140522.xlsx', 'timbre20140714.xlsx' );
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
    
    nR = sum(~isnan(rhythmMat(:, j)));
    
    rRatings = rhythmMat(~isnan(rhythmMat(:, j)), j);
    
    output{2, j} = mean(generalMat(:, j));
    
    output{4, j} = nR;
    output{5, j} = num2str(mean(rRatings),'%.4f');
    output{6, j} = uGR.ranksum;
    output{7, j} = num2str(mean(pGR),'%.4f');
    
    % Wilcoxon general vs. timbre.
    [ pGT, hGT, uGT ] = ranksum(generalMat(:, j), timbreMat(:, j));
    
    nT = sum(~isnan(timbreMat(:, j)));
    
    tRatings = timbreMat(~isnan(timbreMat(:, j)), j);
        
    output{9, j} = nT;
    output{10, j} = num2str(mean(tRatings),'%.4f');
    output{11, j} = uGT.ranksum;
    output{12, j} = num2str(mean(pGT),'%.4f');
    
    % Assign higher similarity of rhythm or timbre data to general
    % experiment to the lower p-value. Also check for significance.
    if hGR == 1 && hGT == 0
        output{14, j} = 'TIMBRE';
    elseif hGT == 1 && hGR == 0
        output{14, j} = 'RHYTHM';
    elseif hGT == 0 && hGR == 0
        output{14, j} = 'TIE';
    elseif hGT == 1 && hGR == 1
        if uGR.ranksum > uGT.ranksum
            output{14, j} = 'RHYTHM';
        elseif uGT.ranksum > uGR.ranksum
            output{14, j} = 'TIMBRE';
        else
            output{14, j} = 'TIE';
        end
    else
        output{14, j} = 'TIE';
    end
end

% Predictions.
output{15, 1}  = 'MRMT';
output{15, 2}  = 'LRHT';
output{15, 3}  = 'LRLT';
output{15, 4}  = 'MRHT';
output{15, 5}  = 'HRHT';
output{15, 6}  = 'MRLT';
output{15, 7}  = 'LRHT';
output{15, 8}  = 'MRMT';
output{15, 9}  = 'LRLT';
output{15, 10} = 'HRLT';
output{15, 11} = 'HRMT';
output{15, 12} = 'HRHT';
output{15, 13} = 'LRLT';
output{15, 14} = 'HRLT';
output{15, 15} = 'LRMT';
output{15, 16} = 'HRHT';
output{15, 17} = 'MRMT';
output{15, 18} = 'HRLT';

end