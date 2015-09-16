function  tests = conjugatedDomain_test
% CONJUGATEDDOMAIN_TEST is a test function for conjugatedDomain.m,
% a private function of LaserPulse Class

% 2015 Alberto Comin, LMU Muenchen
  tests = functiontests(localfunctions);
end

%%
function testConjDomain(testCase)

assertEqual(testCase, testCase.TestData.func('time'), 'frequency');
assertEqual(testCase, testCase.TestData.func('frequency'), 'time');
assertEqual(testCase, testCase.TestData.func('notexisting'), 'notexisting');

end


%%
function setupOnce(testCase)
% get handle to private function
testCase.TestData.func = getPrivateFunction('../@LaserPulse/private', 'conjugatedDomain');
% set relative tolerance for equality comparison
testCase.TestData.reltol = eps;
testCase.TestData.abstol = eps;
end
