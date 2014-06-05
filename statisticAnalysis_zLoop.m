function [ ratings2_fullConc, zRemoval ] = statisticAnalysis_zLoop(fileName)
% (Rhythm) data analysis script.
%
%
% ADJUSTED VERSION: REACHES TARGET ALPHA VALUE BY REMOVING HIGHEST AVERAGE
%                   ABSOLUTE Z-SCORE FROM DATA POOL THROUGH WHILE-LOOP.
%
%
%
% N.B.: FIRST AND LAST COLUMNS OF ALL MATRICES AND VECTORS CONTAIN DATA
% FROM SAFETY PAIRS. THE EXPERIMENT CONTAINED N = 190 PAIRS, ALL (M x N) 
% MATRICES AND VECTORS ARE N + 2 IN SIZE.
%
% Output consists of:
%                   - New data matrix with bad (high Z) pairs removed.
%                   - List of removed pairs with their Z-scores.
%
% N.B.              - Responses with confidence level 1 are not being
%                     taken into account.
%                   - Only participants with fully concordant responses to
%                     the safety pairs are taken into account.
%
%
% CURRENT VERSIONS:
% Rhythm:
% [ ratings2_fullConc, zRemoval ] = statisticAnalysis_zLoop('rhythmmerged20140522.xlsx');
%
% Timbre:
% [ ratings2_fullConc, zRemoval ] = statisticAnalysis_zLoop('timbremerged20140522.xlsx');
%
% General:
% [ ratings2_fullConc, zRemoval ] = statisticAnalysis_zLoop('general20140522.xlsx');


% Supply target alpha:
targetAlpha = 0.45;

% Import raw data from Survey Gizmo output.
import = importdata(fileName);
importData = import.data;
importText = import.textdata;

% Truncate input to only contain ratings.
% N.B.: ratings2 contains no judgements with confidence value '1'.
[ ~, ratings2_noCheck ] = reformat(importData);

% Check for discrepancies in the ratings of the safety pairs.
ratings2_fullConc = safetyCheck(ratings2_noCheck, 1, 0);

% Get absolute average Z-scores:
[ ~, ~, ~, zAvg ] = descriptives(ratings2_fullConc);
zAvg = abs(zAvg);

% Add pair numbers.
zAvg(2, :) = zAvg(1, :);
zAvg(1, :) = 1:size(zAvg, 2);

% Get highest Z-score and pair number.
[ zMaxVal, zMaxCoo ] = max(zAvg(2, :));
zRemoval(1, 1) = zAvg(1, zMaxCoo);
zRemoval(1, 2) = zMaxVal;

% Calculate Krippendorff's alpha.
dataType = 'interval';
currentAlpha = kriAlpha(ratings2_fullConc, dataType);

counter = 0;
while currentAlpha < targetAlpha
    counter = counter + 1;
    
    % Get highest Z-score and pair number.
    [ zMaxVal, zMaxCoo ] = max(zAvg(2, :));
    zRemoval(counter, 1) = zAvg(1, zMaxCoo);
    zRemoval(counter, 2) = zMaxVal;

    % Remove highest Z-score pair from pool and Z-score vector.
    ratings2_fullConc(:, zMaxCoo) = [];
    zAvg(:, zMaxCoo) = [];
    
    % Recalculate Krippendorff's alpha.
    currentAlpha = kriAlpha(ratings2_fullConc, dataType);
    
end

fprintf('%2.0f pairs removed to achieve alpha = %1.4f.\n', counter, currentAlpha)

end