function y = ndDetrend( x )
%NDDETREND generalizes detrend to multi-dimensional arrays
%   transforms input to matrix, detrends it, and transforms it back

% 2017 Alberto Comin, LMU Muenchen

y = reshape(x,size(x,1),[]);
y = detrend(y);
y = reshape(y, size(x));

end

