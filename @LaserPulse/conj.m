function res = conj(pulse1)
% CONJ calculates the complex conjugate of a pulse in the active domain.
%
% INPUTS:
%   pulse1: instance of LaserPulse
%
% OUTPUTS:
%   res: the resulting pulse

% Copyright (C) 2015-2016 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt in the LaserPulse folder
% for copyright and licence notice.

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

