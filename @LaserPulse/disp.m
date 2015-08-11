function disp(pulse)
%DISP displays pulse information

% Copyright (C) 2015 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt for copyright and licence
% notice.

% determine size of pulse and number of subpulses;
switch pulse.updatedDomain_
  case {'time','all'}
    sz = size(pulse.tempAmp_);
  case 'frequency'
    sz = size(pulse.specAmp_);
  otherwise
    disp('domain information still unset');
    return
end
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
  'arrival time:', pulse.arrivalTime, pulse.timeUnits, ...
  'central frequency:', pulse.centralFrequency, pulse.frequencyUnits)
fprintf('%-20s %10.3g %s, %20s %10.3g %s\n', ...
  'pulse duration:', pulse.duration, pulse.timeUnits, ...
  'pulse bandwidthy:', pulse.bandwidth, pulse.frequencyUnits)

end

