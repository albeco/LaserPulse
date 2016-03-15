function disp(pulse)
%DISP displays pulse information

% Copyright (C) 2015-2016 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt in the LaserPulse folder
% for copyright and licence notice.

% determine size of pulse and number of subpulses;
sz = size(pulse);
nsub = prod(sz(2:end));

% display pulse information
fprintf('LaserPulse with %d domain points' , pulse.nPoints)
if nsub > 1
  fprintf(' and %d sub-pulses.\n', nsub);
else
  fprintf('.\n');
end

fprintf('%-20s %10.3g %s, %20s %10.3g %s\n', ...
  'time step:', pulse.timeStep, pulse.timeUnits, ...
  'frequency step:', pulse.frequencyStep, pulse.frequencyUnits)
fprintf('%-20s %10.3g %s, %20s %10.3g %s\n', ...
  'pulse duration:', pulse.duration, pulse.timeUnits, ...
  'pulse bandwidth:', pulse.bandwidth, pulse.frequencyUnits)
fprintf('%-20s %10.3g %s, %20s %10.3g %s\n', ...
  'arrival time:', pulse.arrivalTime, pulse.timeUnits, ...
  'central frequency:', pulse.centralFrequency, pulse.frequencyUnits)
fprintf('%-20s %13s, %20s %10.3g %s\n', ...
  'optical medium:', pulse.medium.name, ...
  'central wavelength:', pulse.centralWavelength, pulse.wavelengthUnits)

end

