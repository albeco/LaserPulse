function cmp = sameOffsets(p1,p2, tol)
%SAMEOFFSETS compares the time and frequency offsets

% Copyright (C) 2015-2016 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt in the LaserPulse folder
% for copyright and licence notice.

cmp = ...
  abs(p1.frequencyOffset - p2.frequencyOffset) < tol  && ...
  abs(p1.timeOffset - p2.timeOffset)           < tol;
end