function cd = conjugatedDomain(domain)
%CONJUGATEDOMAIN gives the conjugated Fourier domain.

% 2015 Alberto Comin, LMU Muenchen

switch domain
  case 'frequency'
    cd = 'time';
  case 'time'
    cd = 'frequency';
  otherwise
    cd = domain;
end
end