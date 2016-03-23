function status = checkSampling(pulse, domain, varargin)
% CHECKSAMPLING checks if step size allows to represent the cojugated fourier domain.
%
%  If the frequencyStep is not small enough, the time window might be too
%  narrow to represent the temporal field. In this case, it can be useful
%  to reduce the frequency step by interpolation. A similar argument also
%  applies for the timeStep when going from time domain to frequency
%  domain.
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

% Copyright 2015-2016 Alberto Comin, LMU Muenchen


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
    maxFieldAmp = max(abs(pulse.tempAmp_(:)));
    pulseRegion = abs(pulse.tempAmp_) > threshold * maxFieldAmp;
    status = all(abs(diff(pulse.tempPhase_(pulseRegion))) < maxPhase);
    if ~status && issueWarning
      warning(['Frequency window (1/timeStep) appears narrow. ', ...
        'It might be useful to decrease timeStep.']);
    end
  case 'frequency'
    pulse.updateField('frequency');
    maxFieldAmp = max(abs(pulse.specAmp_(:)));
    pulseRegion = abs(pulse.specAmp_) > threshold * maxFieldAmp;
    status = all(abs(diff(pulse.specPhase_(pulseRegion))) < maxPhase);
    if ~status && issueWarning
      warning(['Time window (1/frequencyStep) appears narrow. ', ...
        'It might be useful to decrease frequencyStep.']);
    end
  otherwise
    error('LaserPulse:checkSampling', ...
      'requested domain name is not supported');
end