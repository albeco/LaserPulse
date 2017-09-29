function blankPhase(pulse, domain, threshold)
% BLANKPHASE puts the phase to zero below a threshold
%
% Blanking the phase can be useful for plotting real experimental data, when
% the signal intensity drops below the noise level.
%
% USAGE:
%   pulse.blankPhase('time', eps)
%    set temporalPhase to zero when abs(I(t)/max(I(t))) < eps
%   pulse.blankPhase('frequency', eps)
%    set spectralPhase to zero when abs(I(f)/max(I(f))) < eps
%   pulse.blankPhase('time')
%    use default threshold (eps==1e-4)
%   pulse.blankPhase();
%    blank phase in the active domain with default threshold (eps==1e-4)

% Copyright 2015-2017 Alberto Comin, LMU Muenchen

if ~exist('domain', 'var') || isempty(domain)
  domain = pulse.activeDomain;
end
if ~exist('threshold', 'var') || isempty(threshold)
  threshold = 1e-4;
end

if strcmp(domain, 'time')
  % max intensity is calculated over all sub-pulses
  maxInt = max(pulse.temporalIntensity(:));
  blankingRegion = pulse.temporalIntensity < threshold * maxInt;
  pulse.temporalPhase(blankingRegion) = 0;
elseif strcmp(domain, 'frequency')
  % max intensity is calculated over all sub-pulses
  maxInt = max(pulse.spectralIntensity(:));
  blankingRegion = pulse.spectralIntensity < threshold * maxInt;
  pulse.spectralPhase(blankingRegion) = 0;
else
  error('LaserPulse:blankPhase:argChk', ...
    'domain must be either ''time'' or ''frequency''');
end

end
