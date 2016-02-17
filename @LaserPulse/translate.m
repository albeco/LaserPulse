function translate(pulse, domain, dx)
%TRANSLATE translates the time or freq. axis using the conjugated domain
% to avoid using circhift which is precise only for small step sizes
%
% USAGE:
% pulse.translate(domain, x)
% where domain is 'time' or 'frequency'

% Copyright (C) 2015-2016 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt in the LaserPulse folder
% for copyright and licence notice.

switch domain
  case 'frequency'
    pulse.updateField('time');
    pulse.tempPhase_ = bsxfun(@plus, pulse.tempPhase_, 2*pi*dx*pulse.shiftedTimeArray_);
    pulse.frequencyOffset = pulse.frequencyOffset + dx;
    pulse.updatedDomain_ = 'time';
  case 'time'
    pulse.updateField('frequency');
    pulse.specPhase_ = bsxfun(@minus, pulse.specPhase_, 2*pi*dx*pulse.shiftedFreqArray_);
    pulse.timeOffset = pulse.timeOffset + dx;
    pulse.updatedDomain_ = 'frequency';
  otherwise
    error('LaserPulse:translate', 'unsupported domain in type');
end

% now the domain in which the field has been translated is not the
% currently updated one, but its conjugate is
pulse.updateField('all');
% now both domains are updated

end