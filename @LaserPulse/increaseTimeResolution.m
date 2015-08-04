function increaseTimeResolution(pulse, minPointsPerPeriod)
% INCREASETIMERESOLUTION pads the frequency spectrum with zeros
% to increase the resolution in time.
%
% USAGE:
% p = pulse.increaseTimeResolution(n)
% where n is the number of desired samples per optical cicle.
% If called without argument a default number of 10 points is used.
% If the current time resolution is already good enough, the
% pulse will be returned unchanged.

% Copyright (C) 2015 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt for copyright and licence
% notice.

% parsing input
defaultMinPoints  = 10;
if ~exist('minPointsPerPeriod', 'var')
    minPointsPerPeriod = defaultMinPoints;
end

% dermine the number of required points
minFreqPoints = minPointsPerPeriod * ...
    pulse.centralFrequency/pulse.frequencyStep;

% only pads the spectrum if needed
if pulse.nPoints < minFreqPoints
    noNewPoints = 2^nextpow2(minFreqPoints);
    zeropad(pulse, 'frequency', noNewPoints)
end
end