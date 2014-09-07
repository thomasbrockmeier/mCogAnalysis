function [ kappa_refInDS, p_refInDS, kappa_refInAdj, p_refInAdj ] = getKappa(data)

import = importdata(data);
importData = import.data;
refIn = reformat(importData);
refInDS = safetyCheck(refIn, 4, 1);
refInAdj = safetyCheck(refIn, 3, 1);
[kappa_refInDS, p_refInDS] = waterDeity(refInDS, 1000);
[kappa_refInAdj, p_refInAdj] = waterDeity(refInAdj, 1000);