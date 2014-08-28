function [ diffs ] = confidenceCompare()

% Import raw data from Survey Gizmo output.
import1 = importdata('rhythmMergedMale.xlsx');
importData1 = import1.data;

import2 = importdata('rhythmMergedFemale.xlsx');
importData2 = import2.data;

% Truncate input to only contain confidence values.
% N.B.: ratings2 contains no judgements with confidence value '1'.
[ rhyY, ~ ] = reformatConfs(importData1);

[ rhyN, ~ ] = reformatConfs(importData2);

rhyY_vec = rhyY(:)';
rhyN_vec = rhyN(:)';
rhyY_vec(isnan(rhyY_vec)) = [];
rhyN_vec(isnan(rhyN_vec)) = [];

[ p, h, u ] = ranksum(rhyY_vec, rhyN_vec);
diffs(1, 1) = sum(rhyY_vec) / length(rhyY_vec);
diffs(2, 1) = sum(rhyN_vec) / length(rhyN_vec);
diffs(3, 1) = p;
diffs(4, 1) = h;
diffs(5, 1) = u.ranksum;