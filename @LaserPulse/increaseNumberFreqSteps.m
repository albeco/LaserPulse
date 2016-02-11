function increaseNumberFreqSteps(pulse, nPoints)
% INCREASENUMBERFREQSTEPS increases nPoints keeping frequencyStep fixed
%
% Setting nPoints manually can affect either the frequencyStep or the
% timeStep, depending on which of the two is defined in function of the
% other.
% The increaseNumberFreqSteps function provides a reliable way to set
% nPoints while keeping frequencyStep fixed (timeStep will be adjusted
% accordingly behind the scenes)
%
% See also: increaseNumberTimeSteps

% 2015-2016 Alberto Comin, LMU Muenchen

oldFreqStep = pulse.frequencyStep;
pulse.nPoints = nPoints;
pulse.frequencyStep = oldFreqStep;

end