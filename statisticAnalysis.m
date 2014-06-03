function [ analysis1, analysis2 ] = statisticAnalysis(fileName)
% (Rhythm) data analysis script.
%
% N.B.: FIRST AND LAST COLUMNS OF ALL MATRICES AND VECTORS CONTAIN DATA
% FROM SAFETY PAIRS. THE EXPERIMENT CONTAINED N = 190 PAIRS, ALL (M x N) 
% MATRICES AND VECTORS ARE N + 2 IN SIZE.
%
% Output consists of:
%   cleaned data: [ ratingsX ]
%   descriptives: [ muOutX, sigmaOutX, sigmaTotX ]
%   concordance stats: [ alphaX ]
%
%
% N.B.: - All variables ending in 1 take all data into account.
%
%       - All variables ending in 2 do not take data with confidence level 
%         1 into account.
%
%       - The first position in the output vectors contains data obtained
%         from the matrix without safety checks. The subsequent positions
%         contain data obtained after (2) the full safety check, (3) the
%         downsampled safety check, (4) the 'adjecent concordance' safety
%         check (see description in safetyCheck() for more information).
%
%
% CURRENT VERSIONS:
% Rhythm:
% [ analysis1, analysis2 ] = statisticAnalysis('rhythmmerged20140522.xlsx');
%
% Timbre:
% [ analysis1, analysis2 ] = statisticAnalysis('timbremerged20140522.xlsx');
%
% General:
% [ analysis1, analysis2 ] = statisticAnalysis('general20140522.xlsx');


% Import raw data from Survey Monkey output.
import = importdata(fileName);
importData = import.data;
importText = import.textdata;


% Truncate input to only contain ratings.
% N.B.: ratings2 contains no judgements with confidence value '1'.
[ ratings1_noCheck, ratings2_noCheck ] = reformat(importData);


% Check for discrepancies in the ratings of the safety pairs.
ratings1_fullConc = safetyCheck(ratings1_noCheck, 1, 0);
ratings2_fullConc = safetyCheck(ratings2_noCheck, 1, 0);

ratings1_dsConc = safetyCheck(ratings1_noCheck, 2, 1);
ratings2_dsConc = safetyCheck(ratings2_noCheck, 2, 1);

ratings1_adjConc = safetyCheck(ratings1_noCheck, 3, 1);
ratings2_adjConc = safetyCheck(ratings2_noCheck, 3, 1);


% Get descriptives.
[ mu1, sigma1 ] = descriptives(ratings1_noCheck);
[ mu2, sigma2 ] = descriptives(ratings2_noCheck);

muOut1(1, :) = mu1(1, :);
muOut2(1, :) = mu2(1, :);
sigmaOut1(1, :) = sigma1(1, :);
sigmaOut2(1, :) = sigma2(1, :);


[ mu1, sigma1 ] = descriptives(ratings1_fullConc);
[ mu2, sigma2 ] = descriptives(ratings2_fullConc);

muOut1(2, :) = mu1(1, :);
muOut2(2, :) = mu2(1, :);
sigmaOut1(2, :) = sigma1(1, :);
sigmaOut2(2, :) = sigma2(1, :);


[ mu1, sigma1 ] = descriptives(ratings1_dsConc);
[ mu2, sigma2 ] = descriptives(ratings2_dsConc);

muOut1(3, :) = mu1(1, :);
muOut2(3, :) = mu2(1, :);
sigmaOut1(3, :) = sigma1(1, :);
sigmaOut2(3, :) = sigma2(1, :);


[ mu1, sigma1 ] = descriptives(ratings1_adjConc);
[ mu2, sigma2 ] = descriptives(ratings2_adjConc);

muOut1(4, :) = mu1(1, :);
muOut2(4, :) = mu2(1, :);
sigmaOut1(4, :) = sigma1(1, :);
sigmaOut2(4, :) = sigma2(1, :);


% Get the standard deviations of the set of standard deviations per group
% of rating(n)_X.
for i = 1:4
    sigmaTot1(i) = std(sigmaOut1(i, 2:size(sigmaOut1 - 1)));
    sigmaTot2(i) = std(sigmaOut2(i, 2:size(sigmaOut2 - 1)));
end

% Calculate Krippendorff's alpha.
% Missing values have to be coded as NaN or inf.
% Specify data type (supported are 'nominal', 'ordinal', 'interval').
dataType = 'interval';

alpha1(1) = kriAlpha(ratings1_noCheck, dataType);
alpha2(1) = kriAlpha(ratings2_noCheck, dataType);

