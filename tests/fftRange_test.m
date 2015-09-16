function  tests = fftRange_test
% FFTRANGE_TEST is a test function for fftRange.m,
% a private function of LaserPulse Class

% 2015 Alberto Comin, LMU Muenchen
  tests = functiontests(localfunctions);
end

%%
function testEvenPoints(testCase)

tolerance = testCase.TestData.abstol;
relTolerance = testCase.TestData.reltol;

n = 10;
x = testCase.TestData.func(n);
xshifted = fftshift(x);

assertEqual(testCase, x(1), 0, 'RelTol', relTolerance, 'AbsTol', tolerance);
assertEqual(testCase, x(end), -1, 'RelTol', relTolerance, 'AbsTol', tolerance);
assertEqual(testCase, xshifted(1), -floor(n/2), 'RelTol', relTolerance, 'AbsTol', tolerance);
end

function testOddPoints(testCase)

tolerance = testCase.TestData.abstol;
relTolerance = testCase.TestData.reltol;

n = 11;
x = testCase.TestData.func(n);
xshifted = fftshift(x);

assertEqual(testCase, x(1), 0, 'RelTol', relTolerance, 'AbsTol', tolerance);
assertEqual(testCase, x(end), -1, 'RelTol', relTolerance, 'AbsTol', tolerance);
assertEqual(testCase, xshifted(1), -floor(n/2), 'RelTol', relTolerance, 'AbsTol', tolerance);
end


%%
function setupOnce(testCase)
% get handle to private function
testCase.TestData.func = getPrivateFunction('../@LaserPulse/private', 'fftRange');
% set relative tolerance for equality comparison
testCase.TestData.reltol = eps;
testCase.TestData.abstol = eps;
end
