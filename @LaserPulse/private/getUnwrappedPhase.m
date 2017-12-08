function phi = getUnwrappedPhase(efield, domainValues)
%GETUNWRAPPEDPAHSE returns the phase unwrapped symmetrically from center.
% 
% INPUTS:
%   efield: NxM array containg M pulses of N points each
%   domainValues: (optional) array of domain values (e.g. frequencies)
% OUTPUTS:
%   phi: the phase angle(efield) unwrapped symmetrically from the center of
%    mass of abs(efield).^2

% Copyright (C) 2015-2017 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt in the LaserPulse folder
% for copyright and licence notice.


inputSize = size(efield);
if isvector(efield)
  efield = efield(:); % make sure efield is a colum vector
  fieldint = abs(efield(:)).^2;
else
  efield = reshape(efield, size(efield,1),[]); % reshape into a 2D array
  fieldint = sum(abs(efield).^2, 2); % get total intensity in one column
end

if ~exist('domainValues', 'var')
  domainValues = (1:size(fieldint,1)).';
end


% phase = angle(efield);
phase = atan2(imag(efield), real(efield));

[~, ix0, ~] = getCenterOfMass(domainValues, fieldint, 'total');


lowFreq = flipud(unwrap(phase(ix0:-1:1, :)));
highFreq = unwrap(phase(ix0:end, :));
% removing the duplicated central element before reuniting
phi = [lowFreq(1:end-1,:); highFreq];

% reshaping needed bacause matlab can implicitely transform
% multidimensional arrays into 2D arrays
phi = reshape(phi, inputSize);

end
