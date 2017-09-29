function zeropad(p, domain, nExtraPoints)
% ZEROPAD extend the time or frequency domain by filling it with zeros

% Copyright (C) 2015-2017 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt in the LaserPulse folder
% for copyright and licence notice.

% make sure nExtraPoints is positive integer
if ~isnumeric(nExtraPoints) || ~isfinite(nExtraPoints) || ...
    nExtraPoints < 0 || mod(nExtraPoints, 1) ~= 0
  error('LaserPulse:zeropad:argChk', ...
    'The number of extra points must be a positive integer.');
end

p.updateField(domain);
arraySize = size(p);
% to double-check following lines run centeredRange(n) and see where zero goes
if rem(p.nPoints, 2) == 0 % even number of previuos points
  leftZeros = zeros([floor(nExtraPoints/2), arraySize(2:end)]);
  rightZeros = zeros([ceil(nExtraPoints/2), arraySize(2:end)]);
else                       % odd number of previuos points
  leftZeros = zeros([ceil(nExtraPoints/2), arraySize(2:end)]);
  rightZeros = zeros([floor(nExtraPoints/2), arraySize(2:end)]);
end

if strcmp(domain, 'time')
  p.increaseNumberTimeSteps(p.nPoints + nExtraPoints);
  p.tempAmp_ = [leftZeros; p.tempAmp_; rightZeros];
  p.tempPhase_ = [leftZeros; p.tempPhase_; rightZeros];
elseif strcmp(domain, 'frequency')
  p.increaseNumberFreqSteps(p.nPoints + nExtraPoints);
  p.specAmp_ = [leftZeros; p.specAmp_; rightZeros];
  p.specPhase_ = [leftZeros; p.specPhase_; rightZeros];
else
  error('LaserPulse:zeropad', 'not supported domain type');
end
p.updatedDomain_ = domain;
end
