function res = mpower(pulse1, n)
% MPOWER calculate the n-th power of a pulse in the active domain.
% In this implementation, it is the same as power(pulse1, n)
%
% INPUTS:
%   pulse1: instance of LaserPulse
%   n: the exponent (double)
%
% OUTPUTS:
%   p: the resulting pulse

% Copyright (C) 2015-2017 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt in the LaserPulse folder
% for copyright and licence notice.

res = power(pulse1, n);

end
