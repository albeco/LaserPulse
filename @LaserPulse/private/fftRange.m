function y = fftRange(n)
% FFTRANGE gives the circular domain of a fft
% it is compatible with matlab definitions of fftshift and iffshift
% for even and odd numbers

% 2015 Alberto Comin, LMU Muenchen

assert(n > 0 && mod(n, 1) == 0, ...
  'fftRange:ArgChk argument must be positive integer')

y = [0:(ceil(n/2)-1), -floor(n/2):-1].';

end