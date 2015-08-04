%% Example of Gaussian, Lorentian and hyperbolic secant pulses
% This example shows how to set-up different types of laser pulses and
% compare their time-bandwidth products.


%% Set up a new Gaussian pulse
% 10fs gaussian pulse centered at t0 = 1 fs and f0 = 300 THz
p1 = gaussianPulse('units', 'fs', 'fwhm', 5, 't0', 1, 'f0', 0.3);
%% Set up a new Lorentzian pulse
% 10fs hyperbolic secant pulse centered at t0 = 1 fs and f0 = 300 THz
p2 = lorentzianPulse('units', 'fs', 'fwhm', 5, 't0', 1, 'f0', 0.3);
%% Set up a new hyperbolic secant pulse
% 10fs hyperbolic secant pulse centered at t0 = 1 fs and f0 = 300 THz
p3 = sechPulse('units', 'fs', 'fwhm', 5, 't0', 1, 'f0', 0.3);




%% Compare time-bandwidth products

fprintf('\ntime-bandwidth product according to several definitions\n')
fprintf('------------------------------------------------------------\n')
fprintf('           %15s  %15s  %15s\n', 'intensity fwhm', 'amplitude std', 'intensity std')

fprintf('gauss:     %15.3f  %15.3f  %15.3f\n', ...
  p1.duration * p1.bandwidth, p1.std('time')*p1.std('frequency'), ...
  p1.std('time',2) * p1.std('frequency',2));

fprintf('lorentz:   %15.3f  %15.3f  %15.3f\n', ...
  p2.duration * p2.bandwidth, p2.std('time')*p2.std('frequency'), ...
  p2.std('time',2) * p2.std('frequency',2));

fprintf('sech:      %15.3f  %15.3f  %15.3f\n', ...
  p3.duration * p3.bandwidth, p3.std('time')*p3.std('frequency'), ...
  p3.std('time',2) * p3.std('frequency',2));