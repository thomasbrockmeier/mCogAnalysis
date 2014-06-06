function [ dataMatrix ] = statisticAnalysis_ptcptRemoval(fileName)
% (Rhythm) data analysis script.
%
%
% ADJUSTED VERSION: REACHES TARGET ALPHA VALUE BY REMOVING PARTICIPANTS
%                   DETRIMENTAL TO ALPHA FROM POOL THROUGH WHILE-LOOP.
%
%
%
% N.B.: FIRST AND LAST COLUMNS OF ALL MATRICES AND VECTORS CONTAIN DATA
% FROM SAFETY PAIRS. THE EXPERIMENT CONTAINED N = 190 PAIRS, ALL (M x N) 
% MATRICES AND VECTORS ARE N + 2 IN SIZE.
%
% Output consists of:
%                   - New data matrix with bad (high Z) pairs removed.
%
% N.B.              - Responses with confidence level 1 are not being
%                     taken into account.
%                   - Only participants with fully concordant responses to
%                     the safety pairs are taken into account.
%
%
% CURRENT VERSIONS:
% Rhythm:
% [ ratings2_fullConc ] = statisticAnalysis_ptcptRemoval('rhythmmerged20140522.xlsx');
%
% Timbre:
% [ ratings2_fullConc ] = statisticAnalysis_ptcptRemoval('timbremerged20140522.xlsx');
%
% General:
% [ ratings2_fullConc ] = statisticAnalysis_ptcptRemoval('general20140522.xlsx');


% Supply target alpha:
targetAlpha = 0.45;

% Import raw data from Survey Gizmo output.
import = importdata(fileName);
importData = import.data;
importText = import.textdata;

% Truncate input to only contain ratings.
% N.B.: ratings2 contains no judgements with confidence value '1'.
[ ~, dataMatrix ] = reformat(importData);

% Check for discrepancies in the ratings of the safety pairs.
dataMatrix = safetyCheck(dataMatrix, 1, 0);

% Calculate Krippendorff's alpha.
dataType = 'interval';
currentAlpha = kriAlpha(dataMatrix, dataType);

counter = 0;
while currentAlpha < targetAlpha
    counter = counter + 1;
    
    % Test for effect of removing participants on alpha.
    for i = 1:size(dataMatrix, 1)
        % Duplicate matrix.
        dataMatrixTemp = dataMatrix;
        
        % Remove participant i.
        dataMatrixTemp(i, :) = [];
        currentAlphaTemp(i) = kriAlpha(dataMatrixTemp, dataType);
    end
    
    % Get participant ID with most detrimental effect on alpha and remove.
    [ ~, currentAlphaIndex ] = min(currentAlphaTemp);
    dataMatrix(currentAlphaIndex, :) = [];
    
    currentAlpha = kriAlpha(dataMatrix, dataType);
    disp(currentAlpha)
end

fprintf('%2.0f participants removed to achieve alpha = %1.4f.\n', counter, currentAlpha)

end