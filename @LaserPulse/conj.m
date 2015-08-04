function res = conj(pulse1)
% CONJ calculates the complex conjugate of a pulse in time domain
%
% INPUTS:
%   pulse1: instance of LaserPulse
%   pulse2: instance of LaserPulse
%
% OUTPUTS:
%   p: the resulting pulse

% Copyright (C) 2015 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt for copyright and licence
% notice.

res = copy(pulse1);
res.temporalPhase = -res.temporalPhase;

end

