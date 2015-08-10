function res = power(pulse1, n)
% POWER calculates the n-th power of a pulse in the active domain.
%
% INPUTS:
%   pulse1: instance of LaserPulse
%   n: the exponent (double)
%
% OUTPUTS:
%   p: the resulting pulse

% Copyright (C) 2015 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt for copyright and licence
% notice.

% CHANGE LOG
% 10/08/2015: added support for both time and frequency domain 

% at least one of the arguments must be a pulse if we landed here
if isa(n, 'LaserPulse')
  res = [];
  warning('LaserPulse:power a pulse cannot be used as exponent');
  return
end

res = copy(pulse1);

switch pulse1.activeDomain
  case 'time'
    res.temporalAmplitude = (res.temporalAmplitude).^n;
    res.temporalPhase = res.temporalPhase .* n;
  case 'frequency'
    res.spectralAmplitude = (res.spectralAmplitude).^n;
    res.spectralPhase = res.spectralPhase .* n;
  otherwise
    error('LaserPulse:normalize', 'activeDomain not properly set');
end

end
