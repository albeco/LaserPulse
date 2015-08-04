function n = roundeven(x)
% ROUNDEVEN rounds x to the nearest even number

% 2015 Alberto Comin, LMU Muenchen

n = bitshift(bitshift(ceil(x),-1),1);
end