function tests = checkUnit_test
% CHECKUNIT_TEST is a test function for checkUnit.m,
% a private function of LaserPulse Class

% 2015 Alberto Comin, LMU Muenchen

tests = functiontests(localfunctions);
end

%%
function testTimeUnits(testCase)
timeUnits = testCase.TestData.timeUnits;
frequencyUnits = testCase.TestData.frequencyUnits;

for n = 1:numel(timeUnits)
  [unitType, exponent, inverseUnit ] = testCase.TestData.func( timeUnits{n} );
  verifyEqual(testCase, unitType, 'time');
  verifyEqual(testCase, exponent, -27+3*n);
  verifyEqual(testCase, inverseUnit, frequencyUnits{numel(frequencyUnits)-n+1});
end
end

function testFrequencyUnits(testCase)
timeUnits = testCase.TestData.timeUnits;
frequencyUnits = testCase.TestData.frequencyUnits;

for n = 1:numel(frequencyUnits)
  [unitType, exponent, inverseUnit ] = testCase.TestData.func( frequencyUnits{n} );
  verifyEqual(testCase, unitType, 'frequency');
  verifyEqual(testCase, exponent, -27+3*n);
  verifyEqual(testCase, inverseUnit, timeUnits{numel(timeUnits)-n+1});
end
end

%%
function setupOnce(testCase)
% get handle to private function
testCase.TestData.func = getPrivateFunction('../@LaserPulse/private', 'checkUnit');
% set relative tolerance for equality comparison
testCase.TestData.reltol = 1e-6;
testCase.TestData.abstol = 1e-6;
% define list of supported units
testCase.TestData.timeUnits = ...
  {'ys', 'zs', 'as', 'fs', 'ps', 'ns', 'us', 'ms','s', ...
   'ks', 'Ms', 'Gs', 'Ts', 'Ps', 'Es', 'Zs', 'Ys'};
testCase.TestData.frequencyUnits = ...
  {'yHz', 'zHz', 'aHz', 'fHz', 'pHz', 'nHz', 'uHz', 'mHz','Hz', ...
   'kHz', 'MHz', 'GHz', 'THz', 'PHz', 'EHz', 'ZHz', 'YHz'};
end