classdef WaveUnit < handle
  %WAVEUNIT is a simple module for converting between optical units.
  %
  % functionalities:
  % - validate units (e.g. 'fs' is ok, 'qs' not ok)
  % - optimize prefix (e.g. 1200 kHz --> 1.2 MHz)
  % - find inverse unit (e.g. 'ms'<-->'kHz')
  % - convert between frequency, wavelength and photon energy.
  %
  % Only a subset on units, useful for optics, is currently supported.
  % Supported base units: 'm','s','Hz','eV', 'J'
  %
  %
  % examples:
  % to validate and store a unit:
  %   u = WaveUnit('ms') % millisecond
  %   u = WaveUnit('THz') % terahertz
  % to find the inverse unit:
  %   u2 = WaveUnit('ms').inverse;
  %   u2 = WaveUnit('THz').inverse;
  % to convert between equivalent units:
  %    WaveUnit.convert(1200, 'us', 'ms');
  %    WaveUnit.convert(4, 'aJ', 'eV');
  %    % most commands process both unit strings and unit objects:
  %    WaveUnit.convert(4, WaveUnit('aJ'), 'eV');
  % to optimize the prefix of a unit:
  %    [newValue, newUnit] = WaveUnit.optimize(1200, 'nm')
  %    [newValue, newUnit] = WaveUnit.optimize(3.2e, WaveUnit('nm'))
  % to convert between frequency and wavelength:
  %    WaveUnit.frequency2wavelength(1e-2, 'GHz', 'mm')
  %    WaveUnit.wavelength2frequency(1000, 'nm', 'PHz')
  %    % can also set the target unit to 'auto':
  %    [freqValue, freqUnit] = WaveUnit.wavelength2frequency(1, 'um', 'auto')
  % to convert between frequency and photon energy:
  %    WaveUnit.frequency2energy(1,'PHz', 'eV')
  %    WaveUnit.energy2frequency(2.3,'eV', 'Hz')
  %    [enValue, enUnit] = WaveUnit.frequency2energy(3.2, 'kHz', 'auto')
  
  %% Copyright (c) 2016, Alberto Comin All rights reserved.
  %
  % Redistribution and use in source and binary forms, with or without
  % modification, are permitted provided that the following conditions are
  % met:
  %
  % 1. Redistributions of source code must retain the above copyright
  % notice, this list of conditions and the following disclaimer.
  %
  % 2. Redistributions in binary form must reproduce the above copyright
  % notice, this list of conditions and the following disclaimer in the
  % documentation and/or other materials provided with the distribution.
  %
  % THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
  % "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
  % LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
  % A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
  % HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
  % SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
  % LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
  % DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
  % THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  % (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  % OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  
  %%
  properties (Constant)
    speedOfLight = 2.99792458e8; % m/s
    electronCharge = 1.602176620898e-19; % Coulomb
    PlanckConstant = 4.13566766225e-15; % eV * s
  end
  properties (Constant, Hidden, Access = private)
    maxExponent = 24; % max SI exponent
    prefix2exponent = containers.Map( ...
      {'y','z','a','f','p','n','u','m','','k','M','G','T','P','E','Z','Y'}, ...
      -24:3:24);
    exponent2prefix = containers.Map(-24:3:24, ...
      {'y','z','a','f','p','n','u','m','','k','M','G','T','P','E','Z','Y'})
    unit2dimension = containers.Map( ...
      {'m', 's', 'Hz', 'eV', 'J', 'none'}, ...
      {'length', 'time', 'frequency', 'energy', 'energy', 'none'});
  end
  properties
    SIprefix = ''; % SI prefix ('k','M','G',...)
    baseUnit = 'none'; % SI base unit ('m', 's', ...)
  end
  properties (Dependent)
    name; % full name of unit (e.g. 'GHz')
    dimension; % physical dimension (e.g. 'energy' for 'eV')
    exponent; % scientific notation exponent (e.g. 9 for 'GHz')
  end
  %%
  methods
    function obj = WaveUnit(unitName)
      % WAVEUNIT stores a physical unit in SI format
      % usage: u = WaveUnit(unitname)
      % example: u = WaveUnit('MHz');
      try
        [obj.SIprefix, obj.baseUnit] = WaveUnit.parseUnit(unitName);
      catch ME
        if strcmp(ME.identifier, 'WaveUnit:parseUnit')
          obj.SIprefix = '';
          obj.baseUnit = 'none';
          warning(ME.message);
        else
          error('WaveUnit:setName', 'error setting physical unit');
        end
      end
    end
    
    function unitName = get.name(obj)
      unitName = strcat(obj.SIprefix, obj.baseUnit);
    end
    
    function dim = get.dimension(obj)
      dim = WaveUnit.unit2dimension(obj.baseUnit);
    end
    
    function y = get.exponent(obj)
      y = WaveUnit.prefix2exponent(obj.SIprefix);
    end
    
    function invUnit = inverse(obj)
      % INVERSEUNIT inverts time and frequency units
      % example: ms->kHz, GHz->ns
      if strcmp(obj.baseUnit,'s'), invBaseUnit = 'Hz';
      elseif strcmp(obj.baseUnit,'Hz'), invBaseUnit = 's';
      else error('WaveUnit:inverseUnit', ...
          'can only invert time and frequency units');
      end
      invUnitPrefix = WaveUnit.exponent2prefix(-obj.exponent);
      invUnit = WaveUnit(strcat(invUnitPrefix, invBaseUnit));
    end
    
    function cmp = eq(unit1, unit2)
      cmp = strcmp(unit1.baseUnit, unit2.baseUnit) && ...
        strcmp(unit1.SIprefix, unit2.SIprefix);
    end
    
    function disp(obj)
      fprintf('WaveUnit: (%s)\n', obj.dimension);
      fprintf('name: ''%s''', obj.name);
      if obj.SIprefix~=0
        fprintf(' , prefix: ''%c'' (10^%d)\n', ...
          obj.SIprefix, obj.exponent);
      else
        fprintf('.\n');
      end
    end
  end
  %%
  methods(Static, Access = private)
    function [SIprefix, baseUnit] = parseUnit(unitName)
      % PARSEUNIT splits a unit name into prefix and base unit
      unitsPattern = strcat( ...
        '^(?<prefix>[', strjoin(WaveUnit.prefix2exponent.keys,''), '])?', ...
        '(?<baseUnit>', strjoin(WaveUnit.unit2dimension.keys,'|'), ')$');
      matchedUnit = regexp(unitName, unitsPattern,'names');
      if isempty(matchedUnit)
        error('WaveUnit:parseUnit', ...
          ['unrecognized unit type: ', unitName])
      else
        SIprefix = matchedUnit.prefix;
        baseUnit = matchedUnit.baseUnit;
      end
    end
    
    function [value2, unit2] = convertDimension(value1, ...
        unit1, unit2, referenceUnit1, referenceUnit2, conversionFormula)
      % CONVERTDIMENSION converts between frequency, wavelength and energy
      if ~isa(unit1,'WaveUnit'), unit1 = WaveUnit(unit1); end
      if ~isa(referenceUnit1,'WaveUnit'), referenceUnit1 = WaveUnit(referenceUnit1); end
      if ~isa(referenceUnit2,'WaveUnit'), referenceUnit2 = WaveUnit(referenceUnit2); end
      assert(strcmp(unit1.baseUnit, referenceUnit1.baseUnit), ...
        ['unit1 must have base unit:',referenceUnit1.baseUnit]);
      if ischar(unit2) && strcmp(unit2,'auto')
        optimizeUnit = true;
        unit2 = referenceUnit2;
      else
        optimizeUnit = false;
        if ~isa(unit2,'WaveUnit'), unit2 = WaveUnit(unit2); end
        assert(strcmp(unit2.baseUnit, referenceUnit2.baseUnit), ...
          ['unit2 must have base unit:',referenceUnit2.baseUnit]);
      end
      value2 = conversionFormula(value1 * 10^unit1.exponent) / 10^unit2.exponent;
      if optimizeUnit
        [value2, unit2] = WaveUnit.optimize(value2, unit2);
      end
    end
    
  end
  
  methods (Static)
    function [newValue, newUnit] = optimize(value, unit)
      % OPTIMIZE rescale a unit to use the closest SI prefix
      if isscalar(value), sampleValue=value; else sampleValue=mean(abs(value(:))); end
      if ~isa(unit,'WaveUnit'), unit=WaveUnit(unit); end
      newExponent = floor((log10(sampleValue)+unit.exponent)/3)*3;
      newExponent = min(WaveUnit.maxExponent, max(-WaveUnit.maxExponent, newExponent));
      newValue = value *10^(unit.exponent-newExponent);
      newPrefix = WaveUnit.exponent2prefix(newExponent);
      newUnit = WaveUnit(strcat(newPrefix, unit.baseUnit));
    end
    
    function newValue = convert(value, unit1, unit2)
      % CONVERT gives the conversion factor between compatible units
      % usage:
      % newValue = convert(value, unit1, unit2);
      
      if ~isa(unit1,'WaveUnit'), unit1 = WaveUnit(unit1); end
      if ~isa(unit2,'WaveUnit'), unit2 = WaveUnit(unit2); end
      newValue = value * 10.^(unit1.exponent - unit2.exponent);
      if strcmp(unit1.baseUnit, 'eV') && strcmp(unit2.baseUnit, 'J')
        newValue = newValue *  WaveUnit.electronCharge;
      elseif strcmp(unit1.baseUnit, 'J') && strcmp(unit2.baseUnit, 'eV')
        newValue = newValue /  WaveUnit.electronCharge;
      elseif ~strcmp(unit1.baseUnit, unit2.baseUnit)
        error('WaveUnit:convert', ...
          [unit1.name,' and ',unit2.name,' have different base units']);
      end
    end
    
    function [value2, unit2] = frequency2wavelength(value1, unit1, unit2)
      % FREQUENCY2WAVELENGTH converts optical frequency to wavelength
      % usage:
      % wl = frequency2wavelength(freq, freqUnit, wlUnit)
      % or, for automatically choosing the closest SI unit:
      % [wl, wlUnit] = frequency2wavelength(freq, freqUnit, 'auto')
      if ~exist('unit2','var'), unit2='m'; end
      conversionFormula = @(x) WaveUnit.speedOfLight ./ x;
      [value2, unit2] = WaveUnit.convertDimension(value1, ...
        unit1, unit2, 'Hz', 'm', conversionFormula);
    end
    
    function [value2, unit2] = wavelength2frequency(value1, unit1, unit2)
      % WAVELENGTH2FREQUENCY converts optical wavelength to frequency
      % usage:
      % freq = wavelength2frequency(wl, wlUnit, freqUnit)
      % or, for automatically choosing the closest SI unit:
      % [freq, freqUnit] = wavelength2frequency(wl, wlUnit, 'auto')
      if ~exist('unit2','var'), unit2='Hz'; end
      conversionFormula = @(x) WaveUnit.speedOfLight ./ x;
      [value2, unit2] = WaveUnit.convertDimension(value1, ...
        unit1, unit2, 'm', 'Hz', conversionFormula);
    end
    
    function [value2, unit2] = frequency2energy(value1, unit1, unit2)
      % FREQUENCY2ENERGY converts frequency to photon energy in eV
      % usage:
      % phEn = frequency2energy(freq, freqUnit, phEnUnit)
      % or, for automatically choosing the closest SI unit:
      % [phEn, phEnUnit] = frequency2energy(freq, freqUnit, 'auto')
      if ~exist('unit2','var'), unit2='eV'; end
      conversionFormula = @(x) WaveUnit.PlanckConstant * x;
      [value2, unit2] = WaveUnit.convertDimension(value1, ...
        unit1, unit2, 'Hz', 'eV', conversionFormula);
    end
    
    function [value2, unit2] = energy2frequency(value1, unit1, unit2)
      % ENERGY2FREQUENCY converts photon energy in eV to frequency
      % usage:
      % freq = energy2frequency(phEn, phEnUnit, freqUnit)
      % or, for automatically choosing the closest SI unit:
      % [freqEn, freqUnit] = energy2frequency(phEn, phEnUnit, 'auto')
      if ~exist('unit2','var'), unit2='Hz'; end
      conversionFormula = @(x) x / WaveUnit.PlanckConstant;
      [value2, unit2] = WaveUnit.convertDimension(value1, ...
        unit1, unit2, 'eV', 'Hz', conversionFormula);
    end
    
    function [value2, unit2] = wavelength2energy(value1, unit1, unit2)
      % WAVELENGTH2ENERGY converts optical wavelength to photon energy in eV
      % usage:
      % phEn = wavelength2energy(wl, wlUnit, phEnUnit)
      % or, for automatically choosing the closest SI unit:
      % [phEn, phEnUnit] = wavelength2energy(wl, wlUnit, 'auto')
      if ~exist('unit2','var'), unit2='eV'; end
      conversionFormula = @(x) ...
        WaveUnit.speedOfLight * WaveUnit.PlanckConstant ./ x;
      [value2, unit2] = WaveUnit.convertDimension(value1, ...
        unit1, unit2, 'm', 'eV', conversionFormula);
    end
    
    function [value2, unit2] = energy2wavelength(value1, unit1, unit2)
      % ENERGY2WAVELENGTH converts photon energy in eV to wavelength
      % usage:
      % wl = energy2wavelength(phEn, phEnUnit, wlUnit)
      % or, for automatically choosing the closest SI unit:
      % [wl, wlUnit] = energy2wavelength(phEn, phEnUnit, 'auto')
      if ~exist('unit2','var'), unit2='m'; end
      conversionFormula = @(x) ...
        WaveUnit.speedOfLight * WaveUnit.PlanckConstant ./ x ;
      [value2, unit2] = WaveUnit.convertDimension(value1, ...
        unit1, unit2, 'eV', 'm', conversionFormula);
    end
    
    function c = getSpeedOfLight(lengthUnit, timeUnit)
      % GETSPEEDOFLIGHT gives the speed of light in specified units
      if ~isa(lengthUnit,'WaveUnit'), lengthUnit = WaveUnit(lengthUnit); end
      if ~isa(timeUnit,'WaveUnit'), timeUnit = WaveUnit(timeUnit); end
      c = WaveUnit.speedOfLight * 10^(timeUnit.exponent-lengthUnit.exponent);
    end
  end
end


