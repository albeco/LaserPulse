function phi = getUnwrappedPhase(efield)
%GETUNWRAPPEDPAHSE returns the phase unwrapped symmetrically from center.
% 
% INPUTS:
%   efield: NxM array containg M pulses of N points each
% OUTPUTS:
%   phi: the phase angle(efield) unwrapped symmetrically from the center of
%    mass of abs(efield).^2

% Copyright (C) 2015-2017 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt in the LaserPulse folder
% for copyright and licence notice.


inputSize = size(efield);
if iscolumn(efield)
  fieldint = abs(efield).^2;
else
  efield = reshape(efield, size(efield,1),[]); %reshape into a 2D array
  fieldint = sum(abs(efield).^2, 2); % get total intensity in one column
end


% phase = angle(efield);
phase = atan2(imag(efield), real(efield));

[~, ix0, ~] = getCenterOfMass([], fieldint, 'total');


lowFreq = flipud(unwrap(phase(ix0:-1:1, :)));
highFreq = unwrap(phase(ix0:end, :));
% removing the duplicated central element before reuniting
phi = [lowFreq(1:end-1,:); highFreq];

% reshaping needed bacause matlab can implicitely transform
% multidimensional arrays into 2D arrays
phi = reshape(phi, inputSize);

end