alpha1(2) = kriAlpha(ratings1_fullConc, dataType);
alpha2(2) = kriAlpha(ratings2_fullConc, dataType);

alpha1(3) = kriAlpha(ratings1_dsConc, dataType);
alpha2(3) = kriAlpha(ratings2_dsConc, dataType);

alpha1(4) = kriAlpha(ratings1_adjConc, dataType);
alpha2(4) = kriAlpha(ratings2_adjConc, dataType);


% Reformat data:
% Row 1 contains mean rating.
% Row 2 contains pair sDev.
% Row 3 contains total sDev and alpha statistic, respectively.
sizeMat = size(ratings1_noCheck, 2) - 2;

ratings1_noCheck_final = nan(3, sizeMat);
ratings1_noCheck_final(1, :) = muOut1(1, 2:sizeMat + 1);
ratings1_noCheck_final(2, :) = sigmaOut1(1, 2:sizeMat + 1);
ratings1_noCheck_final(3, 1) = sigmaTot1(1);
ratings1_noCheck_final(3, 2) = alpha1(1);

ratings1_fullConc_final = nan(3, sizeMat);
ratings1_fullConc_final(1, :) = muOut1(2, 2:sizeMat + 1);
ratings1_fullConc_final(2, :) = sigmaOut1(2, 2:sizeMat + 1);
ratings1_fullConc_final(3, 1) = sigmaTot1(2);
ratings1_fullConc_final(3, 2) = alpha1(2);

ratings1_dsConc_final = nan(3, sizeMat);
ratings1_dsConc_final(1, :) = muOut1(3, 2:sizeMat + 1);
ratings1_dsConc_final(2, :) = sigmaOut1(3, 2:sizeMat + 1);
ratings1_dsConc_final(3, 1) = sigmaTot1(3);
ratings1_dsConc_final(3, 2) = alpha1(3);

ratings1_adjConc_final = nan(3, sizeMat);
ratings1_adjConc_final(1, :) = muOut1(4, 2:sizeMat + 1);
ratings1_adjConc_final(2, :) = sigmaOut1(4, 2:sizeMat + 1);
ratings1_adjConc_final(3, 1) = sigmaTot1(4);
ratings1_adjConc_final(3, 2) = alpha1(4);

ratings2_noCheck_final = nan(3, sizeMat);
ratings2_noCheck_final(1, :) = muOut2(1, 2:sizeMat + 1);
ratings2_noCheck_final(2, :) = sigmaOut2(1, 2:sizeMat + 1);
ratings2_noCheck_final(3, 1) = sigmaTot2(1);
ratings2_noCheck_final(3, 2) = alpha2(1);

ratings2_fullConc_final = nan(3, sizeMat);
ratings2_fullConc_final(1, :) = muOut2(2, 2:sizeMat + 1);
ratings2_fullConc_final(2, :) = sigmaOut2(2, 2:sizeMat + 1);
ratings2_fullConc_final(3, 1) = sigmaTot2(2);
ratings2_fullConc_final(3, 2) = alpha2(2);

ratings2_dsConc_final = nan(3, sizeMat);
ratings2_dsConc_final(1, :) = muOut2(3, 2:sizeMat + 1);
ratings2_dsConc_final(2, :) = sigmaOut2(3, 2:sizeMat + 1);
ratings2_dsConc_final(3, 1) = sigmaTot2(3);
ratings2_dsConc_final(3, 2) = alpha2(3);

ratings2_adjConc_final = nan(3, sizeMat);
ratings2_adjConc_final(1, :) = muOut2(4, 2:sizeMat + 1);
ratings2_adjConc_final(2, :) = sigmaOut2(4, 2:sizeMat + 1);
ratings2_adjConc_final(3, 1) = sigmaTot2(4);
ratings2_adjConc_final(3, 2) = alpha2(4);


% Create large output matrices.
analysis1 = nan(15, sizeMat);
analysis1(1:3, 1:sizeMat) = ratings1_noCheck_final;
analysis1(5:7, 1:sizeMat) = ratings1_fullConc_final;
analysis1(9:11, 1:sizeMat) = ratings1_dsConc_final;
analysis1(13:15, 1:sizeMat) = ratings1_adjConc_final;

analysis2 = nan(15, sizeMat);
analysis2(1:3, 1:sizeMat) = ratings2_noCheck_final;
analysis2(5:7, 1:sizeMat) = ratings2_fullConc_final;
analysis2(9:11, 1:sizeMat) = ratings2_dsConc_final;
analysis2(13:15, 1:sizeMat) = ratings2_adjConc_final;
end