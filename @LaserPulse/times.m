function res = times(pulse1, pulse2)
% TIMES multiplies two pulses in time-domain.
% It is equivalent to convolution in frequency-domain.
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

% at least one of the arguments must be a pulse if we landed here
if ~isa(pulse2, 'LaserPulse')
  res = multByDouble(pulse1, pulse2);
elseif ~isa(pulse1, 'LaserPulse')
  res = multByDouble(pulse2, pulse1);
else % both operators are pulses
  res = binaryOperator(@polarTimes, pulse1, pulse2, 'time');
end
end

function [amp, phase] = polarTimes(amp1,phase1,amp2,phase2)
amp = amp1 .* amp2 ;
phase = phase1 + phase2;
end