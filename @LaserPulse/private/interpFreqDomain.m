function interpFreqDomain(p, newfreq)
% INTERPFREQDOMAIN interpolates a pulse over a finer and bigger range.
%
% It uses linear interpolation and zeros for extrapolation.

% Copyright (C) 2015-2017 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt in the LaserPulse folder
% for copyright and licence notice.

p.updateField('frequency');

% save the old spectralPhase, because it automatically changes when
% resetting frequencyArray (see get.spectralPhase in LaserPulse.m).
freqArray = p.frequencyArray;
amp = p.spectralAmplitude;
phase = p.spectralPhase;

% set to zero the timeOffset because we use the property
% p.spectralPhase which already includes the offset
p.timeOffset = 0;
p.frequencyArray = newfreq;
p.spectralAmplitude = interp1(freqArray, amp, newfreq, 'linear',0);
p.spectralPhase = interp1(freqArray, phase, newfreq, 'linear', 0);

p.updatedDomain_ = 'frequency';
end
