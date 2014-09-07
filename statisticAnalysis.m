function [ analysis1, analysis2, ratings1_dsConc ] = statisticAnalysis(fileName)
% (Rhythm) data analysis script.
%
% N.B.: FIRST AND LAST COLUMNS OF ALL MATRICES AND VECTORS CONTAIN DATA
% FROM SAFETY PAIRS. THE EXPERIMENT CONTAINED N = 190 PAIRS, ALL (M x N) 
% MATRICES AND VECTORS ARE N + 2 IN SIZE.
%
% Output consists of:
%   cleaned data: [ ratingsX ]
%   descriptives: [ muOutX, sigmaOutX, sigmaTotX, nOutX, zAvgOutX ]
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
% [ analysis1, analysis2 ] = statisticAnalysis('rhythm20140522.xlsx');
%
% Timbre:
% [ analysis1, analysis2 ] = statisticAnalysis('timbre20140714.xlsx');
%
% General:
% [ analysis1, analysis2 ] = statisticAnalysis('general20140714.xlsx');
%
% Rhythm WPC:
% [ analysis1, analysis2 ] = statisticAnalysis('rhythmWPC.xlsx');


% Import raw data from Survey Gizmo output.
import = importdata(fileName);
importData = import.data;
%importText = import.textdata;


% Truncate input to only contain ratings.
% N.B.: ratings2 contains no judgements with confidence value '1'.
[ ratings1_noCheck, ratings2_noCheck ] = reformat(importData);


% Check for discrepancies in the ratings of the safety pairs.
ratings1_fullConc = safetyCheck(ratings1_noCheck, 1, 0);
ratings2_fullConc = safetyCheck(ratings2_noCheck, 1, 0);

ratings1_dsConc = safetyCheck(ratings1_noCheck, 4, 1);
ratings2_dsConc = safetyCheck(ratings2_noCheck, 2, 1);

ratings1_adjConc = safetyCheck(ratings1_noCheck, 3, 1);
ratings2_adjConc = safetyCheck(ratings2_noCheck, 3, 1);

% Remove safety pairs from ratingsN_noCheck.
ratings1_noCheck(:, 1) = [];
ratings2_noCheck(:, 1) = [];
ratings1_noCheck(:, end) = [];
ratings2_noCheck(:, end) = [];


% Get descriptives.
[ mu1, sigma1, n1, zAvg1 ] = descriptives(ratings1_noCheck);
[ mu2, sigma2, n2, zAvg2 ] = descriptives(ratings2_noCheck);

muOut1(1, :) = mu1(1, :);
muOut2(1, :) = mu2(1, :);
sigmaOut1(1, :) = sigma1(1, :);
sigmaOut2(1, :) = sigma2(1, :);
nOut1(1, :) = n1(1, :);
nOut2(1, :) = n2(1, :);
zAvgOut1(1, :) = zAvg1(1, :);
zAvgOut2(1, :) = zAvg2(1, :);

[ mu1, sigma1, n1, zAvg1 ] = descriptives(ratings1_fullConc);
[ mu2, sigma2, n2, zAvg2 ] = descriptives(ratings2_fullConc);

muOut1(2, :) = mu1(1, :);
muOut2(2, :) = mu2(1, :);
sigmaOut1(2, :) = sigma1(1, :);
sigmaOut2(2, :) = sigma2(1, :);
nOut1(2, :) = n1(1, :);
nOut2(2, :) = n2(1, :);
zAvgOut1(2, :) = zAvg1(1, :);
zAvgOut2(2, :) = zAvg2(1, :);

[ mu1, sigma1, n1, zAvg1 ] = descriptives(ratings1_dsConc);
[ mu2, sigma2, n2, zAvg2 ] = descriptives(ratings2_dsConc);

muOut1(3, :) = mu1(1, :);
muOut2(3, :) = mu2(1, :);
sigmaOut1(3, :) = sigma1(1, :);
sigmaOut2(3, :) = sigma2(1, :);
nOut1(3, :) = n1(1, :);
nOut2(3, :) = n2(1, :);
zAvgOut1(3, :) = zAvg1(1, :);
zAvgOut2(3, :) = zAvg2(1, :);

[ mu1, sigma1, n1, zAvg1 ] = descriptives(ratings1_adjConc);
[ mu2, sigma2, n2, zAvg2 ] = descriptives(ratings2_adjConc);

muOut1(4, :) = mu1(1, :);
muOut2(4, :) = mu2(1, :);
sigmaOut1(4, :) = sigma1(1, :);
sigmaOut2(4, :) = sigma2(1, :);
nOut1(4, :) = n1(1, :);
nOut2(4, :) = n2(1, :);
zAvgOut1(4, :) = zAvg1(1, :);
zAvgOut2(4, :) = zAvg2(1, :);


% Get the standard deviations of the set of standard deviations per group
% of rating(n)_X.
sigmaTot1 = zeros(1, 4);
sigmaTot2 = zeros(1, 4);

