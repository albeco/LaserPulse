%% LaserPulse class properties
% Several physical properties of LaserPulse objects are automatically
% calculated and can be accessed using the dot notation.

%%
% Several physical properties of LaserPulse objects are automatically
% calculated and can be accessed using the dot notation.

%% New pulse in frequency domain

% frequency array
f = linspace(0, 10, 1000);
% electric field
Af = exp(-(f-0.5).^2/(0.1)^2);
phi = 1000*(f-0.5).^3;
% LaserPulse object
p2 = LaserPulse(f, 'THz', Af, phi);

% Plot the pulse
p2.plot();

%% Display physical properties
fprintf('\ntime domain properties')
fprintf('\n----------------------\n')
propertyName = {'arrivalTime', 'duration', 'timeOffset', 'timeStep'};
for i = 1:numel(propertyName)
  fprintf('%s = %.2f %s\n', propertyName{i}, p2.(propertyName{i}), p2.timeUnits);
end

fprintf('\nfrequency domain properties')
fprintf('\n---------------------------\n')
propertyName = {'centralFrequency', 'bandwidth', 'frequencyOffset', 'frequencyStep'};
for i = 1:numel(propertyName)
  fprintf('%s = %.2f %s\n', propertyName{i}, p2.(propertyName{i}), p2.frequencyUnits);
end