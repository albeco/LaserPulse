% @LASERPULSE
%
% Files
%   autocorrelation        - gives the interferometeric autocorrelation
%   binaryOperator         - applies a binary operator to two LaserPulse objects.
%   conj                   - calculates the complex conjugate of a pulse in time domain
%   detrend                - subtracts derivative offset from phase and store it separately
%   harmonic               - gives the n-th harmonic of a laser pulse
%   increaseTimeRange      - increases the time range of the pulse.
%   increaseTimeResolution - pads the frequency spectrum with zeros
%   LaserPulse             - is a class for storing and handling laser pulses.
%   matchDomains           - interpolates two LaserPulse objects to get the same sampling.
%   minus                  - subtracts two pulses.
%   mpower                 - calculate the n-th power of a pulse in time domain.
%   mrdivide               - calculates the ratio of two pulses is time-domain.
%   mtimes                 - multiplies two pulses in time-domain.
%   multByDouble           - rescales field by a numerical factor
%   normalize              - rescales the pulse to unit area
%   plot                   - display a LaserPulse is either time or frequency domain.
%   plus                   - calculates the sum of two pulses.
%   polynomialPhase        - sets the spectral phase to a polynomium
%   power                  - calculates the n-th power of a pulse in time domain.
%   rdivide                - calculates the ratio of two pulses is time-domain.
%   std                    - calculates standard deviation of field amplitude in time and frequency domain
%   times                  - multiplies two pulses in time-domain.
%   translate              - translates the time or freq. axis using the conjugated domain
%   updateField            - calculates time or frequency domain via fft
%   calculateShortestDuration - calculates the tranform limited pulse duration
%   disp                      - displays pulse information
