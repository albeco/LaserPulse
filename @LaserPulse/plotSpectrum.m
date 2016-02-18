function h = plotSpectrum( pulse, hf, nstd)
%PLOTSPECTRUM plots the spectrum of a LaserPulse object
%
% optional inputs:
% hf: figure handle
% nstd: plot range expressed standard deviations (calculated from the spectral
% intensity expressed in function of the frequency
% 
% optional output:
% h: line object

% Copyright (C) 2015-2016 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt in the LaserPulse folder
% for copyright and licence notice.

if ~exist('nstd', 'var'), nstd = 4; end
if ~exist('hf', 'var') || isempty(hf), hf = figure(); end

assert(isa(hf, 'handle') && isvalid(hf) && strcmp(get(hf, 'type'), 'figure'), ...
  'LaserPulse:plotSpectrum the first argument is not a valid figure handle');

plotRange = abs(pulse.frequencyArray-pulse.centralFrequency) < ...
  nstd * pulse.std('frequency', 2);

wl = pulse.wavelengthArray(plotRange);
int = pulse.spectrum(plotRange, :);

figure(hf);
lineHandle = plot(wl, int, 'LineWidth', 1.5);
xlabel(['Wavelength (',pulse.wavelengthUnits,')'])
ylabel('Spectrum (arb. units)');

grid(gca, 'on');
set(gca, 'LineWidth', 1.5, 'GridAlpha', 0.1, 'GridLineStyle', ':');
end

