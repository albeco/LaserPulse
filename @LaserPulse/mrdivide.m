function res = mrdivide(pulse1, pulse2)
% MRDIVIDE calculates the ratio of two pulses in the active domain of the first pulse.
% It is equivalent to a deconvolution in frequency domain.
% 
% In this implementation, it is equivalent to rdivide.
%
% INPUTS:
%   pulse1: instance of LaserPulse
%   pulse2: instance of LaserPulse
%
% OUTPUTS:
%   p: the ratio of the pulses
%
% If the two pulses have different sampling , they are interpolated over a
% commond domain.

% Copyright (C) 2015 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt for copyright and licence
% notice.

res = rdivide(pulse1, pulse2);

end

