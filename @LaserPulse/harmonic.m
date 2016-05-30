function p  = harmonic(pulse,n)
% HARMONIC gives the n-th harmonic of a laser pulse
%
% USAGE:
% pulse  = harmonic(pulse,n)
%   gives the n-th harmonic
% pulse  = harmonic(pulse)
%   gives the 2-nd harmonics

% Copyright (C) 2015-2016 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt in the LaserPulse folder
% for copyright and licence notice.

if ~exist('n','var'), n = 2; end
assert(mod(n,1)==0 && n>0, ['LaserPulse:harmonic', ...
  ' the order of harmonic must be a positive integer']);
% if time is not the most updated domain, check frequency sampling
if ~strcmp(pulse.updatedDomain_, 'time')
  pulse.checkSampling('frequency', 'warning', true);
end

% make sure to calculate pulse.^n in time domain
pulse.activeDomain = 'time';
p = pulse.^n;
% reset the frequency offset by detrending the temporal phase,
% to make sure that spectral field remains centered in frequency domain
p.detrend('time');

end