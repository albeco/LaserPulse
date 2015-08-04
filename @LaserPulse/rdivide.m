function res = rdivide(pulse1, pulse2)
% RDIVIDE calculates the ratio of two pulses is time-domain.
% It is equivalent to a deconvolution in frequency domain.
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

% at least one of the arguments must be a pulse if we landed here
if isa(pulse1, 'LaserPulse') && isa(pulse2, 'LaserPulse')
  % both pulse1 and pulse2 are instances of LaserPulse
  res = binaryOperator(@polarRDivide, pulse1, pulse2, 'time');
elseif ~isa(pulse2, 'LaserPulse')
  % pulse2 is numeric scalar or array
  assert(isnumeric(pulse2), ...
    'LaserPulse:rdivide unsupported type of dividend');
  assert(size(pulse2)==size(pulse1.temporalAmplitude), ...
    'LaserPulse:rdivide operands must have the same size');
  res = multByDouble(pulse1, 1./pulse2);
else
  % pulse1 is numeric scalar or array
  assert(isnumeric(pulse1), ...
    'LaserPulse:rdivide unsupported type of divisor');
  assert(isscalar(pulse1) || ...
    all(size(pulse1)==size(pulse2.temporalAmplitude)), ...
    'LaserPulse:rdivide operands must have the same size');
  amp = abs(pulse1) ./ (pulse2.temporalAmplitude+eps);
  if isscalar(pulse1)
    phi = angle(pulse1) - pulse2.temporalPhase;
  else
    phi = getUnwrappedPhase(pulse1) - pulse2.temporalPhase;
  end
  res = LaserPulse(pulse2.timeArray, pulse2.timeUnits, amp, phi);
end

end

function [amp, phase] = polarRDivide(amp1,phase1,amp2,phase2)
amp = amp1 ./ (amp2+eps);
phase = phase1 - phase2;
end