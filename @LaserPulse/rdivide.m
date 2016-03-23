function res = rdivide(pulse1, pulse2)
% RDIVIDE calculates the ratio of two pulses in the active domain of the first pulse.
% It is equivalent to a deconvolution in the reciprocal.
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

% Copyright (C) 2015-2016 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt in the LaserPulse folder
% for copyright and licence notice.

% at least one of the arguments must be a LaserPulse if we landed here
%% check if the type of both operands is LaserPulse
if isa(pulse1, 'LaserPulse') && isa(pulse2, 'LaserPulse')
  % both pulse1 and pulse2 are instances of LaserPulse
  res = binaryOperator(pulse1, pulse2, @polarRDivide, pulse1.activeDomain);
  return
end

%% check if the second operand is not a LaserPulse
if ~isa(pulse2, 'LaserPulse')
  % pulse2 is numeric scalar or array
  assert(isnumeric(pulse2), ...
    'LaserPulse:rdivide unsupported type of dividend');
  res = multByDouble(pulse1, 1./pulse2);
  return
end

%% pulse1 is numeric and pulse2 is a LaserPulse
assert(isnumeric(pulse1), ...
  'LaserPulse:rdivide unsupported type of divisor');

switch pulse2.activeDomain
  case 'time'
    x = pulse2.timeArray;
    units = pulse2.timeUnits;
    amp = bsxfun(@rdivide, abs(pulse1), (pulse2.temporalAmplitude + eps));
    if isscalar(pulse1)
      phi = bsxfun(@minus, angle(pulse1), pulse2.temporalPhase);
    else
      phi = bsxfun(@minus, getUnwrappedPhase(pulse1), pulse2.temporalPhase);
    end
  case 'frequency'
    x = pulse2.frequencyArray;
    units = pulse2.frequencyUnits;
    amp = bsxfun(@rdivide, abs(pulse1), (pulse2.spectralAmplitude + eps));
    if isscalar(pulse1)
      phi = bsxfun(@minus, angle(pulse1), pulse2.spectralPhase);
    else
      phi = bsxfun(@minus, getUnwrappedPhase(pulse1), pulse2.spectralPhase);
    end
end

res = LaserPulse(x, units, amp, phi);

end


function [amp, phase] = polarRDivide(amp1,phase1,amp2,phase2)
amp = amp1 ./ (amp2+eps);
phase = phase1 - phase2;
end