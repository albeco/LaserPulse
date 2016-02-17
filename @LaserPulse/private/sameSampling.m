function cmp = sameSampling(p1,p2, tol)
%SAMESAMPLING compares time and frequency steps and number of points

% Copyright (C) 2015-2016 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt in the LaserPulse folder
% for copyright and licence notice.

cmp = ...
  (p1.nPoints == p2.nPoints) && ...
  abs(p1.frequencyStep - p2.frequencyStep) < tol;
% dt*df == 1/N, so there is no need to compare the time steps
end