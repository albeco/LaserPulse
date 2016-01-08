function increaseTimeRange(pulse, newrange, units)
% INCREASETIMERANGE increases the time range of the pulse.
% In order to increase the time range, the frequency step is made smaller.
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

%% IMPLEMENTATION DETAILS:
%  increasing time range by reducing the frequency step is better than doing
%  so by padding time domain arrays with zeros, because in the second case
%  the temporal field is not changed.

%% MAIN BODY:
if ~exist('units', 'var') || strcmp(units, 'fs')
  newTimeRange = newrange;
elseif strcmp(units, 'fwhm')
  newTimeRange = newrange * pulse.duration;
elseif strcmp(units, 'std')
  newTimeRange = newrange * pulse.std('time');
else
  error('LaserPulse:increasTimeRage:argChk', 'unsupported unit type');
end

% dermine the number of required points
minTimePoints = newTimeRange/pulse.timeStep;

if pulse.nPoints < minTimePoints
  pulse.updateField('frequency');
  nOldPoints = pulse.nPoints;
  oldFreqStep = pulse.frequencyStep;
  oldFreqArray = pulse.shiftedFreqArray_;
  % it is enough to change nPoints and frequencyStep, to update both time
  % and frequency arrays
  pulse.nPoints = roundeven(minTimePoints);
  pulse.frequencyStep = oldFreqStep * nOldPoints / pulse.nPoints;
  % now pulse.shiftedFreqArray_ has been automatically updated
  pulse.specAmp_ = interp1(oldFreqArray, pulse.specAmp_, pulse.shiftedFreqArray_, 'pchip',0);
  pulse.specPhase_ = interp1(oldFreqArray, pulse.specPhase_, pulse.shiftedFreqArray_, 'pchip',0);
  pulse.updatedDomain_ = 'frequency';
end
end