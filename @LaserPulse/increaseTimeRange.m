function increaseTimeRange(pulse, newrange, units)
% INCREASETIMERANGE increases the time range of the pulse.
% It increases the number of time steps while keeping timeStep constant,
% then it interpolates over the frequency domain.
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

% Copyright (c) 2015-2017, Alberto Comin, LMU Muenchen


%% IMPLEMENTATION DETAILS:
%  increasing time range by interpolating over the frequency domain is
%  preferred over doing so by padding time domain arrays with zeros, 
%  to get smoother temporal field.

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
