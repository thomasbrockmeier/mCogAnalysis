function output = groupDiff( sample1, sample2 )
% Computes Wilcoxon Rank Sum Test and two-sample t-Test, for all pairs.
%
% Every column represents one pair, the first three rows represent the WRST
% (p-value, reject null-hypothesis (if 0), rank sum (U). Row five contains
% the number of pairs for which the null-hypothesis may be rejected and the
% total number of pairs.
%
% The rows from seven onward represent the t-test(p-value, reject 
% null-hypothesis (if 0), confidence intervals one and two, t-statistic,
% degrees of freedom, standard deviation and the number of pairs for which 
% the null-hypothesis may be rejected and the total number of pairs.
%
% The second to last row contains a flag if null-hypothesis rejection is
% different between WRST and t-Test, the last row contains the number of
% times this occurred.


% Import raw data from Survey Gizmo output.
import1 = importdata(sample1);
importData1 = import1.data;

import2 = importdata(sample2);
importData2 = import2.data;

% Import pair list.
% trackNames = importdata('track_pair_lists.xlsx');
% pairList = trackNames.textdata.Sheet2;

% Truncate input to only contain ratings.
% N.B.: ratings2 contains no judgements with confidence value '1'.
[ ratings1s1_noCheck, ~ ] = reformat(importData1);

[ ratings1s2_noCheck, ~ ] = reformat(importData2);

% Check for discrepancies in the ratings of the safety pairs.
% ratings1s2_fullConc = safetyCheck(ratings1s2_noCheck, 1, 0);
% ratings2s2_fullConc = safetyCheck(ratings2s2_noCheck, 1, 0);
% 
% ratings1s2_dsConc = safetyCheck(ratings1s2_noCheck, 2, 1);
% ratings2s2_dsConc = safetyCheck(ratings2s2_noCheck, 2, 1);
% 
% ratings1s2_adjConc = safetyCheck(ratings1s2_noCheck, 3, 1);
% ratings2s2_adjConc = safetyCheck(ratings2s2_noCheck, 3, 1);
% 
% ratings1s2_fullConc = safetyCheck(ratings1s2_noCheck, 1, 0);
% ratings2s2_fullConc = safetyCheck(ratings2s2_noCheck, 1, 0);
% 
% ratings1s2_dsConc = safetyCheck(ratings1s2_noCheck, 2, 1);
% ratings2s2_dsConc = safetyCheck(ratings2s2_noCheck, 2, 1);
% 
% ratings1s2_adjConc = safetyCheck(ratings1s2_noCheck, 3, 1);
% ratings2s2_adjConc = safetyCheck(ratings2s2_noCheck, 3, 1);

% Remove safety pairs from ratingsN_noCheck.
ratings1s1_noCheck(:, 1) = [];
% ratings2s1_noCheck(:, 1) = [];
ratings1s1_noCheck(:, end) = [];
% ratings2s1_noCheck(:, end) = [];

ratings1s2_noCheck(:, 1) = [];
% ratings2s2_noCheck(:, 1) = [];
ratings1s2_noCheck(:, end) = [];
% ratings2s2_noCheck(:, end) = [];

% ratings1s1_noCheck = sample1;
% ratings1s2_noCheck = sample2;

% Create output matrix.
output = nan(3, 1);
% output(18, 1) = 0;

counter = 0;

% Check if pair 'i' was rated differently by the different groups.
for i = 1:size(ratings1s1_noCheck, 2)
    % Wilcoxon Rank Sum Test.
    try
        [ p, h, stats ] = ranksum(ratings1s1_noCheck(:, i), ratings1s2_noCheck(:, i));
    catch err
        continue
    end
    if h == 1
            counter = counter + 1;
            output(1, counter) = i;
            output(2, counter) = stats.ranksum;
            output(3, counter) = p;
    end
    
%     % t-Test.
%     [ h, p, ci, stats ] = ttest2(ratings1s1_noCheck(:, i), ratings1s2_noCheck(:, i));
%     output(7, i) = p;
%     output(8, i) = h;
%     output(9, i) = ci(1);
%     output(10, i) = ci(2);
%     output(11, i) = stats.tstat;
%     output(12, i) = stats.df;
%     output(13, i) = stats.sd;
%     output(15, 1) = sum(output(8, :));
%     output(15, 2) = size(ratings1s1_noCheck, 2);
%     
%     % Check for differences between WRST and t-Test null-hypothesis
%     % rejection.
%     if output(2, i) ~= output(8, i)
%         output(17, i) = 12321;
%         output(18, 1) = output(18, 1) + 1;
%     end
end