function cmp = sameOffsets(p1,p2, tol)
%SAMEOFFSETS compares the time and frequency offsets

% 2015 Alberto Comin, LMU Muenchen.

cmp = ...
  abs(p1.frequencyOffset - p2.frequencyOffset) < tol  && ...
  abs(p1.timeOffset - p2.timeOffset)           < tol;
end