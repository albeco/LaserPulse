function y = centeredRange(n)
% CENTEREDRANGE gives a simmetric array for use with fft
% it is compatible with matlab definitions of fftshift and iffshift
% for even and odd numbers

% 2015 Alberto Comin, LMU Muenchen

assert(n > 0 && mod(n, 1) == 0, ...
  'centeredRange:ArgChk argument must be positive integer')

y = (-floor(n/2) : (ceil(n/2) - 1)).';
end

