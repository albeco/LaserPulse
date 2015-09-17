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
% 18/06/2015: added option 'total' for calculating the center of mass like
%   the input would be just one big array
% 12/08/2015: added support for the case in which both x and y are
%    multi-dimensional arrays

%% process optional input arguments
if ~exist('selectedPulse','var') || isempty(selectedPulse)
    selectedPulse = 'first';
end
if isempty(x)
    x = (1:size(y,1)).'; % x == column index
end

%% check if inputs are arrays of compatible size
if isvector(x) == 1
   assert(size(x,1) == size(y,1), 'the size of x and y are not compatible');
else
  assert(all(size(x) == size(y)), 'the size of x and y are not compatible');
end

%% main body

switch selectedPulse
  case 'first'
    x = x(:, 1);
    y = y(:, 1);
  case 'middle'
    assert(ismatrix(y) && ~isvector(y),'option "middle" only valid for 2D arrays');
    nMiddle = ceil(size(y,2) / 2);
    if isvector(x); x = x(:,1); else x = x(:, nMiddle); end
    y = y(:, nMiddle);
  case 'total'
    % for simplicity transform inputs in a 2D array
    x = reshape(x, size(x, 1), []);
    y = reshape(y, size(y, 1), []);
  otherwise
    error('centerOfMass:ArgChk',['valid optiona arguments are',...
      ' ''first'' or ''middle''.']);
end

% get the center of mass
weightedSum = bsxfun(@times, x, y);
cm = sum(weightedSum(:)) / sum(y(:));
% get the array element closest to the center of mass
[~, ix0] = min(abs(x(:,1) - cm));
x0 = x(ix0);
end