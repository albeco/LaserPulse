function res = multByDouble(pulse1, x)
% rescales field by a numerical factor

% Copyright (C) 2015 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt for copyright and licence
% notice.

% separating two cases allows to minimize phase wrapping cause by fft
res = copy(pulse1);
if strcmp(pulse1.updatedDomain_, 'time')
  res.temporalAmplitude = pulse1.temporalAmplitude .* abs(x);
  res.temporalPhase = pulse1.temporalPhase + angle(x);
elseif strcmp(pulse1.updatedDomain_, 'frequency') || strcmp(pulse1.updatedDomain_, 'all')
  res.spectralAmplitude = pulse1.spectralAmplitude .* abs(x);
  res.spectralPhase = pulse1.spectralPhase + angle(x);
else
  warning('LaserPulse:multByDouble domains not properly set');
end
end