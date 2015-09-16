function x1 = centralDiff( x )
%CENTRALDIFF calculates the differential along the first dimension

% 2015 Alberto Comin, LMU Muenchen

x1 = (circshift(x,-1,1)-circshift(x,1,1))/2;
x1(1,:) = x(2,:)-x(1,:);
x1(end,:) = x(end,:)-x(end-1,:); 

end

