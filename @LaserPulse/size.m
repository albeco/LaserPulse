function varargout = size(pulse, varargin)
% SIZE gives the array size of the electric field

% 2015 Alberto Comin, LMU Muenchen
%
% This file is part of LaserPulse. See README.txt in the LaserPulse folder
% for copyright and licence notice.

switch pulse.updatedDomain_
  case {'time', 'all'}
    % make sure temporal amplititude and phase have same array size
    assert(all(size(pulse.tempAmp_) == size(pulse.tempPhase_)), ...
      'LaserPulse:size','temporal amplitude and phase must have same size');
    % return the array size of the temporal field
    [varargout{1:nargout}] = size(pulse.tempAmp_, varargin{:});
  case 'frequency'
    % make sure spectral amplititude and phase have same array size
    assert(all(size(pulse.specAmp_) == size(pulse.specPhase_)), ...
      'LaserPulse:size', 'spectral amplitude and phase must have same size');
    % return the array size of the spectral field
    [varargout{1:nargout}] = size(pulse.specAmp_, varargin{:});
  otherwise
    error('LaserPulse:size','updatedDomain_ not correctly set');
end
end

