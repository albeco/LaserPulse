function increaseTimeResolution(pulse, noPoints, resType)
%INCREASETIMERESOLUTION pads the frequency domain with zeros.
% It increases the time resolution via Fourier transform. If the current
% time resolution is already good enough, the pulse will not be changed.
%
% USAGE:
% p = pulse.increaseTimeResolution(noPoints) or
% p = pulse.increaseTimeResolution(noPoints, 'perPeriod')
%   increases the time resolution if needed, using 'noPoints' as the
%   minumum number of time steps per optical cicle.
% p = pulse.increaseTimeResolution(noPoints, 'fwhm')
%   increases the time resolution if needed, using 'noPoints' as the
%   minumum number of time steps within the pulse duration (fwhm).
% p = pulse.increaseTimeResolution(noPoints, 'std')
%   increases the time resolution if needed, using 'noPoints' as the
%   minumum number of time steps per standard deviation.
% p = pulse.increaseTimeResolution(noPoints, 'total')
%   increases the time resolution if needed, using 'noPoints' as the
%   minumum number of time steps.
%
% INPUTS:
%   noPoints: desired minimum number of points (default: 10).
%   resType: allows to choose if 'noPoints' refers to one oscillation
%     period (resType=='period'), to the pulse duration (resType=='fwhm'),
%     to the temporal standard deviation (resType=='std') or to the total
%     number of new points (resType=='total').

% Copyright (C) 2015 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt for copyright and licence
% notice.

% parsing input
defaultMinPoints  = 10;
if ~exist('noPoints', 'var'), noPoints = defaultMinPoints; end
if ~exist('resType', 'var'), resType = 'perPeriod'; end

% dermine the number of required points
switch lower(resType)
  case 'total'
     noNewPoints = noPoints;
  case 'perperiod'
    noNewPoints = noPoints * pulse.centralFrequency/pulse.frequencyStep;
  case 'fwhm'
    noNewPoints = noPoints/pulse.duration/pulse.frequencyStep;
  case 'std'
    noNewPoints = noPoints/pulse.std('time',1)/pulse.frequencyStep;
  otherwise
    error('LaserPulse:increaseTimeResolution:argChk', 'unsupported argument type')
end

% only pads the spectrum if needed
if pulse.nPoints < noNewPoints
    zeropad(pulse, 'frequency', roundeven(noNewPoints - pulse.nPoints));
end
end