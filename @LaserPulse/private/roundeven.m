function n = roundeven(x)
% ROUNDEVEN rounds x to the nearest even number

% Copyright (C) 2015-2016 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt in the LaserPulse folder
% for copyright and licence notice.

n = bitshift(bitshift(ceil(x),-1),1);
end