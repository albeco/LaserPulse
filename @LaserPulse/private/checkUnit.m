function [unitType, exponent, inverseUnit ] = checkUnit( inputUnit )
%CHECKUNIT checks a time/frquency unit, gives type, exponent and inverse
%
% USAGE:
% [unitType, exponent, inverseUnit ] = checkUnit( inputUnit )
%
% INPUTS:
%  inputUnit: time or frequency unit in SI notation (e.g. 'fs', 'PHz')
%
% OUTPUTS:
%  unitType: 'time' or 'frequency'
%  exponent: exponent of SI prefix, e.g. 'fs' -> -15
%  inverseUnit: unit in reciprocal domain, e.g. 'ps' -> 'THz'

% Copyright (C) 2015-2016 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt in the LaserPulse folder
% for copyright and licence notice.

persistent SIpref;
persistent timeUnits;
persistent  freqUnits
if isempty(SIpref)
  SIpref = {'y','z','a','f','p','n','u','m','','k','M','G','T','P','E','Z','Y'};
  timeUnits = arrayfun(@(x) strcat(x, 's') ,SIpref);
  freqUnits = arrayfun(@(x) strcat(x, 'Hz') ,SIpref);
end

% checks if inputUnit is a time domain unit
timeUnitIndex = find(strcmp(timeUnits, inputUnit));
if timeUnitIndex
  % it is a time domain unit
  unitType = 'time';
  exponent = 3 * (timeUnitIndex - ceil(numel(SIpref)/2));
  inverseUnit = freqUnits{numel(timeUnits)+1-timeUnitIndex};
  return;
end

% checks if inputUnit is a frequency domain unit
freqUnitIndex = find(strcmp(freqUnits, inputUnit));
if freqUnitIndex
  % it is a frequency domain unit
  unitType = 'frequency';
  exponent = 3 * (freqUnitIndex - ceil(numel(SIpref)/2));
  inverseUnit = timeUnits{numel(timeUnits)+1-freqUnitIndex};
  return;
end

error('checkUnit:ArgChk', 'unsupported unit type');

end