for i = 1:4
    sigmaTot1(i) = std(sigmaOut1(i, 1:size(sigmaOut1)));
    sigmaTot2(i) = std(sigmaOut2(i, 1:size(sigmaOut2)));
end

% Calculate Krippendorff's alpha.
% Missing values have to be coded as NaN or inf.
% Specify data type (supported are 'nominal', 'ordinal', 'interval').
dataType = 'ordinal';

alpha1(1) = kriAlpha(ratings1_noCheck, dataType);
alpha2(1) = kriAlpha(ratings2_noCheck, dataType);

alpha1(2) = kriAlpha(ratings1_fullConc, dataType);
alpha2(2) = kriAlpha(ratings2_fullConc, dataType);

alpha1(3) = kriAlpha(ratings1_dsConc, dataType);
alpha2(3) = kriAlpha(ratings2_dsConc, dataType);

alpha1(4) = kriAlpha(ratings1_adjConc, dataType);
alpha2(4) = kriAlpha(ratings2_adjConc, dataType);

% Calculate Fleiss' kappa.
% Adjusted script accepts incomplete data.
%
% N.B., Caution should be taken when interpreting the kappa rating of
%       datasets wherein the pair with the lowest amount of judges has 
%       N < 10.
nIter = 1000;

[ kappa1(1), p1(1) ] = waterDeity(ratings1_noCheck, nIter);
[ kappa2(1), p2(1) ] = waterDeity(ratings2_noCheck, nIter);

[ kappa1(2), p1(2) ] = waterDeity(ratings1_fullConc, nIter);
[ kappa2(2), p2(2) ] = waterDeity(ratings2_fullConc, nIter);

[ kappa1(3), p1(3) ] = waterDeity(ratings1_dsConc, nIter);
[ kappa2(3), p2(3) ] = waterDeity(ratings2_dsConc, nIter);

[ kappa1(4), p1(4) ] = waterDeity(ratings1_adjConc, nIter);
[ kappa2(4), p2(4) ] = waterDeity(ratings2_adjConc, nIter);

% Reformat data:
% Row 1 contains mean rating.
% Row 2 contains pair sDev.
% Row 3 contains total sDev and alpha statistic, respectively.
sizeMat = size(ratings1_noCheck, 2);

ratings1_noCheck_final = nan(5, sizeMat);
ratings1_noCheck_final(1, :) = nOut1(1, 1:sizeMat);
ratings1_noCheck_final(2, :) = muOut1(1, 1:sizeMat);
ratings1_noCheck_final(3, :) = sigmaOut1(1, 1:sizeMat);
ratings1_noCheck_final(4, :) = zAvgOut1(1, 1:sizeMat);
ratings1_noCheck_final(5, 1) = sigmaTot1(1);
ratings1_noCheck_final(5, 2) = alpha1(1);
ratings1_noCheck_final(5, 3) = kappa1(1);
ratings1_noCheck_final(5, 4) = p1(1);
ratings1_noCheck_final(5, 6) = min(nOut1(1, :));
ratings1_noCheck_final(5, 7) = max(nOut1(1, :));

ratings1_fullConc_final = nan(5, sizeMat);
ratings1_fullConc_final(1, :) = nOut1(2, 1:sizeMat);
ratings1_fullConc_final(2, :) = muOut1(2, 1:sizeMat);
ratings1_fullConc_final(3, :) = sigmaOut1(2, 1:sizeMat);
ratings1_fullConc_final(4, :) = zAvgOut1(2, 1:sizeMat);
ratings1_fullConc_final(5, 1) = sigmaTot1(2);
ratings1_fullConc_final(5, 2) = alpha1(2);
ratings1_fullConc_final(5, 3) = kappa1(2);
ratings1_fullConc_final(5, 4) = p1(2);
ratings1_fullConc_final(5, 6) = min(nOut1(2, :));
ratings1_fullConc_final(5, 7) = max(nOut1(2, :));

ratings1_dsConc_final = nan(5, sizeMat);
ratings1_dsConc_final(1, :) = nOut1(3, 1:sizeMat);
ratings1_dsConc_final(2, :) = muOut1(3, 1:sizeMat);
ratings1_dsConc_final(3, :) = sigmaOut1(3, 1:sizeMat);
ratings1_dsConc_final(4, :) = zAvgOut1(3, 1:sizeMat);
ratings1_dsConc_final(5, 1) = sigmaTot1(3);
ratings1_dsConc_final(5, 2) = alpha1(3);
ratings1_dsConc_final(5, 3) = kappa1(3);
ratings1_dsConc_final(5, 4) = p1(3);
ratings1_dsConc_final(5, 6) = min(nOut1(3, :));
ratings1_dsConc_final(5, 7) = max(nOut1(3, :));

