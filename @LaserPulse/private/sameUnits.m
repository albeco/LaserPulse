function cmp = sameUnits(p1, p2)
%SAMEUNITS compares physical units of two LaserPulse objects

% 2015 Alberto Comin, LMU Muenchen
cmp = ...
  strcmp(p1.timeUnits, p2.timeUnits) && ...
  strcmp(p1.frequencyUnits, p2.frequencyUnits);

end