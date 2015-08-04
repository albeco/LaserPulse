function updateField(pulse, domainType)
% UPDATEFIELD calculates time or frequency domain via fft
%
% USAGE:
% pulse.updateField('frequency')
%   if frequency domain field is not yet updated, calculates it using fft
% pulse.updateField('time')
%   if time domain field is not yet updated, calculates it using fft
% pulse.updateField('all')
%   check which domain is currently updatded and updates the other one

% Copyright (C) 2015 Alberto Comin, LMU Muenchen

%  This file is part of LaserPulse. LaserPulse is free software: you can
%  redistribute it and/or modify it under the terms of the GNU General
%  Public License. See README.txt for full copyright and licence notice.

% IMPLEMENTATION NOTE:
% The fourier transform contain an extra phase term exp(1i*w0*t0) because
% the two domains are not centered at zero time and zero frequency.

if strcmp(pulse.updatedDomain_, 'all') || strcmp(pulse.updatedDomain_, domainType)
  % nothing todo, requested field is already updated
  return;
elseif strcmp(pulse.updatedDomain_, 'none')
  error('LaserPulse:updateField', ...
    'cannot update because no domain is set yet');
end

switch domainType
  case 'time'
    pulse.tempField_ =   pulse.frequencyStep * ...
      fftshift(fft(ifftshift(pulse.specField_, 1), [], 1), 1) .* ...
      exp( -2i*pi*pulse.frequencyOffset*pulse.timeOffset);
  case 'frequency'
    pulse.specField_ = 1/pulse.frequencyStep * ...
      fftshift(ifft(ifftshift(pulse.tempField_,1), [], 1),1) .* ...
      exp( 2i*pi*pulse.frequencyOffset*pulse.timeOffset);
  case 'all'
    pulse.updateField(conjugatedDomain(pulse.updatedDomain_));
  otherwise
    error('LaserPulse:updateField', ...
      'requested domain name is not supported');
end

pulse.updatedDomain_ = 'all';
end
