function propagate(pulse, dist, distUnits, varargin)
%PROPAGATE propagates a pulse through an optical medium.
%
% The propagation distance can be either a scalar or a multi-dimensional
% array. 
% It must be size(dist,1)==1, because the first dimension is reserved for
% the time/frequency axis, and size(dist, n)==size(pulse.spectralPhase,n)
% for n in [2:ndims(pulse.spectralPhase)].
% If ndims(dist)>ndims(pulse.spectralPhase), additional sub-pulses are
% created.
%
% If the optional parameter 'broadening' is specified, only the bradening
% effect is considered and the pulses are not temporarly delayed. This can
% be useful because time delays introduce derivative offsets to the
% spectral phase and, in the current implementation, LaserPulse stores a
% single timeOffset for all the subpulses.
%
% USAGE:
% pulse.propagate(distance, units);
% pulse.propagate(distance, units, 'broadening');
%
% EXAMPLE:
% pulse.propagate(1, 'mm');
%
% NOTES:
% It is possible to define a specific optical medium using the syntax
% pulse.medium = mediumname, for example: pulse.medium = 'BK7'.
%
% See also: LaserPulse, OpticalMedium

% Copyright (C) 2015-2016 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt in the LaserPulse folder
% for copyright and licence notice.

onlyBroadening = false;
if ~isempty(varargin) && strcmp(varargin{1}, 'broadening')
  onlyBroadening = true;
end

wl = pulse.wavelengthArray;
wlUnits = pulse.wavelengthUnits;
dist = WaveUnit.convert(dist, distUnits, wlUnits);

refrInd = pulse.medium.refractiveIndex(wl, wlUnits);
validRange = WaveUnit.convert(pulse.medium.validityRange, 'um', wlUnits);
% do not consider refractive index values outside validity range
% here we make a simple constant extrapolation
refrInd(wl<validRange(1)) = pulse.medium.refractiveIndex(validRange(1), wlUnits);
refrInd(wl>validRange(2)) = pulse.medium.refractiveIndex(validRange(2), wlUnits);

assert(size(dist,1) == 1); % propagation distance is the same for all frequencies
propterm = bsxfun(@times, 2*pi ./ wl .* refrInd, dist);
propterm(wl<=0) = 0;

damping = exp(-imag(propterm));
addedPhase = real(propterm);
if onlyBroadening
  addedPhase = ndDetrend(addedPhase);
end

pulse.spectralAmplitude = bsxfun(@times, ...
  pulse.spectralAmplitude, damping);
pulse.spectralPhase= bsxfun(@plus, ...
  pulse.spectralPhase, addedPhase);

pulse.detrend('frequency');

end