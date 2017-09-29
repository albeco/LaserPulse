function increaseTimeRange(pulse, newrange, units)
% INCREASETIMERANGE increases the time range of the pulse.
% It increases the number of time steps while keeping timeStep constant,
% zhen it interpolates over the frequency domain.
%
% USAGE:
% for setting a new range of (deltaT) femtoseconds
% pulse.increaseTimeRange(deltaT)
% pulse.increaseTimeRange(deltaT ,'fs')
%
% for setting a range of n times the pulse duration (fwhm)
% pulse.increaseTimeRange(deltaT, 'fwhm'); 
%
% for setting a range of n standard deviations
% pulse.increaseTimeRange(n, 'std')

%% Copyright (c) 2015-2017, Alberto Comin, LMU Muenchen
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

%% IMPLEMENTATION DETAILS:
%  increasing time range by interpolating over the frequency domain is
%  better than doing so by padding time domain arrays with zeros, because
%  in the second case the temporal field is not changed.

%% MAIN BODY:
if ~exist('units', 'var')
  newTimeRange = newrange;
elseif strcmp(units, 'fwhm')
  newTimeRange = newrange * pulse.duration;
elseif strcmp(units, 'std')
  newTimeRange = newrange * pulse.std('time');
else
  % check if 'units' is a valid SI time unit
  try
    timeunit = WaveUnit(units);
    assert(strcmp(timeunit.dimension, 'time'));
    newTimeRange = WaveUnit.convert(newrange, timeunit, pulse.timeUnits);
  catch
    error('LaserPulse:increasTimeRage:argChk', 'unsupported unit type');
  end
end

% determine the number of required points
new_nPoints = roundeven(newTimeRange/pulse.timeStep);

if pulse.nPoints < new_nPoints
  % update frequency domain before changing step sizes, to avoid rescaling
  % signal amplitude when calculating fft integrals (see updateField.m)
  pulse.updateField('frequency');
  oldFreqArray = pulse.shiftedFreqArray_;
  % decrease frequencyStep by increasing nPoints keeping timeStep fixed
  pulse.increaseNumberTimeSteps(new_nPoints);
  % pulse.shiftedFreqArray_ has been automatically updated
  pulse.specAmp_ = interp1(oldFreqArray, pulse.specAmp_, ...
    pulse.shiftedFreqArray_, 'pchip',0);
  pulse.specPhase_ = interp1(oldFreqArray, pulse.specPhase_, ...
    pulse.shiftedFreqArray_, 'pchip',0);
  pulse.updatedDomain_ = 'frequency';
end
end
