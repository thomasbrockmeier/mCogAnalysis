function [ diffs, rhyY_vec, rhyN_vec ] = groupCompare( inputA, inputB )

% Performs a WRST on two matrices of raw data in Survey Gizmo formatting.
% Groups to be compared need to be separated by hand (e.g., in Excel).
%
% Output format:
%
%   1. Average rating inputA
%   2. Average rating inputB
%   3. p value of WRST
%   4. 1 = null hypothesis can be rejected at 5% level
%      0 = null hypothesis cannot be rejected at 5% level
%   5. U statistic
%
%
% N.B.: When approaching zero, U occasionally loses its decimal point for 
% an unknown reason. Since U becomes significant as it decreases (threshold
% value depends on N), it can be assumed that it is in fact a low number
% (and not in the hundreds of thousands or millions).

% Import raw data from Survey Gizmo output.
import1 = importdata(inputA);
importData1 = import1.data;

import2 = importdata(inputB);
importData2 = import2.data;

% Truncate input to only contain confidence values.
% N.B.: ratings2 contains no judgements with confidence value '1'.
[ rhyY, ~ ] = reformat(importData1);

[ rhyN, ~ ] = reformat(importData2);

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