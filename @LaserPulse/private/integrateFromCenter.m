function y = integrateFromCenter(x, y, x0, n)
%INTEGRATEFROMCENTER gives the n-th repeated integral on the first dimension
% 
% USAGE:
% y = integrateFromCenter(x, y, x0) gives the integral of y(x), setting
% the integration constant to zero at x = x0
%
% z = integrateFromCenter(x, y, x0, 2) repeats twice the integration,
% setting the integration constants to zero at x = x0
%
% INPUT:
% x: domain values
% y: values of the function to be integrated
% x0: starting point of the integration
% n: number of times to perform the integration
%
% OUTPUT:
% y: the result of the integration

% Copyright (C) 2015-2017 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt in the LaserPulse folder
% for copyright and licence notice.

% find the central index
[~,ix0]=min(abs(x-x0));
% reshape input into 2d matrix (because anyways y(ix0,:) does it)
sz = size(y);
y = reshape(y, size(y,1), []);
% do the integration
for i = 1:n
  y = cumtrapz(x, y, 1);
  % subtract the integration constant at reference point
  y = bsxfun(@minus, y, y(ix0,:));
end
% reshape back to original size
y = reshape(y, sz);

end

