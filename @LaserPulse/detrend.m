function detrend(pulse, domain)
%DETREND subtracts derivative offset from phase and store it separately
%   pulse.detrend('frequency') for spectral phases
%   pulse.detrend('time') for temporal phase
%   pulse.detrend('all') or pulse.detrend() for both phases

%% Copyright (C) 2015 Alberto Comin, LMU Muenchen
%
%  This file is part of LaserPulse.
% 
%  LaserPulse is free software: you can redistribute it and/or modify it
%  under the terms of the GNU General Public License as published by the
%  Free Software Foundation, either version 3 of the License, or (at your
%  option) any later version. LaserPulse is distributed in the hope that
%  it will be useful, but WITHOUT ANY WARRANTY; without even the implied
%  warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
%  the GNU General Public License for more details. You should have
%  received a copy of the GNU General Public License along with
%  LaserPulse.  If not, see <http://www.gnu.org/licenses/>.

if ~exist('domain','var')
  domain = 'all';
end

switch domain
  case 'frequency'
    freqDetrend(pulse); 
  case 'time'
    timeDetrend(pulse);
  case 'all'
    pulse.detrend('frequency');
    pulse.detrend('time');
  otherwise
    error('LaserPulse:detrend', 'unsupported domain Type');
end

end

function timeDetrend(pulse)
% if the new phase is not compatible with the old amplitude,
% calculate the offset at the center of domain, rather that at
% the center of mass
% see also comments related to set.spectralPhase
pulse.updateField('time');
phaseDer = centralDiff(pulse.tempPhase_) / pulse.timeStep;
int = abs(pulse.tempAmp_).^2;
phi1 = sum(phaseDer(:) .* int(:)) ./ sum(int(:));
phase = bsxfun(@minus, pulse.tempPhase_ , phi1 * pulse.shiftedTimeArray_);
pulse.frequencyOffset = pulse.frequencyOffset - phi1/2/pi; % note the (-) sign
pulse.tempPhase_ = phase;
pulse.updatedDomain_ = 'time';
end

function freqDetrend(pulse)
% if the new phase is not compatible with the old amplitude,
% calculate the offset at the center of domain, rather that at
% the center of mass
pulse.updateField('frequency');
phaseDer = centralDiff(pulse.specPhase_) / pulse.frequencyStep;
int = abs(pulse.specAmp_).^2;
phi1 = sum(phaseDer(:) .* int(:)) ./ sum(int(:));
phase = bsxfun(@minus, pulse.specPhase_ , phi1 * pulse.shiftedFreqArray_);
pulse.timeOffset = pulse.timeOffset + phi1/2/pi; % note the (+) sign
pulse.specPhase_ = phase;
pulse.updatedDomain_ = 'frequency';
end