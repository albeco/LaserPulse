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
