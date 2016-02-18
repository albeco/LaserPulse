function tau = calculateShortestDuration(pulse)
%CALCULATESHORTESTDURATION calculates the tranform limited pulse duration

% Copyright (C) 2015-2016 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt in the LaserPulse folder
% for copyright and licence notice.

% avoid changing original pulse
p0 = pulse.copy;

% set spectral phase to zero get the shortest pulse duration
p0.spectralPhase = 0 * p0.spectralPhase;

tau = p0.duration;

end