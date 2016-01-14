function res = multByDouble(pulse, x)
% MULTBYDOUBLE multiplies a pulse by a numerical factor or numerical array

% Copyright (C) 2015 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt for copyright and licence
% notice.

% CHANGE LOG
% 10/08/2015: added support for both time and frequency domain, and for
%             creating multidimensional arrays

res = copy(pulse);

% transform x into polar coordinates
amplitude = abs(x);
if isscalar(x)
  phase = angle(x);
else
  phase = getUnwrappedPhase(x);
end

switch pulse.activeDomain
  case 'time'
    res.temporalAmplitude = bsxfun(@times, pulse.temporalAmplitude, amplitude);
    res.temporalPhase = bsxfun(@plus, pulse.temporalPhase, phase);
  case 'frequency'
    res.spectralAmplitude = bsxfun(@times, pulse.spectralAmplitude, amplitude);
    res.spectralPhase = bsxfun(@plus, pulse.spectralPhase, phase);
  otherwise
    error('LaserPulse:multByDouble', 'activeDomain not properly set');
end
end