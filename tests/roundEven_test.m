function  tests = roundEven_test
% ROUNDEVEN_TEST is a test function for roundEven.m,
% a private function of LaserPulse Class

% 2015 Alberto Comin, LMU Muenchen
  tests = functiontests(localfunctions);
end

%%
function testRoundEven(testCase)

assertEqual(testCase, testCase.TestData.func(3.0), 2);
assertEqual(testCase, testCase.TestData.func(3.2), 4);
assertEqual(testCase, testCase.TestData.func(3.5), 4);
assertEqual(testCase, testCase.TestData.func(3.9), 4);
assertEqual(testCase, testCase.TestData.func(4.9), 4);
assertEqual(testCase, testCase.TestData.func(5.0), 4);
assertEqual(testCase, testCase.TestData.func(5.1), 6);

end

%%
function setupOnce(testCase)
% get handle to private function
testCase.TestData.func = getPrivateFunction('../@LaserPulse/private', 'roundEven');
% set relative tolerance for equality comparison
testCase.TestData.reltol = 1e-6;
testCase.TestData.abstol = 1e-6;
end
