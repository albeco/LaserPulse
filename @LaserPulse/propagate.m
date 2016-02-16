function propagate(pulse, dist, distUnits)
%PROPAGATE propagates a pulse through a medium

% Copyright (C) 2015 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt for copyright and licence
% notice.

wl = pulse.wavelengthArray;
wlUnits = pulse.wavelengthUnits;
dist = WaveUnit.convert(dist, distUnits, wlUnits);

refrInd = pulse.medium.refractiveIndex(wl, wlUnits);
validRange = WaveUnit.convert(pulse.medium.validityRange, 'um', wlUnits);
% do not consider refractive index values outside validity range
% here we make a simple constant extrapolation
refrInd(wl<validRange(1)) = pulse.medium.refractiveIndex(validRange(1), wlUnits);
refrInd(wl>validRange(2)) = pulse.medium.refractiveIndex(validRange(2), wlUnits);

propterm = bsxfun(@times, 2*pi ./ wl .* refrInd, dist);


pulse.spectralAmplitude = bsxfun(@times, ...
  pulse.spectralAmplitude, exp(-imag(propterm)));
pulse.spectralPhase= bsxfun(@plus, ...
  pulse.spectralPhase, real(propterm));

pulse.detrend('frequency');

end