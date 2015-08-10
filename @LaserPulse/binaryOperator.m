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

%% Copyright (C) 2015 Alberto Comin, LMU Muenchen
%
%  This file is part of LaserPulse.
% 
%  LaserPulse is free software: you can redistribute it and/or modify it
%  under the terms of the GNU General Public License as published by the
%  Free Software Foundation, either version 3 of the License, or (at your
%  option) any later version. LaserPulse is distributed in the hope that
%  it will be useful, but WITHOUT ANY WARRANTY; without even the implied
%  warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
%  the GNU General Public License for more details. You should have
%  received a copy of the GNU General Public License along with
%  LaserPulse.  If not, see <http://www.gnu.org/licenses/>.

% CHANGE LOG
% 10/08/2015: now using the property activeDomain

assert(...
  isa(pulse1,'LaserPulse') && isa(pulse2,'LaserPulse') && ...
  ~strcmp(pulse1.updatedDomain_,'none') && ~strcmp(pulse2.updatedDomain_,'none'), ...
  ['LaserPulse:binaryOperator arguments of ', func2str(op),' are empty or not valid']);

if ~exist('activeDomain', 'var')
  activeDomain = pulse1.activeDomain;
end

p1 = copy(pulse1);
p2 = copy(pulse2);

% compare domains of p1 and p2; if necessary align and interpolate them
samplingTolerance = 1e-10;
matchDomains(p1, p2, samplingTolerance)

if strcmp(activeDomain, 'time') || strcmp(activeDomain, 'all')
 [newTempAmp, newTempPhase] = op( ...
   p1.temporalAmplitude, p1.temporalPhase, ...
   p2.temporalAmplitude, p2.temporalPhase);
 res = LaserPulse(p1.timeArray, p1.timeUnits, newTempAmp, newTempPhase);
elseif strcmp(activeDomain, 'frequency') 
 [newSpecAmp, newSpecPhase] = op( ...
   p1.spectralAmplitude, p1.spectralPhase, ...
   p2.spectralAmplitude, p2.spectralPhase);
 res = LaserPulse(p1.frequencyArray, p1.frequencyUnits, newSpecAmp, newSpecPhase);
else
  warning('LaserPulse:binaryOperator domains not propertly set');
end

end


