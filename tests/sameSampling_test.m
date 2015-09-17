function  tests = sameSampling_test
% SAMESAMPLING_TEST is a test function for sameSampling.m,
% a private function of LaserPulse Class

% 2015 Alberto Comin, LMU Muenchen
  tests = functiontests(localfunctions);
end

%%
function testSameSampling_TimeDomain(testCase)

t = -10:10;
Et = exp(-t.^2);

p1 = LaserPulse(t, 's', Et);
p2 = LaserPulse(t, 's', Et.^2);
p3 = LaserPulse(t*2, 's', Et.^2);

assertTrue(testCase,testCase.TestData.func(p1,p2,testCase.TestData.abstol));
assertFalse(testCase,testCase.TestData.func(p1,p3,testCase.TestData.abstol));

end

function testSameSampling_FreqDomain(testCase)

f = -10:10;
Ef = exp(-f.^2);

p1 = LaserPulse(f, 'Hz', Ef);
p2 = LaserPulse(f, 'Hz', Ef.^2);
p3 = LaserPulse(f*2, 'Hz', Ef.^2);

assertTrue(testCase,testCase.TestData.func(p1,p2,testCase.TestData.abstol));
assertFalse(testCase,testCase.TestData.func(p1,p3,testCase.TestData.abstol));

end

%%
function setupOnce(testCase)
% get handle to private function
testCase.TestData.func = getPrivateFunction('../@LaserPulse/private', 'sameSampling');
% set relative tolerance for equality comparison
testCase.TestData.reltol = 1e-6;
testCase.TestData.abstol = 1e-6;
end
