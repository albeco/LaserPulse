classdef LaserPulse < matlab.mixin.Copyable
  %LASERPULSE is a class for storing and handling laser pulses.
  %
  % Pulses can be defined in either time or frequency domain.
  % Afterwards, both domains are automatically synchronized.
  %
  % EXAMPLES:
  %  p = LaserPulse(f, 'Hz', Af, phi)
  %      stores the frequency domain field: Ef(f) = Af(f)*exp(1i * phi(f))
  %  p = LaserPulse(f, 'PHz', Ef)
  %      stores the frequency domain field: Ef(f) = Af(f)*exp(1i * phi(f))
  %  p = LaserPulse(t, 'fs', At, phi)
  %      stores the time domain field: Et(t) = At(t)*exp(1i * phi(t))
  %  p = LaserPulse(t, 'ps', Et)
  %      stores the time domain field: Et(t) = At(t)*exp(1i * phi(t))
  %
  % USAGE:
  %  pulse = LaserPulse(domainValues, domainUnits, amp, phase)
  %  pulse = LaserPulse(domainValues, domainUnits, efield)
  %
  % INPUTS:
  %  domainValues: frequency or time steps
  %     (Nx1 array)
  %  domainUnits: time or frequency units (e.g 'fs' or 'PHz')
  %     (string)
  %  amp: amplitude of the electric field
  %     (Nx1 array for single pulse or NxM array for M pulses)
  %  phase: phase of the electric field
  %     (Nx1 array for single pulse or NxM array for M pulses)
  %  efield: complex field values
  %     (Nx1 array for single pulse or NxM array for M pulses)
  %
  % FUNCTIONALITIES:
  % # Physical Quantities:
  %   Pulse duration, bandwidth, central frequency are automatically
  %   calculated and provided as dependent properties.
  % # Mathematical Operators:
  %   The LaserPulse class supports arithmetic operations, convolutions and
  %   calculation of higher harmonics. The operators are applied by
  %   default in time domain, so for instance p1*p2 is a multiplication in
  %   time domain and a convolution in frequency domain. See the example
  %   files for more information. For applying the operators in the
  %   frequency domain set the property 'activeDomain' to 'frequency'.
  % # Pulse Trains:
  %   Multiple sub-pulses are stored as columns in a multidimensional
  %   arrays. Pulse parameters, like pulse duration and bandwidth, are
  %   calculated using the total pulse intensity, that is
  %   sum(abs(complexfield).^2,2) for a 2D array. This can be useful for
  %   storing the field components for different orthogonal polarizations.
  %
  % NOTES:
  %  To copy a pulse use the syntax:
  %   'pulse1 = copy(pulse2)' or
  %   'pulse1 = pulse2.copy()'.
  %  The assignment 'pulse1 = pulse2' does not create a copy of the object,
  %  but only a second reference to it.
  %
  % REQUIREMENTS:
  %   The LaserPulseMatlab uses features introduced with matlab R2011a,
  %   like for example the matlab.mixin.Copyable class.
  
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
  
  
  %% IMPLEMENTATION NOTES:
  %
  % - The sign convention for fft is the 'Physics' one, that is E(t) ==
  %  fft(E(f) and E(f) == ifft(E(t)).
  %
  % - Amplitude and phase of fields are stored separately, to minimize phase
  %  wrapping when applying frequency filters. This is useful for
  %  simulating complex pulses with fast or step-like modulation of the
  %  spectral phase.
  %
  % - electric fields are stored in private properties and accessed via
  %  public dependent properties. Public properties are automatically
  %  synchronized between time and frequency domains. To check if the
  %  private properties are already updated, use the variable
  %  updatedField_. To update them use the method pulse.updateField().
  %
  % - There are two reference systems. The reference system used for the
  %  public properties is centered at (t=0,f=0), as usual. The reference
  %  system used for the private properties is centered at
  %  (timeOffset,frequencyOffset). There are two reasons for this choice:
  %  1) reduce the number of points; 2) minimize phase wrapping issues,
  %  which occur when the derivative of the phase is too steep.
  %
  % - Due to properties of fourier transform, the time offset is also
  %  a derivative offset for the spectral phase, and the other way round.
  %  For this reason, both time and frequency offsets belong to both time
  %  and frequency domains.
  %
  % - Fourier transforms are performed on private properties defined
  %  in a offsetted reference system (see above). For this reason the fft
  %  formulas include a extra phase term (2*pi*timeOffset*frequencyOffset).
  %  If this term would not be included, the carrier-envelope phase offset
  %  could be altered when translating a domain axes (see translate.m).
  
  
  %% time and frequency domain private properties
  properties (Access = private)
    % the updatedDomain_ can be 'frequency', 'time', 'all', 'none'
    updatedDomain_ = 'none';
  end
  properties (Access = private, Dependent)
    shiftedTimeArray_ = []; % time array without offset
    shiftedFreqArray_ = []; % frequency array without offset
  end
  
  %% electric field private properties
  properties (Access = private)
    tempAmp_ = []; % amplitude of time-domain field (relative to offsets)
    tempPhase_ = []; % phase of time-domain field (relative to offsets)
    specAmp_ = []; % amplitude of frequency-domain field (relative to offsets)
    specPhase_ = []; % phase  of frequency-domain field (relative to offsets)
  end
  
  properties (Access = private, Dependent)
    tempField_ = []; % time domain complex field (relative to offsets)
    specField_ = []; % frequency domain complex field (relative to offsets)
  end
  
  %% time and frequency domain public properties
  properties
    frequencyUnits = 'Hz'; % physical units for frequency
    frequencyOffset = 0; % offset of the frequency array
    frequencyStep = 0; % frequency step
  end
  properties (Dependent)
    frequencyArray = []; % frequency array
  end
  properties
    timeUnits = 's'; % physical units for time
    timeOffset = 0; % offset of the time array
  end
  properties (Dependent)
    timeStep = 0; % time step
    timeArray = []; % time array
  end
  properties
    activeDomain = 'time'; % Fourier domain used for mathematical operators
    nPoints = 0; % number of domain points
  end
  %% electric field public properties
  properties (Dependent)
    spectralAmplitude; % amplitude of frequency domain field
    spectralPhase; % spectral phase (rad)
    groupDelay; % first derivative d(phi)/dw of spectral phase
    groupDelayDispersion; % second derivative d^2(phi)/dw^2 of spectral phase
    spectralField; % complex field in frequency domain
    spectralIntensity;% intensity of frequency domain field
    centralFrequency; % center of mass of spectral intensity
    bandwidth; % FWHM of spectral intensity
  end
  properties (Dependent)
    temporalAmplitude; % amplitude of time domain field
    temporalPhase; % phase of time domain field
    instantaneousFrequency; % derivative of temporal phase -1/2/pi * d(phi)/dt
    temporalField; % complex field in time domain
    temporalIntensity; % intensity of time domain field
    arrivalTime; % center of mass of temporal intensity
    duration; % FWHM of temporal intensity
  end
  
  %% constructor method
  methods
    function pulse = LaserPulse(domainValues, domainUnits, amp, phase)
      % LaserPulse construct a femtosecond pulse object
      
      [domainType, ~, inverseUnits ] = checkUnit( domainUnits );
      
      assert(isvector(domainValues), 'LaserPulse:ArgChk domainValues must be a vector');
      % convert domainValue to column array
      domainValues = domainValues(:);
      
      % if phase is not specified, assume that amplitude is complex
      if ~exist('phase','var')
        phase = getUnwrappedPhase(amp);
        amp = abs(amp);
      end
      
      % if only one subpulse is present we put it in column form, for
      % matrices we assume that the time/frequency axis is along the
      % first dimension
      if isrow(amp), amp = reshape(amp,[],1); end
      if isrow(phase), phase = reshape(phase,[],1); end
      
      assert(all(size(amp)==size(phase)), ...
        'expected phase and amplitude to be similar arrays');
      assert(numel(domainValues)==size(amp,1), ...
        'number of rows of field array must be equal to number of time/frequency points');
      
      switch domainType
        case 'frequency'
          pulse.frequencyUnits = domainUnits;
          pulse.timeUnits = inverseUnits;
          pulse.frequencyArray = domainValues;
          pulse.spectralAmplitude = amp;
          pulse.spectralPhase = phase;
          % remove derivative offset and store it as timeOffset
          pulse.detrend('frequency');
        case 'time'
          pulse.timeUnits = domainUnits;
          pulse.frequencyUnits = inverseUnits;
          pulse.timeArray = domainValues;
          pulse.temporalAmplitude = amp;
          pulse.temporalPhase = phase;
          % remove derivative offset and store it as frequencyOffset
          pulse.detrend('time');
        otherwise
          error('LaserPulse:ArgChk', ...
            'valid domain types are: ''time'', ''frequency''.');
      end
    end
  end
  
  %% time and frequency domain getter methods
  methods
    function f = get.shiftedFreqArray_(pulse)
      f = centeredRange(pulse.nPoints) * pulse.frequencyStep;
    end
    function f = get.shiftedTimeArray_(pulse)
      f = centeredRange(pulse.nPoints) * pulse.timeStep;
    end
  end
  methods
    function f = get.frequencyArray(pulse)
      f = pulse.frequencyOffset + pulse.shiftedFreqArray_;
    end
  end
  methods
    function dt = get.timeStep(pulse)
      dt = 1/((pulse.nPoints) * pulse.frequencyStep);
    end
    function t = get.timeArray(pulse)
      t = pulse.timeOffset + pulse.shiftedTimeArray_;
    end
  end
  
  %% electric field properties getter methods
  methods
    function ef = get.specField_(pulse)
      ef = pulse.specAmp_ .* exp(1i*pulse.specPhase_);
    end
    function ef = get.tempField_(pulse)
      ef = pulse.tempAmp_.* exp(1i*pulse.tempPhase_);
    end
  end
  methods
    function amp = get.spectralAmplitude(pulse)
      pulse.updateField('frequency');
      amp = pulse.specAmp_;
    end
    function phi = get.spectralPhase(pulse)
      pulse.updateField('frequency');
      phi = bsxfun(@plus, pulse.specPhase_,...
        2*pi * pulse.timeOffset * pulse.shiftedFreqArray_);
    end
    function tg = get.groupDelay(pulse)
      pulse.updateField('frequency');
      tg = pulse.timeOffset + ...
        1/2/pi/pulse.frequencyStep * centralDiff(pulse.specPhase_);
    end
    function tg = get.groupDelayDispersion(pulse)
      tg = 1/2/pi/pulse.frequencyStep * centralDiff(pulse.groupDelay);
    end
    function ef = get.spectralField(pulse)
      pulse.updateField('frequency');
      ef = pulse.spectralAmplitude .* exp(1i * pulse.spectralPhase);
    end
    function z = get.spectralIntensity(pulse)
      pulse.updateField('frequency');
      z = abs(pulse.specAmp_).^2;
    end
    function f = get.centralFrequency(pulse)
      switch pulse.updatedDomain_
        case {'frequency', 'all'}
          [~, ~, f] = getCenterOfMass(pulse.frequencyArray, abs(pulse.specAmp_).^2);
        case 'time'
          f = getCenterOfMass(pulse.instantaneousFrequency, abs(pulse.tempAmp_).^2);
        otherwise
          f = nan;
          warning('LaserPulse:get.centralFrequency pulse domain not correctly set')
      end
    end
    function fwhm = get.bandwidth(pulse)
      pulse.updateField('frequency');
      fwhm = calculateFWHM(pulse.frequencyArray, abs(pulse.specAmp_).^2);
    end
  end
  methods
    function amp = get.temporalAmplitude(pulse)
      pulse.updateField('time');
      amp = pulse.tempAmp_;
    end
    function phi = get.temporalPhase(pulse)
      pulse.updateField('time');
      phi = bsxfun(@plus, pulse.tempPhase_, ...
        -2*pi * pulse.frequencyOffset * pulse.shiftedTimeArray_);
    end
    function fi = get.instantaneousFrequency(pulse)
      pulse.updateField('time');
      fi = pulse.frequencyOffset - ...
        1/2/pi/pulse.timeStep * centralDiff(pulse.tempPhase_);
    end
    function ef = get.temporalField(pulse)
      pulse.updateField('time');
      ef = pulse.temporalAmplitude .* exp(1i * pulse.temporalPhase);
    end
    function z = get.temporalIntensity(pulse)
      pulse.updateField('time');
      z = abs(pulse.tempAmp_).^2;
    end
    function f = get.arrivalTime(pulse)
      switch pulse.updatedDomain_
        case {'time', 'all'}
          [~, ~, f] = ...
            getCenterOfMass(pulse.timeArray, abs(pulse.tempAmp_).^2);
        case 'frequency'
          f = getCenterOfMass(pulse.groupDelay, abs(pulse.specAmp_).^2);
        otherwise
          f = nan;
          warning('LaserPulse:get.centralFrequency pulse domain not correctly set')
      end
    end
    function dt = get.duration(pulse)
      pulse.updateField('time');
      dt = calculateFWHM(pulse.timeArray, abs(pulse.tempAmp_).^2);
    end
  end
  
  %% time and frequency domain setter methods
  methods
    function set.frequencyArray(pulse, freqArray)
      pulse.nPoints = numel(freqArray);
      [~, pulse.frequencyOffset, pulse.frequencyStep] = centerArray(freqArray);
    end
  end
  methods
    function set.timeStep(pulse, dt)
      pulse.frequencyStep = 1/((pulse.nPoints) * dt);
    end
    function set.timeArray(pulse, timeArray)
      pulse.nPoints = numel(timeArray);
      [~, pulse.timeOffset, pulse.timeStep] = centerArray(timeArray);
    end
  end
  %% electric field properties setter methods
  methods
    function set.specField_(pulse, efield)
      pulse.specAmp_ = abs(efield);
      pulse.specPhase_ = getUnwrappedPhase(efield);
    end
    function set.tempField_(pulse, efield)
      pulse.tempAmp_ = abs(efield);
      pulse.tempPhase_ = getUnwrappedPhase(efield);
    end
  end
  methods
    function set.spectralAmplitude(pulse, amp)
      if isrow(amp)
        amp = reshape(amp,[],1);
      end
      % make sure frequency domain is updated, to avoid information loss
      if strcmp(pulse.updatedDomain_, 'time')
        pulse.updateField('frequency');
      end
      pulse.specAmp_ = amp;
      pulse.updatedDomain_ = 'frequency';
    end
    function set.spectralPhase(pulse, phase)
      if isrow(phase)
        phase = reshape(phase,[],1);
      end
      % make sure frequency domain is updated, to avoid information loss
      if strcmp(pulse.updatedDomain_, 'time')
        pulse.updateField('frequency');
      end
      pulse.specPhase_ = ...
        bsxfun(@plus, phase, -2*pi*pulse.timeOffset * pulse.shiftedFreqArray_);
      pulse.updatedDomain_ = 'frequency';
    end
    
    function set.groupDelay(pulse, groupDelay)                             % should this reset the time offset?
      if isscalar(groupDelay)
        groupDelay = groupDelay * ones(size(pulse.frequencyArray));
      elseif isrow(groupDelay)
        groupDelay = reshape(groupDelay, [], 1);
      end
      pulse.spectralPhase = 2*pi * integrateFromCenter(...
        pulse.frequencyArray, groupDelay, pulse.centralFrequency, 1);
    end
    
    function set.groupDelayDispersion(pulse, GDD)                          % should this reset the time offset?
      if isscalar(GDD)
        GDD = GDD * ones(size(pulse.frequencyArray));
      elseif isrow(GDD)
        GDD = reshape(GDD, [], 1);
      end
      pulse.spectralPhase = (2*pi)^2 * integrateFromCenter(...
        pulse.frequencyArray, GDD, pulse.centralFrequency, 2);
    end
    
    function set.spectralField(pulse, efield)
      if isrow(efield)
        efield = reshape(efield,[],1);
      end
      pulse.spectralAmplitude = abs(efield);
      pulse.spectralPhase = getUnwrappedPhase(efield);
      % updatedDomain_ has been set to 'frequency'
    end
    function set.spectralIntensity(pulse, z)
      if isrow(z)
        z = reshape(z,[],1);
      end
      pulse.spectralAmplitude = sqrt(z);
      % updatedDomain_ has been set to 'frequency'
    end
    function set.centralFrequency(pulse, newCentralFrequency)
      pulse.frequencyOffset = pulse.frequencyOffset + (newCentralFrequency - pulse.centralFrequency);
      disp(['current centralFrequency = ', num2str(pulse.centralFrequency)]);
    end
    function set.bandwidth(pulse, ~)
      disp(['current bandwidth = ', num2str(pulse.bandwidth)]);
      warning('bandwidth cannot be set directly');
    end
  end
  methods
    function set.temporalAmplitude(pulse, amp)
      if isrow(amp)
        amp = reshape(amp,[],1);
      end
      % make sure time domain is updated, to avoid information loss
      if strcmp(pulse.updatedDomain_, 'frequency')
        pulse.updateField('time');
      end
      pulse.tempAmp_ = amp;
      pulse.updatedDomain_ = 'time';
    end
    function set.temporalPhase(pulse, phase)
      if isrow(phase)
        phase = reshape(phase,[],1);
      end
      % make sure time domain is updated, to avoid information loss
      if strcmp(pulse.updatedDomain_, 'frequency')
        pulse.updateField('time');
      end
      pulse.tempPhase_ = ...
        bsxfun(@plus, phase, +2*pi*pulse.frequencyOffset * pulse.shiftedTimeArray_);
      pulse.updatedDomain_ = 'time';
    end
    
     function set.instantaneousFrequency(pulse, instFreq)                  % should this reset the freq.offset?
      if isscalar(instFreq)
        instFreq = instFreq * ones(size(pulse.timeArray));
      elseif isrow(instFreq)
        instFreq = reshape(instFreq, [], 1);
      end
      pulse.temporalPhase = -2*pi * integrateFromCenter(...
        pulse.timeArray, instFreq, pulse.arrivalTime, 1);
    end
    
    function set.temporalField(pulse, efield)
      if isrow(efield)
        efield = reshape(efield,[],1);
      end
      pulse.temporalAmplitude = abs(efield);
      pulse.temporalPhase = getUnwrappedPhase(efield);
    end
    function set.temporalIntensity(pulse, z)
      if isrow(z)
        z = reshape(z,[],1);
      end
      pulse.temporalAmplitude = sqrt(z);
      % updatedDomain_ was implicitly updated
    end
    function set.arrivalTime(pulse, newArrivalTime)
      pulse.timeOffset = pulse.timeOffset + (newArrivalTime - pulse.arrivalTime);
      disp(['current pulse arrival time = ', num2str(pulse.arrivalTime)]);
    end
    function set.duration(pulse, ~)
      disp(['current pulse duration = ', num2str(pulse.duration)]);
      warning('pulse duration cannot be set directly');
    end
  end
  %% mathematical operators
  methods (Access = private)
    p = binaryOperator(op, pulse1, pulse2, activeDomain);
    p = multByDouble(pulse1, x); % rescale field by a numerical factor
  end
  methods
    p = plus(pulse1, pulse2); % sum two pulses in active domain
    p = minus(pulse1, pulse2); % subtract two pulses in active domain
    p = times(pulse1, pulse2); % multiplies in active domain, convolve in reciprocal domain
    p = mtimes(pulse1, pulse2); % same as 'times', in this implementation
    p = rdivide(pulse1, pulse); % divide in active domain, deconvolve in reciprocal domain
    p = mrdivide(pulse1, pulse2); % mrdivide == rdivide, in this implementation
    p = power(pulse1, n); % n-th power in active domain
    p = mpower(pulse1, n); % same as power, in this implementation
    p = conj(pulse1); % conjugate in active domain
    p = abs(pulse1); % absoulte value in active domain
  end
  
  %% derived physical quantities
  methods
    p = harmonic(pulse, n); % calculates n^th harmonic
    ac = autocorrelation(pulse); % interferometric autocorrelation
  end
  
  %% utility methods
  methods (Access = private)
    updateField(pulse, domainType); % updates fields using fft
  end
  methods
    tau = calculateShortestDuration(pulse); % calculates shortest pulse duration
    polynomialPhase(pulse, taylorCoeff) % sets the spectral phase to a polynomium
    detrend(pulse, domain) % removes derivative phase offset
    varargout = std(pulse, domain, mode); % calculates standard deviation in time or freq. domain
    normalize(pulse); % sets intensity area to one.
    translate(pulse, domain, dx); % translates the time or frequency axis
    matchDomains(p1, p2, tol) % makes time/frequency domains of two pulses the same.
    increaseTimeResolution(pulse, minPointsPerPeriod); % interpolates using fft
    increaseTimeRange(pulse, newrange, units); % decreases frequency step to increase time range
    newax = plot(pulse, nstd, ax); % plots the fields
    disp(pulse); % displays pulse information
    varargout = size(pulse, varargin); % gives the array size of the electric field
  end
end