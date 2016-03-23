function varargout = std(pulse, domain, mode)
%STD calculates standard deviation of field amplitude/intensity in time/frequency domain
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

% Copyright (C) 2015-2016 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt in the LaserPulse folder
% for copyright and licence notice.

% process optional input arguments
if ~exist('domain', 'var'); domain = 'all'; end
if ~exist('mode', 'var'); mode = 1; end

n = 0;

if strcmp(domain, 'time') || strcmp(domain, 'all')
  n = n+1;
  varargout{n} = stdev(pulse.timeArray, pulse.temporalIntensity, mode);
end

if strcmp(domain, 'frequency') || strcmp(domain, 'all')
  n = n+1;
  varargout{n} = stdev(pulse.frequencyArray, pulse.spectralIntensity, mode);
end

end

function v = stdev(x, fieldInt, mode)
% STDDEV gives the averaged standard deviation of a pulse or a pulse train
% 
% stdev(x, y, 2) calculates the standard deviation of the total
% intensity of the pulse train
%
% stdev(x, y, 1) calculates the standard deviation of the amplitude of the
% pulse train, defined as the square root of the total intesity

% if pulse train, get the total intensity
if ndims(fieldInt)>1
  % first stack all the sub-pulses in a matrix, and then sum them
  fieldInt = reshape(fieldInt, size(fieldInt,1), []);
  fieldInt = sum(fieldInt, 2);
end

switch mode
  case 2 % variance of the signal intensity
    v = sqrt(var(x, fieldInt, 1,'omitnan'));
  case 1 % variance of the signal amplitude
    v = sqrt(var(x, sqrt(fieldInt), 1,'omitnan'));
end
end

