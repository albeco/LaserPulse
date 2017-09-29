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

% Copyright (C) 2015-2017 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt in the LaserPulse folder
% for copyright and licence notice.

oldFreqStep = pulse.frequencyStep;
pulse.nPoints = nPoints;
pulse.frequencyStep = oldFreqStep;

end
