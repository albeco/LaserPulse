function x1 = centralDiff( x )
%CENTRALDIFF calculates the differential along the first dimension

% Copyright (C) 2015-2017 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt in the LaserPulse folder
% for copyright and licence notice.

x1 = (circshift(x,-1,1)-circshift(x,1,1))/2;
x1(1,:) = x(2,:)-x(1,:);
x1(end,:) = x(end,:)-x(end-1,:); 

end

