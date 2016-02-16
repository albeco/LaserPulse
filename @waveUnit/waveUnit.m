classdef waveUnit < handle
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
  %   u = waveUnit('ms') % millisecond
  %   u = waveUnit('THz') % terahertz
  % to find the inverse unit:
  %   u2 = waveUnit('ms').inverse;
  %   u2 = waveUnit('THz').inverse;
  % to convert between equivalent units:
  %    waveUnit.convert(1200, 'us', 'ms');
  %    waveUnit.convert(4, 'aJ', 'eV');
  %    % most commands process both unit strings and unit objects:
  %    waveUnit.convert(4, waveUnit('aJ'), 'eV');
  % to optimize the prefix of a unit:
  %    [newValue, newUnit] = waveUnit.optimize(1200, 'nm')
  %    [newValue, newUnit] = waveUnit.optimize(3.2e, waveUnit('nm'))
  % to convert between frequency and wavelength:
  %    waveUnit.frequency2wavelength(1e-2, 'GHz', 'mm')
  %    waveUnit.wavelength2frequency(1000, 'nm', 'PHz')
  %    % can also set the target unit to 'auto':
  %    [freqValue, freqUnit] = waveUnit.wavelength2frequency(1, 'um', 'auto')
  % to convert between frequency and photon energy:
  %    waveUnit.frequency2energy(1,'PHz', 'eV')
  %    waveUnit.energy2frequency(2.3,'eV', 'Hz')
  %    [enValue, enUnit] = waveUnit.frequency2energy(3.2, 'kHz', 'auto')
  
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
  properties (Constant, Hidden, Access = private)
    speedOfLight = 2.99792458e8; % m/s
    electronCharge = 1.602176620898e-19; % Coulomb
    PlanckConstant = 4.13566766225e-15; % eV * s
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
    function obj = waveUnit(unitName)
      % WAVEUNIT stores a physical unit in SI format
      % usage: u = waveUnit(unitname)
      % example: u = waveUnit('MHz');
      try
        [obj.SIprefix, obj.baseUnit] = waveUnit.parseUnit(unitName);
      catch ME
        if strcmp(ME.identifier, 'waveUnit:parseUnit')
          obj.SIprefix = '';
          obj.baseUnit = 'none';
          warning(ME.message);
        else
          error('waveUnit:setName', 'error setting physical unit');
        end
      end
    end
    
    function unitName = get.name(obj)
      unitName = strcat(obj.SIprefix, obj.baseUnit);
    end
    
    function dim = get.dimension(obj)
      dim = waveUnit.unit2dimension(obj.baseUnit);
    end
    
    function y = get.exponent(obj)
      y = waveUnit.prefix2exponent(obj.SIprefix);
    end
    
    function invUnit = inverse(obj)
      % INVERSEUNIT inverts time and frequency units
      % example: ms->kHz, GHz->ns
      if strcmp(obj.baseUnit,'s'), invBaseUnit = 'Hz';
      elseif strcmp(obj.baseUnit,'Hz'), invBaseUnit = 's';
      else error('waveUnit:inverseUnit', ...
          'can only invert time and frequency units');
      end
      invUnitPrefix = waveUnit.exponent2prefix(-obj.exponent);
      invUnit = waveUnit(strcat(invUnitPrefix, invBaseUnit));
    end
    
    function cmp = eq(unit1, unit2)
      cmp = strcmp(unit1.baseUnit, unit2.baseUnit) && ...
        strcmp(unit1.SIprefix, unit2.SIprefix);
    end
    
    function disp(obj)
      fprintf('waveUnit: (%s)\n', obj.dimension);
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
        '^(?<prefix>[', strjoin(waveUnit.prefix2exponent.keys,''), '])?', ...
        '(?<baseUnit>', strjoin(waveUnit.unit2dimension.keys,'|'), ')$');
      matchedUnit = regexp(unitName, unitsPattern,'names');
      if isempty(matchedUnit)
        error('waveUnit:parseUnit', ...
          ['unrecognized unit type: ', unitName])
      else
        SIprefix = matchedUnit.prefix;
        baseUnit = matchedUnit.baseUnit;
      end
    end
    
    function [value2, unit2] = convertDimension(value1, ...
        unit1, unit2, referenceUnit1, referenceUnit2, conversionFormula)
      % CONVERTDIMENSION converts between frequency, wavelength and energy
      if ~isa(unit1,'waveUnit'), unit1 = waveUnit(unit1); end
      if ~isa(referenceUnit1,'waveUnit'), referenceUnit1 = waveUnit(referenceUnit1); end
      if ~isa(referenceUnit2,'waveUnit'), referenceUnit2 = waveUnit(referenceUnit2); end
      assert(strcmp(unit1.baseUnit, referenceUnit1.baseUnit), ...
        ['unit1 must have base unit:',referenceUnit1.baseUnit]);
      if ischar(unit2) && strcmp(unit2,'auto')
        optimizeUnit = true;
        unit2 = referenceUnit2;
      else
        optimizeUnit = false;
        if ~isa(unit2,'waveUnit'), unit2 = waveUnit(unit2); end
        assert(strcmp(unit2.baseUnit, referenceUnit2.baseUnit), ...
          ['unit2 must have base unit:',referenceUnit2.baseUnit]);
      end
      value2 = conversionFormula(value1 * 10^unit1.exponent) / 10^unit2.exponent;
      if optimizeUnit
        [value2, unit2] = waveUnit.optimize(value2, unit2);
      end
    end
    
  end
  
  methods (Static)
    function [newValue, newUnit] = optimize(value, unit)
      % OPTIMIZE rescale a unit to use the closest SI prefix
      if isscalar(value), sampleValue=value; else sampleValue=mean(abs(value(:))); end
      if ~isa(unit,'waveUnit'), unit=waveUnit(unit); end
      newExponent = floor((log10(sampleValue)+unit.exponent)/3)*3;
      newExponent = min(waveUnit.maxExponent, max(-waveUnit.maxExponent, newExponent));
      newValue = value *10^(unit.exponent-newExponent);
      newPrefix = waveUnit.exponent2prefix(newExponent);
      newUnit = waveUnit(strcat(newPrefix, unit.baseUnit));
    end
    
    function newValue = convert(value, unit1, unit2)
      % CONVERT gives the conversion factor between compatible units
      % usage:
      % newValue = convert(value, unit1, unit2);
      
      if ~isa(unit1,'waveUnit'), unit1 = waveUnit(unit1); end
      if ~isa(unit2,'waveUnit'), unit2 = waveUnit(unit2); end
      newValue = value * 10.^(unit1.exponent - unit2.exponent);
      if strcmp(unit1.baseUnit, 'eV') && strcmp(unit2.baseUnit, 'J')
        newValue = newValue *  waveUnit.electronCharge;
      elseif strcmp(unit1.baseUnit, 'J') && strcmp(unit2.baseUnit, 'eV')
        newValue = newValue /  waveUnit.electronCharge;
      elseif ~strcmp(unit1.baseUnit, unit2.baseUnit)
        error('waveUnit:convert', ...
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
      conversionFormula = @(x) waveUnit.speedOfLight ./ x;
      [value2, unit2] = waveUnit.convertDimension(value1, ...
        unit1, unit2, 'Hz', 'm', conversionFormula);
    end
    
    function [value2, unit2] = wavelength2frequency(value1, unit1, unit2)
      % WAVELENGTH2FREQUENCY converts optical wavelength to frequency
      % usage:
      % freq = wavelength2frequency(wl, wlUnit, freqUnit)
      % or, for automatically choosing the closest SI unit:
      % [freq, freqUnit] = wavelength2frequency(wl, wlUnit, 'auto')
      if ~exist('unit2','var'), unit2='Hz'; end
      conversionFormula = @(x) waveUnit.speedOfLight ./ x;
      [value2, unit2] = waveUnit.convertDimension(value1, ...
        unit1, unit2, 'm', 'Hz', conversionFormula);
    end
    
    function [value2, unit2] = frequency2energy(value1, unit1, unit2)
      % FREQUENCY2ENERGY converts frequency to photon energy in eV
      % usage:
      % phEn = frequency2energy(freq, freqUnit, phEnUnit)
      % or, for automatically choosing the closest SI unit:
      % [phEn, phEnUnit] = frequency2energy(freq, freqUnit, 'auto')
      if ~exist('unit2','var'), unit2='eV'; end
      conversionFormula = @(x) waveUnit.PlanckConstant * x;
      [value2, unit2] = waveUnit.convertDimension(value1, ...
        unit1, unit2, 'Hz', 'eV', conversionFormula);
    end
    
    function [value2, unit2] = energy2frequency(value1, unit1, unit2)
      % ENERGY2FREQUENCY converts photon energy in eV to frequency
      % usage:
      % freq = energy2frequency(phEn, phEnUnit, freqUnit)
      % or, for automatically choosing the closest SI unit:
      % [freqEn, freqUnit] = energy2frequency(phEn, phEnUnit, 'auto')
      if ~exist('unit2','var'), unit2='Hz'; end
      conversionFormula = @(x) x / waveUnit.PlanckConstant;
      [value2, unit2] = waveUnit.convertDimension(value1, ...
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
        waveUnit.speedOfLight * waveUnit.PlanckConstant ./ x;
      [value2, unit2] = waveUnit.convertDimension(value1, ...
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
        waveUnit.speedOfLight * waveUnit.PlanckConstant ./ x ;
      [value2, unit2] = waveUnit.convertDimension(value1, ...
        unit1, unit2, 'eV', 'm', conversionFormula);
    end
  end
end


