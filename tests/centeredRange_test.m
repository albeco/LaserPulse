function  tests = centeredRange_test
% CENTEREDRANGE_TEST is a test function for centeredRange.m,
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

assertEqual(testCase, n, numel(x));
assertEqual(testCase, x(1), -floor(n/2));
assertTrue(testCase, all(diff(x)==1));
end

function testOddPoints(testCase)

tolerance = testCase.TestData.abstol;
relTolerance = testCase.TestData.reltol;

n = 11;
x = testCase.TestData.func(n);

assertEqual(testCase, n, numel(x));
assertEqual(testCase, x(1), -floor(n/2));
assertTrue(testCase, all(diff(x)==1));
end


%%
function setupOnce(testCase)
% get handle to private function
testCase.TestData.func = getPrivateFunction('../@LaserPulse/private', 'centeredRange');
% set relative tolerance for equality comparison
testCase.TestData.reltol = eps;
testCase.TestData.abstol = eps;
end
