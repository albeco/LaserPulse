function normalize(pulse)
% NORMALIZE rescales the pulse to unit area

% Copyright (C) 2015-2017 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt in the LaserPulse folder
% for copyright and licence notice.

% normalize on the updated domain to avoid phase wrapping caused by fft
switch pulse.updatedDomain_
  case {'time', 'all'}
    area = trapz(pulse.timeArray, (pulse.temporalAmplitude).^2);
    pulse.temporalAmplitude = pulse.temporalAmplitude / sqrt(area);
  case 'frequency'
    area = trapz(pulse.frequencyArray, (pulse.spectralAmplitude).^2);
    pulse.spectralAmplitude = pulse.spectralAmplitude / sqrt(area);
  otherwise
    error('LaserPulse:normalize', 'activeDomain not properly set');
end

end
