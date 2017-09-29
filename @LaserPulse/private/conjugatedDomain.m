function cd = conjugatedDomain(domain)
%CONJUGATEDOMAIN gives the conjugated Fourier domain.

% Copyright (C) 2015-2017 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt in the LaserPulse folder
% for copyright and licence notice.

switch domain
  case 'frequency'
    cd = 'time';
  case 'time'
    cd = 'frequency';
  otherwise
    cd = domain;
end
end
