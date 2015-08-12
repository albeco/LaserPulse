function res = conj(pulse1)
% CONJ calculates the complex conjugate of a pulse in the active domain.
%
% INPUTS:
%   pulse1: instance of LaserPulse
%
% OUTPUTS:
%   res: the resulting pulse

% Copyright (C) 2015 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt for copyright and licence
% notice.

% CHANGE LOG
% 10/08/2015: added support for both time and frequency domain 

res = copy(pulse1);

switch pulse1.activeDomain
  case 'time'
    res.temporalPhase = -res.temporalPhase;
  case 'frequency'
    res.spectralPhase = -res.spectralPhase;
  otherwise
      error('LaserPulse:conj', 'activeDomain not properly set');
end

end

