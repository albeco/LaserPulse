classdef OpticalMedium < handle
  %OpticalMedium gives refractive index and permittivity of a material.
  %
  % It uses Sellmeyer formula to retrieve refractive index and permittivity
  % at specified frequency, wavelength or photon energy in eV.
  % The available materials are listed in the file 'sellmeyer.csv', which
  % can be easily edited to add more materials.
  %
  % class constructor:
  %  material = OpticalMedium('BK7')
  %
  % examples:
  %   n = OpticalMedium('BK7').refractiveIndex(800, 'nm');
  %   n = OpticalMedium('BK7').refractiveIndex(2, 'eV');
  %   n = OpticalMedium('BK7').refractiveIndex(350, 'THz');
  %   eps = OpticalMedium('BK7').permittivity(800, 'nm');
  %   eps = OpticalMedium('BK7').permittivity(2, 'eV');
  %   eps = OpticalMedium('BK7').permittivity(350, 'THz');
  %
  % References:
  %   Refractive index values are mainly taken from http://refractiveindex.info/
  %   and from SCHOTT data sheets.
  % See also: LaserPulse
  
  
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
  
  properties (Access = private)
    materialsFileName_ = 'sellmeyer.csv'; % dispersion formula using micrometer units
    dispersionFunction_ = @(x) ones(size(x)); % Sellmeyer dispersion equation
  end
  
  
  methods
    function obj = OpticalMedium(materialName)
      obj.dispersionFunction_ = obj.loadDispersionData(materialName);
    end
    
    function n = refractiveIndex(obj, x, unit)
      if ~isa(unit,'waveUnit'), unit=waveUnit(unit); end
      % convert to micrometers, for compatibility with Sellmeyer formula
      switch unit.baseUnit
        case 'm'
          x = waveUnit.convert(x, unit, 'um');
        case 'Hz'
          x = waveUnit.frequency2wavelength(x, unit, 'um');
        case 'eV'
          x = waveUnit.energy2wavelength(x, unit, 'um');
        otherwise
          error('OpticalMedium:argChk', 'unsupported unit type');
      end
      n = obj.dispersionFunction_(x);
    end
    
    function eps = permittivity(obj, x, unit)
      eps = obj.refractiveIndex(x, unit).^2;
    end
    
  end
  
  methods (Access = private)
    function func = loadDispersionData(obj, materialName)
      try
        % import file with materials name and Sellmeyer equations
        fileID = fopen(obj.materialsFileName_);
        materialsList = textscan(fileID, '%s %s', 'Delimiter', ',');
        fclose(fileID);
        % look up the material and assign the dispersion functin
        materialIndex = find(strcmp(materialsList{1}, materialName));
        % if material not in database return n=1 (vacuum)
        if isempty(materialIndex)
          error('OpticalMedium:argChk', 'material name not found.')
        end
        % check for duplicated entry in materials list
        if numel(materialIndex)>1
          warning(['duplicated material name: "',materialName,'" in file: "',...
            obj.materialsFileName_, '". Using last entry.'])
          materialIndex = materialIndex(end);
        end
        dispersionFunction = vectorize(materialsList{2}{materialIndex});
        func = str2func(strcat('@ (x)', dispersionFunction));
      catch ME
        switch ME.identifier
          case 'MATLAB:FileIO:InvalidFid'
            warning(['cannot find file with refractive index data: "',...
              obj.materialsFileName_, '". Using vacuum refractive index.']);
          case 'OpticalMedium:argChk'
            warning(['material name: "',materialName,'" not found in: "',...
              obj.materialsFileName_,'". Using vacuum refractive index.']);
          otherwise
            warning('error loading refractive index data, setting material to vacuum.');
        end
        % in case of error, use vacuum dispersion function (n=1)
        func = @(x) ones(size(x));
      end
    end
  end
  
end
