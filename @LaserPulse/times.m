function res = times(pulse1, pulse2)
% TIMES multiplies two pulses in the active domain of the first pulse.
% It is equivalent to convolution in the reciprocal domain.
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

% Copyright (C) 2015-2016 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt in the LaserPulse folder
% for copyright and licence notice.

% at least one of the arguments must be a pulse if we landed here
if ~isa(pulse2, 'LaserPulse')
  res = multByDouble(pulse1, pulse2);
elseif ~isa(pulse1, 'LaserPulse')
  res = multByDouble(pulse2, pulse1);
else % both operators are pulses
  res = binaryOperator(pulse1, pulse2, @polarTimes, pulse1.activeDomain);
end
end

function [amp, phase] = polarTimes(amp1,phase1,amp2,phase2)
amp = amp1 .* amp2 ;
phase = phase1 + phase2;
end