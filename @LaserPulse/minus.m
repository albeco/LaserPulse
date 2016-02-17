function res = minus(pulse1, pulse2)
% MINUS subtracts two pulses.
%
% INPUTS:
%   pulse1: instance of LaserPulse
%   pulse2: instance of LaserPulse
%
% OUTPUTS:
%   p: the difference pulse
%
% If the two pulses have different sampling , they are interpolated over a
% commond domain.

% Copyright (C) 2015-2016 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt in the LaserPulse folder
% for copyright and licence notice.

res = binaryOperator(@polarMinus, pulse1, pulse2);

end

function [amp, phase] = polarMinus(amp1,phase1,amp2,phase2)
realpart = amp1 .* cos(phase1) - amp2 .* cos(phase2);
imagpart = amp1 .* sin(phase1) - amp2 .* sin(phase2);
amp = hypot(realpart, imagpart);
phase = getUnwrappedPhase(realpart +1i * imagpart);
end