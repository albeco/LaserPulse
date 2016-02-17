function ac = autocorrelation(pulse)
% AUTOCORRELATION gives the interferometric autocorrelation
%
% USAGE:
% ac = pulse.autocorrelation()
%
% REQUIRES:
% LaserPulse class

% Copyright (C) 2015-2016 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt in the LaserPulse folder
% for copyright and licence notice.

assert(isvector(pulse.temporalField), ...
  'LaserPulse:autocorrelation pulse must be 1D');

dt = pulse.timeStep;
N = pulse.nPoints;
efield = pulse.temporalField;

%% Pulse Pairs
% create matrix to hold N time shifted pulse pairs
pulserep = zeros(N);
% sum the original pulse with time shifted replicas
for i = 1 : size(pulserep, 2)
  pulserep(:,i) = efield + circshift(efield, 1-i);
end
% bring time0 to the center
pulserep = fftshift(pulserep,2);

%% Second Harmonic Generation
% calculate second harmonic intensity
pulserep = abs(pulserep.^2).^2;

%% Autocorrelation
% integrate over time
ac = dt * sum(pulserep, 1);
% convert to column form
ac = reshape(ac, [], 1);

end