ratings1_adjConc_final = nan(5, sizeMat);
ratings1_adjConc_final(1, :) = nOut1(4, 1:sizeMat);
ratings1_adjConc_final(2, :) = muOut1(4, 1:sizeMat);
ratings1_adjConc_final(3, :) = sigmaOut1(4, 1:sizeMat);
ratings1_adjConc_final(4, :) = zAvgOut1(4, 1:sizeMat);
ratings1_adjConc_final(5, 1) = sigmaTot1(4);
ratings1_adjConc_final(5, 2) = alpha1(4);
ratings1_adjConc_final(5, 3) = kappa1(4);
ratings1_adjConc_final(5, 4) = p1(4);
ratings1_adjConc_final(5, 6) = min(nOut1(4, :));
ratings1_adjConc_final(5, 7) = max(nOut1(4, :));

ratings2_noCheck_final = nan(5, sizeMat);
ratings2_noCheck_final(1, :) = nOut2(1, 1:sizeMat);
ratings2_noCheck_final(2, :) = muOut2(1, 1:sizeMat);
ratings2_noCheck_final(3, :) = sigmaOut2(1, 1:sizeMat);
ratings2_noCheck_final(4, :) = zAvgOut2(1, 1:sizeMat);
ratings2_noCheck_final(5, 1) = sigmaTot2(1);
ratings2_noCheck_final(5, 2) = alpha2(1);
ratings2_noCheck_final(5, 3) = kappa2(1);
ratings2_noCheck_final(5, 4) = p2(1);
ratings2_noCheck_final(5, 6) = min(nOut2(1, :));
ratings2_noCheck_final(5, 7) = max(nOut2(1, :));

ratings2_fullConc_final = nan(5, sizeMat);
ratings2_fullConc_final(1, :) = nOut2(2, 1:sizeMat);
ratings2_fullConc_final(2, :) = muOut2(2, 1:sizeMat);
ratings2_fullConc_final(3, :) = sigmaOut2(2, 1:sizeMat);
ratings2_fullConc_final(4, :) = zAvgOut2(2, 1:sizeMat);
ratings2_fullConc_final(5, 1) = sigmaTot2(2);
ratings2_fullConc_final(5, 2) = alpha2(2);
ratings2_fullConc_final(5, 3) = kappa2(2);
ratings2_fullConc_final(5, 4) = p2(2);
ratings2_fullConc_final(5, 6) = min(nOut2(2, :));
ratings2_fullConc_final(5, 7) = max(nOut2(2, :));

ratings2_dsConc_final = nan(5, sizeMat);
ratings2_dsConc_final(1, :) = nOut2(3, 1:sizeMat);
ratings2_dsConc_final(2, :) = muOut2(3, 1:sizeMat);
ratings2_dsConc_final(3, :) = sigmaOut2(3, 1:sizeMat);
ratings2_dsConc_final(4, :) = zAvgOut2(3, 1:sizeMat);
ratings2_dsConc_final(5, 1) = sigmaTot2(3);
ratings2_dsConc_final(5, 2) = alpha2(3);
ratings2_dsConc_final(5, 3) = kappa2(3);
ratings2_dsConc_final(5, 4) = p2(3);
ratings2_dsConc_final(5, 6) = min(nOut2(3, :));
ratings2_dsConc_final(5, 7) = max(nOut2(3, :));

ratings2_adjConc_final = nan(5, sizeMat);
ratings2_adjConc_final(1, :) = nOut2(4, 1:sizeMat);
ratings2_adjConc_final(2, :) = muOut2(4, 1:sizeMat);
ratings2_adjConc_final(3, :) = sigmaOut2(4, 1:sizeMat);
ratings2_adjConc_final(4, :) = zAvgOut2(4, 1:sizeMat);
ratings2_adjConc_final(5, 1) = sigmaTot2(4);
ratings2_adjConc_final(5, 2) = alpha2(4);
ratings2_adjConc_final(5, 3) = kappa2(4);
ratings2_adjConc_final(5, 4) = p2(4);
ratings2_adjConc_final(5, 6) = min(nOut2(4, :));
ratings2_adjConc_final(5, 7) = max(nOut2(4, :));

% Create large output matrices.
analysis1 = nan(23, sizeMat);
analysis1(1:5, 1:sizeMat) = ratings1_noCheck_final;
analysis1(7:11, 1:sizeMat) = ratings1_fullConc_final;
analysis1(13:17, 1:sizeMat) = ratings1_dsConc_final;
analysis1(19:23, 1:sizeMat) = ratings1_adjConc_final;

analysis2 = nan(23, sizeMat);
analysis2(1:5, 1:sizeMat) = ratings2_noCheck_final;
analysis2(7:11, 1:sizeMat) = ratings2_fullConc_final;
analysis2(13:17, 1:sizeMat) = ratings2_dsConc_final;
analysis2(19:23, 1:sizeMat) = ratings2_adjConc_final;









end