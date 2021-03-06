function output = kappaLoHi( general, rhythm, timbre )
% Compare general to R&T data.
% Output contains pair number, p-value general vs. rhythm, p-value general 
% vs. timbre, the 'winner' and U and p-values for general vs. rhythm and
% general vs. timbre.
%
% Console input:
% output = kappaLoHi( 'general20140522.xlsx', 'rhythmmerged20140522.xlsx', 'timbremerged20140522.xlsx' );
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

% Get high and low R/T pairs.
loRhy = [17 21 59 94 151 178];
hiRhy = [47 111 119 149 176 184 190];
loTim = [21 53 94 111 151 176 190];
hiTim = [17 39 47 59 149 184];

% Fill up matrices.
loRhyMat = nan(1, length(loRhy));
hiRhyMat = nan(1, length(hiRhy));
loTimMat = nan(1, length(loTim));
hiTimMat = nan(1, length(hiTim));

for i = 1:6
    for k = 1:size(ratings1s2_noCheck(:, hiRhy(i), 1))
        loRhyMat(k, i) = ratings1s2_noCheck(k, loRhy(i));
        hiRhyMat(k, i) = ratings1s3_noCheck(k, hiRhy(i));
        loTimMat(k, i) = ratings1s2_noCheck(k, loTim(i));
        hiTimMat(k, i) = ratings1s3_noCheck(k, hiTim(i));
    end
end

i = 7;
for k = 1:size(ratings1s2_noCheck(:, hiRhy(i), 1))
        hiRhyMat(k, i) = ratings1s3_noCheck(k, hiRhy(i));
        loTimMat(k, i) = ratings1s2_noCheck(k, loTim(i));
end

% Get kappa's.
nIter = 1000;
[k_loRhy, p_loRhy] = waterDeity(loRhyMat, nIter);
[k_hiRhy, p_hiRhy] = waterDeity(hiRhyMat, nIter);
[k_loTim, p_loTim] = waterDeity(loTimMat, nIter);
[k_hiTim, p_hiTim] = waterDeity(hiTimMat, nIter);

output = [k_loRhy p_loRhy; k_hiRhy p_hiRhy; k_loTim p_loTim; k_hiTim p_hiTim];