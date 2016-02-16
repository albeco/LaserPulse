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
inrange = wl>validRange(1) & wl<validRange(2);

propterm = 2*pi ./ wl .* refrInd .* dist;

pulse.spectralAmplitude(inrange,:) = bsxfun(@times, ...
  pulse.spectralAmplitude(inrange,:), exp(-imag(propterm(inrange))));
pulse.spectralPhase(inrange,:) = bsxfun(@plus, ...
  pulse.spectralPhase(inrange,:), real(propterm(inrange)));

pulse.detrend('frequency');

end