function  tests = sameOffsets_test
% SAMEOFFSETS_TEST is a test function for sameOffsets.m,
% a private function of LaserPulse Class

% 2015 Alberto Comin, LMU Muenchen
  tests = functiontests(localfunctions);
end

%%
function testSameOffets(testCase)

t = -10:10;
Et = exp(-t.^2);
p1 = LaserPulse(t, 's', Et);
p2 = LaserPulse(t, 's', Et.^2);

p2.timeOffset = p1.timeOffset;
p2.frequencyOffset = p2.frequencyOffset;
assertTrue(testCase,testCase.TestData.func(p1,p2,testCase.TestData.abstol));

p2.timeOffset = p1.timeOffset;
p2.frequencyOffset = p1.frequencyOffset + 1;
assertFalse(testCase,testCase.TestData.func(p1,p2,testCase.TestData.abstol));

p2.timeOffset = p1.timeOffset + 1;
p2.frequencyOffset = p2.frequencyOffset;
assertFalse(testCase,testCase.TestData.func(p1,p2,testCase.TestData.abstol));
end

%%
function setupOnce(testCase)
% get handle to private function
testCase.TestData.func = getPrivateFunction('../@LaserPulse/private', 'sameOffsets');
% set relative tolerance for equality comparison
testCase.TestData.reltol = 1e-6;
testCase.TestData.abstol = 1e-6;
end
