function cmp = sameUnits(p1, p2)
%SAMEUNITS compares physical units of two LaserPulse objects

% Copyright (C) 2015-2016 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt in the LaserPulse folder
% for copyright and licence notice.

cmp = ...
  strcmp(p1.timeUnits, p2.timeUnits) && ...
  strcmp(p1.frequencyUnits, p2.frequencyUnits);

end