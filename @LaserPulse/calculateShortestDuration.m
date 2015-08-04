function tau = calculateShortestDuration(pulse)
%CALCULATESHORTESTDURATION calculates the tranform limited pulse duration

% Copyright (C) 2015 Alberto Comin, LMU Muenchen

% This file is part of LaserPulse. See README.txt for copyright and licence
% notice.

% avoid changing original pulse
p0 = pulse.copy;

% set spectral phase to zero get the shortest pulse duration
p0.spectralPhase = 0;

tau = p0.duration;

end