function polynomialPhase(pulse, taylorCoeff)
% POLYNOMIALPHASE sets the spectral phase to a polynomium

% Copyright (C) 2015 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt for copyright and licence
% notice.

% calculate polynomial phase
phase = polyval(...
  taylorCoeff ./ ...
  factorial(numel(taylorCoeff)-1 : -1 : 0) , ...
  2*pi*(pulse.frequencyArray - pulse.centralFrequency));

% replicate the phase for all sub-pulses
if ~isvector(pulse.spectralPhase)
  phase = bsxfun(phase, ones(size(pulse.spectralPhase)));
end

% apply the phase
pulse.spectralPhase = phase;

end
