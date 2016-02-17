function res = binaryOperator(op, pulse1, pulse2, activeDomain)
% BINARYOPERATOR applies a binary operator to two LaserPulse objects.
%
% EXAMPLE:
% p = binaryOperator(@func, p1, p2, 'frequency')
%  calculates p == amp*exp(1i*phase) in frequency domain
%  from p1 == a1(f)*exp(1i*phi1(f)) and p2 == a2(f)*exp(1i*phi2(f))
%  using [amp,phase] = func(a1,phi1,a2,phi2).
%
% INPUTS:
%   op: handle to a function [amp,phase] = f(amp1,phase1,amp2,phase2)
%   pulse1: instance of LaserPulse pulse2: instance of LaserPulse
%   activeDomain (optional): domain in which the binary operator is
%   applied. If not specified the domain specified by the property
%   'updatedDomain_' is used. If both domains are currently updated
%   (updatedDomain_=='all'), the time domain is used.
%
% OUTPUTS:
%   p: the output pulse
%
% If not specified otherwise, the operator is applied on the active domain
% of the first pulse.

%% Copyright (c) 2015-2016, Alberto Comin, LMU Muenchen
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
%
% 1. Redistributions of source code must retain the above copyright notice,
% this list of conditions and the following disclaimer.
%
% 2. Redistributions in binary form must reproduce the above copyright
% notice, this list of conditions and the following disclaimer in the
% documentation and/or other materials provided with the distribution.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
% IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
% THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
% PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
% CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
% EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
% PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
% PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
% LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
% NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

assert(...
  isa(pulse1,'LaserPulse') && isa(pulse2,'LaserPulse') && ...
  ~strcmp(pulse1.updatedDomain_,'none') && ~strcmp(pulse2.updatedDomain_,'none'), ...
  ['LaserPulse:binaryOperator arguments of ', func2str(op),' are empty or not valid']);

if ~exist('activeDomain', 'var')
  activeDomain = pulse1.activeDomain;
end

% check if active domain are different, and warn the user if they are
if ~strcmp(pulse1.activeDomain, pulse2.activeDomain)
  fprintf(['\nWarning: The two operands of "%s" have different ', ...
    'activeDomain.\n Applying %s in the activeDomain of the ', ...
    'first operator (%s).\n'], func2str(op), func2str(op), pulse1.activeDomain);
end

% create local copies because LaserPulse objects are copied by reference
p1 = copy(pulse1);
p2 = copy(pulse2);

% compare domains of p1 and p2; if necessary align and interpolate them
samplingTolerance = 1e-10;
matchDomains(p1, p2, samplingTolerance)

switch activeDomain
  case 'time'
    [newTempAmp, newTempPhase] = op( ...
      p1.temporalAmplitude, p1.temporalPhase, ...
      p2.temporalAmplitude, p2.temporalPhase);
    res = LaserPulse(p1.timeArray, p1.timeUnits, newTempAmp, newTempPhase);
  case 'frequency'
    [newSpecAmp, newSpecPhase] = op( ...
      p1.spectralAmplitude, p1.spectralPhase, ...
      p2.spectralAmplitude, p2.spectralPhase);
    res = LaserPulse(p1.frequencyArray, p1.frequencyUnits, newSpecAmp, newSpecPhase);
  otherwise
    warning('LaserPulse:binaryOperator domains not propertly set');
end

end


