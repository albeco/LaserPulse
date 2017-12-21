function increaseNumberTimeSteps(pulse, nPoints)
% INCREASENUMBERTIMESTEPS increases nPoints keeping timeStep fixed
%
% Setting nPoints manually can affect either the frequencyStep or the
% timeStep, depending on which of the two is defined in function of the
% other.
% The increaseNumberTimeSteps function provides a reliable way to set
% nPoints while keeping timeStep fixed (frequencyStep will be adjusted
% accordingly behind the scenes)
%
% Note: this only affects the domain values and not the fields, it is only
% supposed to be used by other LaserPulse methods.
%
% See also: increaseNumberFreqSteps

% Copyright (C) 2015-2017 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt in the LaserPulse folder
% for copyright and licence notice.

% check if it is called by another LaserPulse method
x = dbstack('-completenames');
if length(x)<2 || isempty(strfind(x(2).file, 'LaserPulse'))
  error('LaserPulse:increaseNumberTimeSteps', ...
    'this method can only be called, by other LaserPulse methods');
end

oldTimeStep = pulse.timeStep;
pulse.nPoints = nPoints;
pulse.timeStep = oldTimeStep;

end
