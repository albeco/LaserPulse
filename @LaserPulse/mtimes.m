function res = mtimes(pulse1, pulse2)
% MTIMES multiplies two pulses in time-domain.
% It is equivalent to convolution in frequency-domain.
%
% In this implementation mtimes is the same as times.
%
% INPUTS:
%   pulse1: instance of LaserPulse
%   pulse2: instance of LaserPulse
%
% OUTPUTS:
%   p: the multiplied pulse
%
% If the two pulses have different sampling , they are interpolated over a
% commond domain.

% Copyright (C) 2015 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt for copyright and licence
% notice.

res = times(pulse1,pulse2);

end

