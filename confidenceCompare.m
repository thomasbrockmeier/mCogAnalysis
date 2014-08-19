function [ diffs ] = confidenceCompare()

% Import raw data from Survey Gizmo output.
import1 = importdata('rhythmmerged_YESTRAINING.xlsx');
importData1 = import1.data;

import2 = importdata('rhythmmerged_NOTRAINING.xlsx');
importData2 = import2.data;

% Truncate input to only contain confidence values.
% N.B.: ratings2 contains no judgements with confidence value '1'.
[ rhyY, ~ ] = reformatConfs(importData1);

[ rhyN, ~ ] = reformatConfs(importData2);

% Clear R and T matrices of all data, but the pairs that are available in
% the G matrix as well.
genPairID = [47 149 184 111 176 190 17 59 21 94 151 119 39 7 62 188 178 53];
genPairID = sort(genPairID);
rhythm18_Y = nan(1,18);
rhythm18_N = nan(1,18);

for i = 1:size(rhythm18_Y, 2)
    for k = 1:length(genPairID)
        rhythm18_Y(k, i) = rhyY(k, genPairID(i) + 1);
        rhythm18_N(k, i) = rhyN(k, genPairID(i) + 1);
    end
end

diffs = nan(3, size(rhyY));

for j = 1:size(rhyY, 2)
    [ p, h, u ] = ranksum(rhyY(:, j), rhyN(:, j));
    diffs(1, j) = p;
    diffs(2, j) = h;
    diffs(3, j) = u.ranksum;
end