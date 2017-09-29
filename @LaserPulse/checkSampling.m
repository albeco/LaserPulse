function status = checkSampling(pulse, domain, varargin)
% CHECKSAMPLING checks if step size allows to represent the cojugated fourier domain.
%
%  This function checks if the phase steps between domain points is small
%  compared to pi.
%
% USAGE:
%   status = checkSampling(pulse, domain)
%   status = checkSampling(pulse, domain, 'threshold', 1e-3)
%   status = checkSampling(pulse, domain, 'warning', true)
% INPUTS:
%   domain: 'time' or 'frequency'
% NAMED INPUT ARGUMENTS:
%   'threshold': region to check (relative field amplitude < threshold, 
%                                 default threshold: 1e-2)
%   'maxPhase' (default 0.95*pi): maximum phase step
%   'warning' (default: true): issue a warning in case of undersampling
% OUTPUTS:
%   status: true is sampling is ok, false otherwise

% Copyright 2015-2017 Alberto Comin, LMU Muenchen


%% process input
threshold = 1e-2;
maxPhase = 0.95 * pi;
issueWarning = true;

for n=1:2:numel(varargin)
  switch lower(varargin{n})
    case 'threshold'
      threshold = varargin{n+1};
    case 'maxphase'
      maxPhase = varargin{n+1};
    case 'warning'
      issueWarning = varargin{n+1};
    otherwise
      error('LaserPulse:checkSampling:argChk', ...
        ['unsupported argument: ', varargin{n}]);
  end
end

%% main
switch domain
  case 'time'
    pulse.updateField('time');
    status = checkPhase(pulse.tempAmp_, pulse.tempPhase_);
    if ~status && issueWarning
      warning(['Frequency window (1/timeStep == %.2f %s) appears narrow. ', ...
        'It might be useful to decrease the timeStep.'], ...
        1/pulse.timeStep, pulse.frequencyUnits);
    end
  case 'frequency'
    pulse.updateField('frequency');
    status = checkPhase(pulse.specAmp_, pulse.specPhase_);
    if ~status && issueWarning
      warning(['Time window (1/frequencyStep == %.2f %s) appears narrow. ', ...
        'It might be useful to decrease the frequencyStep.'], ...
        1/pulse.frequencyStep, pulse.timeUnits);
    end
  otherwise
    error('LaserPulse:checkSampling', ...
      'requested domain name (''%s'') is not supported', domain);
end

function status = checkPhase(amp, phase)
    amp = reshape(amp, size(amp,1), []);
    phase = reshape(phase, size(phase,1), []);
    pulseRegion = abs(amp) > threshold .* max(abs(amp(:)));
    phaseDiffs = diff(phase);
    status = all(phaseDiffs(pulseRegion(1:end-1,:)) < maxPhase);
end

end
