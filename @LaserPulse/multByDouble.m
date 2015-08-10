function res = multByDouble(pulse1, x)
% rescales field by a numerical factor

% Copyright (C) 2015 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt for copyright and licence
% notice.

% CHANGE LOG
% 10/08/2015: added support for both time and frequency domain, and for
%             creating multidimensional arrays

res = copy(pulse1);

switch pulse1.activeDomain
  case 'time'
    res.temporalAmplitude = bsxfun(@times, pulse1.temporalAmplitude, abs(x));
    if isscalar(x)
      res.temporalPhase = bsxfun(@plus, pulse1.temporalPhase, angle(x));
    else
      res.temporalPhase = bsxfun(@plus, pulse1.temporalPhase, getUnwrappedPhase(x));
    end
  case 'frequency'
    res.spectralAmplitude = bsxfun(@times, pulse1.spectralAmplitude, abs(x));
    if isscalar(x)
      res.spectralPhase = bsxfun(@plus, pulse1.spectralPhase, angle(x));
    else
      res.spectralPhase = bsxfun(@plus, pulse1.spectralPhase, getUnwrappedPhase(x));
    end
  otherwise
    error('LaserPulse:multByDouble', 'activeDomain not properly set');
end
end