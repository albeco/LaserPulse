function  tests = calculateFWHM_test
% CALCULATEFWHM_TEST is a test function for calculateFWHM.m,
% a private function of LaserPulse Class

% 2015 Alberto Comin, LMU Muenchen

tests = functiontests(localfunctions);
end

%%
function testGaussian(testCase)
fwhm = 1.3;
offset = 2.123;
x = (-10 : 0.01 : 10)';
y = exp(-4*log(2)*x.^2/fwhm^2) + offset;

actSolution = testCase.TestData.func(x, y);
expSolution = fwhm;
relTolerance = testCase.TestData.reltol;

assertEqual(testCase, actSolution, expSolution,'RelTol', relTolerance);
end

function testNegativeGaussian(testCase)
fwhm = 0.7;
offset = 0.2;
x = (-10 : 0.01 : 10)';
y = -1 * exp(-4*log(2)*x.^2/fwhm^2) + offset;

actSolution = testCase.TestData.func(x, y);
expSolution = fwhm;
relTolerance = testCase.TestData.reltol;

assertEqual(testCase, actSolution, expSolution,'RelTol', relTolerance);
end

function testSquare(testCase)
fwhm = 2.24;
x = (-10 : 0.01 : 10)';
y = abs(x) <= fwhm/2;

actSolution = testCase.TestData.func(x, y);
expSolution = fwhm;
relTolerance = testCase.TestData.reltol;

assertEqual(testCase, actSolution, expSolution,'RelTol', relTolerance);
end

function testNegativeSquare(testCase)
fwhm = 1.37;
x = (-10 : 0.01 : 10)';
y = abs(x) <= fwhm/2;

actSolution = testCase.TestData.func(x, -y);
expSolution = fwhm;
relTolerance = testCase.TestData.reltol;

assertEqual(testCase, actSolution, expSolution,'RelTol', relTolerance);
end

%%
function setupOnce(testCase)
% get handle to private function
testCase.TestData.func = getPrivateFunction('../@LaserPulse/private', 'calculateFWHM');
% set relative tolerance for equality comparison
testCase.TestData.reltol = 1e-2;
end
