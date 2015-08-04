function p = sechPulse(varargin)
%SECHPULSE creates a hyperbolic secant LaserPulse object in time domain
%
% NAMED INPUT ARGUMENTS:
% 't0': pulse arrival time (default: 0)
% 'units': time units (default: 'fs')
% 'f0': central frequency (default: 0)
% 'fwhm': pulse duration (default: 10)
% 'dt': time step (default: 0.1)
% 'nPoints': number of domain points (default 1024)
%
% OUTPUT ARGUMENT:
% p: LaserPulse object
%
% see also LaserPulse, gaussianPulse, lorentzianPulse

% 2015 Alberto Comin, LMU Muenchen

t0 = 0; % arrival time of the pulse
f0 = 0; % central frequency
FWHM = 10; % full width at half maximum
nPoints = 2^10; % number of points
dt = 0.1; % time step
timeUnits = 'fs'; % time units

n = 1;
while n < numel(varargin)
  switch varargin{n}
    case 't0'
      t0 = varargin{n+1};
    case 'units'
      timeUnits = varargin{n+1};
    case 'f0'
     f0 = varargin{n+1};
    case 'fwhm'
      FWHM = varargin{n+1};
    case 'nPoints'
      nPoints = varargin{n+1};
      assert(nPoints > 0 && mod(nPoints, 1) == 0, ...
        'gaussuianPulse:ArgChk nPoints must be positive integer')
    case 'dt'
      dt = varargin{n+1};
    otherwise
      error('gaussianPulse:ArgChk', ...
        'unsupported argument')
  end
  n = n + 2;
end

t = t0 + dt * (-floor(nPoints/2) : (ceil(nPoints/2) - 1)).';
At = sech((t-t0)*2/FWHM*acosh(sqrt(2)));
phi_t = -2*pi*f0*(t-t0);
p = LaserPulse(t, timeUnits, At, phi_t);

end