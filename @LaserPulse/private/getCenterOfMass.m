function [x0, ix0, cm] = getCenterOfMass(x, y, selectedPulse)
%GETCENTEROFMASS gives the center of mass of a signal.
%
%EXAMPLE:
%  [x0, ix0, cm] = getCenterOfMass(x, y, selectedPulse)
%
%INPUTS:
% x: domain coordinates as Nx1 array, if left empty the column
%   index is used is x. (optional)
% y: one or several signals arranged as columns of a NxM array
% selectedPulse: if multiple signals are provided, it allows to
%   choose either the 'first' (default), the 'middle' or a weighted
%   average. (optional)
%
%USAGE:
% [cm, ix0, x0] = getCenterOfMass(x, y)
% [cm, ix0, x0] = getCenterOfMass([], y)
%   uses x == (1:size(y,1)).'
% [cm, ix0, x0] = getCenterOfMass(x, y, 'first')
%   uses the first column of y
% [cm, ix0, x0] = getCenterOfMass(x, y, 'middle')
%   uses the middle column of y
% [cm, ix0, x0] = getCenterOfMass(x, y, 'total')
%   calculates total center of mass of a multidimensional array
%
% NOTE:
%  The center of mass in general does not correspond to a specific pixel,
%  therefore we provide three outputs: the center of mass (cm), the closest
%  domain value (x0), and its index (ix0). The distinction can be relevant
%  when one uses the center of mass to translate (circshift) an array
%  before doing a Fourier transform (fft): in that case 'x0' and not 'cm'
%  should be used.

% Copyright (C) 2015 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt in the LaserPulse folder
% for copyright and licence notice.

% version log:
% 2015/06/18: added option 'total' for calculating the center of mass like
% the input would be just one big array

if ~exist('selectedPulse','var') || isempty(selectedPulse)
    selectedPulse = 'first';
end
if isvector(y) 
    y = y(:);  % if also y is 1D we transform both into column arrays
end
if isempty(x)
    x = (1:size(y,1)).'; % x == column index
else
    assert(isvector(x),'x must be 1D array');
    x = x(:); % we turn x into column array
end


assert(size(x,1) == size(y,1), 'the size of x and y aree not compatible');

% for simplicity temporary transform input in a 2D array
arraySize = size(y);
if numel(arraySize) > 2
   y = reshape(y, arraySize(1), []);
end

switch selectedPulse
   case 'first'
      mass = y(:, 1);
   case 'middle'
      mass = y(:, ceil(arraySize(2) / 2));
  case 'total'
    mass = sum(y, 2);
   otherwise
      error('centerOfMass:ArgChk',['valid optiona arguments are',...
         ' ''first'' or ''middle''.']);
end

cm = sum(x .* mass) ./ sum(mass);
[~, ix0] = min(abs(x - cm));
x0 = x(ix0);
end