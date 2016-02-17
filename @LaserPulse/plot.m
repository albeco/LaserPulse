function newax = plot(pulse, ax, nstd)
% PLOT display a LaserPulse is either time or frequency domain.
%
% USAGE:
% p.plot()
%   plots the central region of the pulse
% p.plot(hf)
%   plots on the figure specified by 'hf' (handle)
% p.plot(ax)
%   plots on the axes array specified by 'ax' (4 elements)
% p.plot([], n)
%   create new figure and restrict horizontal range to +/-n standard deviations
%
% The first argument ('ax') is optional. It can be either a handle to a
% figure, or an array with four axes handles (as obtained by subplot(2,2,n)
% for n=1:4).

% Copyright (C) 2015-2016 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt in the LaserPulse folder
% for copyright and licence notice.

%% process optional input argument
if ~exist('nstd', 'var') || isempty(nstd)
  nstd = 5; % default no. stddev for plot
end

if ~exist('ax', 'var') || isempty(ax) % create new figure and new axes
  hf = figure();
  ax = get_subplot_axes(hf);
elseif numel(ax)==1          % user provided handle to figure
  hf = ax;                   % save handle to figure
  ax = get_subplot_axes(hf); % get handles of subplot axes
elseif numel(ax)~=4          
  error('LaserPulse:plot', 'first argument must be handle to figure or to axes of 4 subplots')
end  

%% determine plot range
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


plot(ax(1), pulse.timeArray(timeRegion, :), pulse.temporalAmplitude(timeRegion, :));
plot(ax(2), pulse.timeArray(timeRegion, :), pulse.temporalPhase(timeRegion, :));
plot(ax(3), pulse.frequencyArray(freqRegion, :), pulse.spectralAmplitude(freqRegion, :));
plot(ax(4), pulse.frequencyArray(freqRegion, :), pulse.spectralPhase(freqRegion, :));


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


function ax = get_subplot_axes(hf)
  % create four subplots if needed, return their handles
  figure(hf);
  ax(1) = subplot(2,2,1); grid on; hold on
  ax(2) = subplot(2,2,2); grid on; hold on
  ax(3) = subplot(2,2,3); grid on; hold on
  ax(4) = subplot(2,2,4); grid on; hold on
end