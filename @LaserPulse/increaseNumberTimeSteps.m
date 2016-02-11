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
% See also: increaseNumberFreqSteps

% 2015-2016 Alberto Comin, LMU Muenchen

oldTimeStep = pulse.timeStep;
pulse.nPoints = nPoints;
pulse.timeStep = oldTimeStep;

end