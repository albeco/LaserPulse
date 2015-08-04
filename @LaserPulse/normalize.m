function normalize(pulse)
% NORMALIZE rescales the pulse to unit area

% Copyright (C) 2015 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt for copyright and licence
% notice.

% normalize on active domain to avoid phase wrapping caused by fft
if strcmp(pulse.updatedDomain_, 'time')
  area = trapz(pulse.timeArray, (pulse.temporalAmplitude).^2);
  pulse.temporalAmplitude = pulse.temporalAmplitude / sqrt(area);
else
  area = trapz(pulse.frequencyArray, (pulse.spectralAmplitude).^2);
  pulse.spectralAmplitude = pulse.spectralAmplitude / sqrt(area);
end