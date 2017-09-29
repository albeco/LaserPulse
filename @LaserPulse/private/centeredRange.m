function y = centeredRange(n)
% CENTEREDRANGE gives a simmetric array for use with fft
% it is compatible with matlab definitions of fftshift and iffshift
% for even and odd numbers

% Copyright (C) 2015-2017 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt in the LaserPulse folder
% for copyright and licence notice.

assert(n > 0 && mod(n, 1) == 0, ...
  'centeredRange:ArgChk argument must be positive integer')

y = (-floor(n/2) : (ceil(n/2) - 1)).';
end

