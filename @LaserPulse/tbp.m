function x = tbp(pulse, mode)
% TBP gives the time-bandwidth product of a laser pulse
%
% The time-bandwidth product is calculated using either the root mean
% square of the pulse intensity (default) or the full-width at half maximum.
% In the first case the root mean square is calculated using the angular
% frequency, so it contains a prefector of 2*pi.
%
% USAGE:
% x=tbp(pulse) or x=tbp(pulse,'rms')
%    equivalent to 2*pi*pulse.std('time',2)*pulse.std('frequency',2)
% x=tbp(pulse,'fwhm')
%    equilvalent to pulse.duration*pulse.bandwidth;

% Copyright 2016 Alberto Comin, LMU Muenchen

if nargin<2, mode='rms'; end;

if strcmpi(mode, 'fwhm')
  x = pulse.duration .* pulse.bandwidth;
elseif strcmpi(mode, 'rms')
  x = 2*pi * pulse.std('time', 2) .* pulse.std('frequency', 2);
else
  error('LaserPulse:tbp:argChk', ['unsupported argument: ', mode])
end

end