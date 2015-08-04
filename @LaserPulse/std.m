function varargout = std(pulse, domain, mode)
%STD calculates standard deviation of field amplitude in time and frequency domain
%
% USAGE:
%
% [sigma_t, sigma_f] = std(pulse)
% [sigma_t, sigma_f] = std(pulse, 'all')
%   standard deviation of field amplitude of frequency domain field
%
% sigma_t = std(pulse, 'time')
%   standard deviation of field amplitude only in time domain 
% sigma_f = std(pulse, 'frequency')
%   standard deviation of field amplitude only in frequency domain
%
% sigma_tf = std(pulse, 'time', 1)
%   standard deviation of field amplitude in time domain
% sigma_tf = std(pulse, 'time', 2)
%   standard deviation of field intensity in time domain
%
% INPUTS:
% pulse: LaserPulse object
% domain: 'all' | 'time' | 'frequency'
% mode: 1 (amplitude) | 2 (intensity)

% Copyright (C) 2015 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt for copyright and licence
% notice.

if ~exist('domain', 'var')
  domain = 'all';
end

if ~exist('mode', 'var')
  mode = 1;
end

n = 0;
if strcmp(domain, 'time') || strcmp(domain, 'all')
  n = n+1;
  varargout{n} = sqrt(var(pulse.timeArray, ...
    abs(pulse.temporalAmplitude).^mode, 1,'omitnan'));
end
if strcmp(domain, 'frequency') || strcmp(domain, 'all')
  n = n+1;
  varargout{n} = sqrt(var(pulse.frequencyArray, ...
    abs(pulse.spectralAmplitude).^mode, 1, 'omitnan'));
end

end

