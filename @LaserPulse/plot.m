function newax = plot(pulse, ax, nstd)
% PLOT display a LaserPulse is either time or frequency domain.
%
% USAGE:
% p.plot()
%   plots the central region of the pulse
% p.plot(ax, n)
%   plots on the axes specified by 'ax' (array of 4 elements)
% p.plot([], n)
%   plots the region of the pulse within +/-n standard deviations
% p.plot(ax, n)
%   plots +/-n standard deviations on the specified axis

% Copyright (C) 2015 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt for copyright and licence
% notice.


if ~exist('nstd', 'var') || isempty(nstd)
  nstd = 5; % default no. stddev for plot
end
if ~exist('ax', 'var')
  ax = [];
end
[sigma_t, sigma_f] = pulse.std();

timeRange = [-1, 1] * nstd * sigma_t + pulse.arrivalTime;
if isnan(timeRange(1)); timeRange(1) = -inf; end;
if isnan(timeRange(2)); timeRange(2) = inf; end;
timeRegion = pulse.timeArray>timeRange(1) & pulse.timeArray<timeRange(2);

freqRange = [-1, 1] * nstd * sigma_f + pulse.centralFrequency;
if isnan(freqRange(1)); freqRange(1) = -inf; end;
if isnan(freqRange(2)); freqRange(2) = inf; end;
freqRegion = ...
  pulse.frequencyArray>freqRange(1) & pulse.frequencyArray<freqRange(2);

if isempty(ax)
  % creating a new figure
  figure()
  ax(1) = subplot(2,2,1);
  plot(pulse.timeArray(timeRegion, :), pulse.temporalAmplitude(timeRegion, :));
  grid on
  
  ax(2) = subplot(2,2,2);
  plot(pulse.timeArray(timeRegion, :), pulse.temporalPhase(timeRegion, :));
  grid on
  
  ax(3) = subplot(2,2,3);
  plot(pulse.frequencyArray(freqRegion, :), pulse.spectralAmplitude(freqRegion, :));
  grid on
  
  ax(4)= subplot(2,2,4);
  plot(pulse.frequencyArray(freqRegion, :), pulse.spectralPhase(freqRegion, :));
  grid on
  
else
  % adding on top of a old figure
  axes(ax(1)); hold on
  plot(pulse.timeArray(timeRegion, :), pulse.temporalAmplitude(timeRegion, :));
  axes(ax(2)); hold on
  plot(pulse.timeArray(timeRegion, :), pulse.temporalPhase(timeRegion, :));
  axes(ax(3)); hold on
  plot(pulse.frequencyArray(freqRegion, :), pulse.spectralAmplitude(freqRegion, :));
  axes(ax(4)); hold on
  plot(pulse.frequencyArray(freqRegion, :), pulse.spectralPhase(freqRegion, :));
end

xlabel(ax(1), sprintf('time (%s)', pulse.timeUnits))
ylabel(ax(1),'amplitude')
xlabel(ax(2), sprintf('time (%s)', pulse.timeUnits))
ylabel(ax(2),'phase (rad)')
xlabel(ax(3), sprintf('frequency (%s)', pulse.frequencyUnits))
ylabel(ax(3),'amplitude')
xlabel(ax(4), sprintf('frequency (%s)', pulse.frequencyUnits))
ylabel(ax(4),'phase (rad)')

if nargout > 0
  newax = ax;
end

end