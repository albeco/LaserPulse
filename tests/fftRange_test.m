function  tests = fftRange_test
% FFTRANGE_TEST is a test function for fftRange.m,
% a private function of LaserPulse Class

% 2015 Alberto Comin, LMU Muenchen
tests = functiontests(localfunctions);
end

%%
function testEvenPoints(testCase)

n = 10;
x = testCase.TestData.func(n);
x = fftshift(x);

assertEqual(testCase, n, numel(x));
assertEqual(testCase, x(1), -floor(n/2));
assertTrue(testCase, all(diff(x)==1));
end

function testOddPoints(testCase)

n = 11;
x = testCase.TestData.func(n);
x = fftshift(x);

assertEqual(testCase, n, numel(x));
assertEqual(testCase, x(1), -floor(n/2));
assertTrue(testCase, all(diff(x)==1));
end


%%
function setupOnce(testCase)
% get handle to private function
testCase.TestData.func = getPrivateFunction('../@LaserPulse/private', 'fftRange');
% set relative tolerance for equality comparison
testCase.TestData.reltol = eps;
testCase.TestData.abstol = eps;
end
