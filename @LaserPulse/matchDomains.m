function matchDomains(p1, p2, tol)
%MATCHDOMAINS interpolates two LaserPulse objects to get the same sampling.
%
% USAGE:
%  matchDomains(p1, p2, tol)
%
% INPUTS:
%  p1: first pulse
%  p2: second pulse
%  tol: tolerance for comparing domain sampling
%
% If the two pulses have the same domain, they are left unchanged. If the
% sampling is the same but the number of points is different, the missing
% points are replaced with zeros. In the other cases both pulses are
% interpolated over a common domain in the frequency domain.
%
% IMPLEMENTATION NOTES:
%  The interpolation is performed in frequency domain because it is the
%  most convenient choice for optics. The reason is that the frequency
%  domain field has usually slow variations, unless the pulse is severely
%  distorted. Conversely the temporal field features always very fast
%  oscillations.

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

%% MAIN BODY
defaultTolerance = 1e-10;
if ~exist('tol', 'var'); tol = defaultTolerance; end;

assert(sameUnits(p1, p2), ...
  'LaserPulse:matchDomain cannot match domains with different units');

if sameSampling(p1, p2, tol) && sameOffsets(p1,p2, tol)
  % the two pulses share the same domain: nothing to do
  return
end

if sameOffsets(p1, p2, tol) && abs(p1.frequencyStep-p2.frequencyStep) < tol
  % we only need to extend the frequency domain of one of the two pulses
  if (p1.nPoints < p2.nPoints)
    % p1.frequencyArray is a subset of p2.frequencyArray
    zeropad(p1, 'frequency', p2.nPoints - p1.nPoints);
  else
    % p2.frequencyArray is a subset of p1.frequencyArray
    zeropad(p2, 'frequency', p1.nPoints - p2.nPoints);
  end
  return;
end

if sameOffsets(p1, p2, tol) && abs(p1.timeStep-p2.timeStep) < tol
  % we only need to extend the time domain of one of the two pulses
  if (p1.nPoints < p2.nPoints)
    % p1.timeArray is is a subset of p2.timeArray
    zeropad(p1, 'time', p2.nPoints - p1.nPoints);
  else
    % p2.timeArray is is a subset of p1.timeArray
    zeropad(p2, 'time', p1.nPoints - p2.nPoints);
  end
  return;
end

% interpolate the two pulses on a common domain.
freqStep = min(p1.frequencyStep, p2.frequencyStep);
maxFreq = max(max(p1.frequencyArray), max(p2.frequencyArray));
minFreq = min(min(p1.frequencyArray), min(p2.frequencyArray));
nPoints = roundeven((maxFreq-minFreq)/freqStep);
newFreqArray = linspace(minFreq, maxFreq, nPoints);


interpFreqDomain(p1, newFreqArray);
interpFreqDomain(p2, newFreqArray);
end
