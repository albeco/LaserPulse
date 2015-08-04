function res = power(pulse1, n)
% POWER calculates the n-th power of a pulse in time domain.
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

% at least one of the arguments must be a pulse if we landed here
if isa(n, 'LaserPulse')
  res = [];
  warning('LaserPulse:power a pulse cannot be used as exponent');
else
  res = copy(pulse1);
  res.temporalAmplitude = (res.temporalAmplitude).^n;
  res.temporalPhase = res.temporalPhase .* n;
end

end
