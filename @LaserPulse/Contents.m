% @LASERPULSE
%
% Files
%   abs                       - calculates the absolute value of a pulse in the active domain.
%   autocorrelation           - gives the interferometric autocorrelation
%   binaryOperator            - applies a binary operator to two LaserPulse objects.
%   calculateShortestDuration - calculates the tranform limited pulse duration
%   conj                      - calculates the complex conjugate of a pulse in the active domain.
%   detrend                   - subtracts derivative offset from phase and store it separately
%   disp                      - displays pulse information
%   harmonic                  - gives the n-th harmonic of a laser pulse
%   increaseNumberFreqSteps   - increases nPoints keeping frequencyStep fixed
%   increaseNumberTimeSteps   - increases nPoints keeping timeStep fixed
%   increaseTimeRange         - increases the time range of the pulse.
%   increaseTimeResolution    - pads the frequency domain with zeros.
%   LaserPulse                - is a class for storing and handling laser pulses.
%   matchDomains              - interpolates two LaserPulse objects to get the same sampling.
%   minus                     - subtracts two pulses.
%   mpower                    - calculate the n-th power of a pulse in the active domain.
%   mrdivide                  - calculates the ratio of two pulses in the active domain of the first pulse.
%   mtimes                    - multiplies two pulses in the active domain of the first pulse.
%   multByDouble              - multiplies a pulse by a numerical factor or numerical array
%   normalize                 - rescales the pulse to unit area
%   plot                      - display a LaserPulse is either time or frequency domain.
%   plus                      - calculates the sum of two pulses.
%   polynomialPhase           - sets the spectral phase to a polynomium
%   power                     - calculates the n-th power of a pulse in the active domain.
%   propagate                 - propagates a pulse through a medium
%   rdivide                   - calculates the ratio of two pulses in the active domain of the first pulse.
%   size                      - gives the array size of the electric field
%   std                       - calculates standard deviation of field amplitude in time and frequency domain
%   times                     - multiplies two pulses in the active domain of the first pulse.
%   translate                 - translates the time or freq. axis using the conjugated domain
%   updateField               - calculates time or frequency domain via fft
