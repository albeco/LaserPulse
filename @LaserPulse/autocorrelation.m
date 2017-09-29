function ac = autocorrelation(pulse, order)
% AUTOCORRELATION gives the interferometric autocorrelation
%
% USAGE:
% ac = pulse.autocorrelation()
% ac = pulse.autocorrelation(order)
% if not specified it is assumed order==2
%
% REQUIRES:
% LaserPulse class
%
% NOTES:
% The LaserPulse object must contain only one sub-pulse.

% Copyright (C) 2015-2017 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt in the LaserPulse folder
% for copyright and licence notice.

% assume second horder autocorrelation, if not otherwise specified
assert(isvector(pulse.temporalField), ...
  'LaserPulse:autocorrelation pulse must be 1D');
if ~exist('order', 'var') || isempty(order), order = 2; end

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

%% Harmonic Generation
% calculate harmonic intensity
pulserep = abs(pulserep.^order).^2;

%% Autocorrelation
% integrate over time
ac = dt * sum(pulserep, 1);
% convert to column form
ac = reshape(ac, [], 1);

end
