function [y, x0, dx] = centerArray(x)
%centerArray removes an offset so an array is centered at zero
% usage: [y, x0, dx] = centerArray(x)
% y is the centered array, x0 is the offset, and dx is the average increment
%
% For better compatibility with matlab fft functions, the central index is
% defined as the index which is shifted to zero by ifftshift. This is not a
% geometric center, especially if the array has an odd number of points.

% Copyright (C) 2015-2016 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt in the LaserPulse folder
% for copyright and licence notice.

assert(isvector(x),'centerArray:ArgChk input must be a vector');

% first we move the central inxed to the left
% transfor
if iscolumn(x)
  xshifted = ifftshift(x, 1);
else
  xshifted = ifftshift(x, 2);
end

x0 = xshifted(1);
dx = mean(diff(x));
y = x-x0;

end

