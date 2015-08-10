function normalize(pulse)
% NORMALIZE rescales the pulse to unit area

% Copyright (C) 2015 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt for copyright and licence
% notice.

% CHANGE LOG
% 10/08/2015: now using activeDomain instead of updatedDomain_

% normalize on active domain to avoid phase wrapping caused by fft
switch pulse.activeDomain
  case 'time'
    area = trapz(pulse.timeArray, (pulse.temporalAmplitude).^2);
    pulse.temporalAmplitude = pulse.temporalAmplitude / sqrt(area);
  case 'frequency'
    area = trapz(pulse.frequencyArray, (pulse.spectralAmplitude).^2);
    pulse.spectralAmplitude = pulse.spectralAmplitude / sqrt(area);
  otherwise
    error('LaserPulse:normalize', 'activeDomain not properly set');
end

end