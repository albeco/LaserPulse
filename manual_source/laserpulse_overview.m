%% LaserPulse
%
% The <matlab:doc('LaserPulse') LaserPulse> class allows to store pulses in
% a convenient way, analyze them and perform simple mathematical
% operations.

%% Initialization
%
% A <matlab:doc('LaserPulse') LaserPulse> object can be initialized in
% either time of frequency domain:

% time domain pulse:
t = -10 : 0.01 : 9.99;
p1 = LaserPulse(t, 'fs', exp(-t.^2 - 2i*pi*t));

% frequency domain pulse:
f = -10 : 0.01 : 9.99;
p2 = LaserPulse(f, 'PHz', exp(-(f-2).^2 + 2i*pi*f));

%%
% In either case both time and frequency domains are computed and kept
% automatically synchronized.

%% Physical Properties
%
% Several properties are automatically calculated and can be accessed using
% the dot notation. For instance, using the following commands, we can
% display pulse duration, bandwidth and central frequency:

% display pulse duration for p1 and p2
fprintf('pulse durations are %.2f %s and %.2f %s\n', ...
  p1.duration, p1.timeUnits, p2.duration, p2.timeUnits);

% display pulse bandwidth for p1 and p2
fprintf('pulse bandwidths are %.2f %s and %.2f %s\n', ...
  p1.bandwidth, p1.frequencyUnits, p2.bandwidth, p2.frequencyUnits);

% display central frequency for p1 and p2
fprintf('central frequencies are %.2f %s and %.2f %s\n', ...
  p1.centralFrequency, p1.frequencyUnits, ...
  p2.centralFrequency, p2.frequencyUnits);

%% Names and Definitions
%
% The <matlab:doc('LaserPulse') LaserPulse> class uses relatively long
% names in order to distinguish between fields in time and frequency
% domain. The fields are defined as follows:
%
% time domain fields:
%
%   p.temporalField == p.temporalAmplitude * exp(1i * p.temporalPhase)
%
% frequency domain fields:
%
%   p.spectralField == p.spectralAmplitude * exp(1i * p.spectralPhase)
%
% Internally the fields are synchronized using a fft routine. The sign
% convention for the fft is:
% 
% $$E(t) = \int_{-\infty}^{+\infty} E(f)\,\exp(-2\pi\, f\, t)\,\mathrm{d}f$$
%
% $$E(f) = \int_{-\infty}^{+\infty} E(t)\,\exp(+2\pi\, f\, t)\,\mathrm{d}t$$

%% Plotting Fields
%
% In the LaserPulse class the <matlab:doc('LaserPulse/plot') plot()> method
% is overloaded to provide a quick way to visualize fields in time and
% frequency domain:
h = p1.plot();
%%
% Two pulses can be displayed on the same axes, by calling
% <matlab:doc('LaserPulse/plot') plot()>  with a second argument
p2.plot(h);

%%
% More plot types can be obtained using the standard matlab commands. For
% instance, the next figure shows how to display the real part of the
% electric field in time domain:
figure()
plot(p1.timeArray, real(p1.temporalField), ...
     p2.timeArray, real(p2.temporalField));
xlim([-2, 2]*p1.duration)
xlabel(sprintf('time (%s)', p1.timeUnits));
ylabel('E(t)');
legend('p1', 'p2')

%% Examples
%
% *  <./example_files/pulse_autocorrelation.html pulse_autocorrelation.m>
% (<matlab:edit('pulse_autocorrelation.m') source>)
%       example of interferometric autocorrelation
% *  <./example_files/pulse_create_new.html pulse_create_new.m>
% (<matlab:edit('pulse_create_new.m') source>)
%     examples of how to set-up a LaserPulse object
% *  <./example_files/pulse_display_properties.html pulse_display_properties.m>
% (<matlab:edit('pulse_display_properties.m') source>)
%       example of how to obtain LaserPulse properties
% *  <./example_files/pulse_four_wave_mixing.html pulse_four_wave_mixing.m>
% (<matlab:edit('pulse_four_wave_mixing.m') source>)
%       example of nonlinear process with LaserPulse class
% *  <./example_files/pulse_harmonics.html pulse_harmonics.m>
% (<matlab:edit('pulse_harmonics.m') source>)
%       examples of higher harmonics
% *  <./example_files/pulse_linear_mixing.html pulse_linear_mixing.m>
% (<matlab:edit('pulse_linear_mixing.m') source>)
%       examples of linear superposition of LaserPulse objects
% *  <./example_files/pulse_nonlinear_mixing.html pulse_nonlinear_mixing.m>
% (<matlab:edit('pulse_nonlinear_mixing.m') source>)
%       example of nonlinear mixing of LaserPulse objects
% *  <./example_files/pulse_replicas.html pulse_replicas.m>
% (<matlab:edit('pulse_replicas.m') source>)
%       example of how to create time-shifted replicas and pulse trains 
% *  <./example_files/pulse_gaussian_sech_lorentzian.html pulse_gaussian_sech_lorentzian.m>
% (<matlab:edit('pulse_gaussian_sech_lorentzian.m') source>)
%       example of Gaussian, Lorentian and hyperbolic secant pulse shapes
% *  <./example_files/pulse_self_phase_modulation.html pulse_self_phase_modulation.m>
% (<matlab:edit('pulse_self_phase_modulation.m') source>)
%       example simulation of self-phase modulation using LaserPulse class