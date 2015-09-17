function tests = interpFreqDomain_test
% INTERPFREQDOMAIN_TEST is a test function for interpFreqDomain.m,
% a private function of LaserPulse Class

% 2015 Alberto Comin, LMU Muenchen

tests = functiontests(localfunctions);
end

%%
function testFreqDomainPulse(testCase)
f = linspace(-10, 10, 100).';
Af = exp(-f.^2);
phi = sin(f);

f_i = linspace(-10, 10, 131).';
Af_i = interp1(f, Af, f_i, 'linear');
phi_i = interp1(f, phi, f_i, 'linear');

p = LaserPulse(f,'Hz',Af,phi);
testCase.TestData.func(p, f_i);

assertEqual(testCase, max(abs(p.spectralAmplitude-Af_i)), 0, ...
  'relTol', testCase.TestData.reltol, 'absTol', testCase.TestData.abstol);
assertEqual(testCase, max(abs(p.spectralPhase-phi_i)), 0, ...
  'relTol', testCase.TestData.reltol, 'absTol', testCase.TestData.abstol);
end

function testTimeDomainPulse(testCase)

t = linspace(-10, 10, 100).';
At = exp(-t.^2);
phi_t = sin(t);
p = LaserPulse(t,'s',At,phi_t);

f = p.frequencyArray;
Af = p.spectralAmplitude;
phi = p.spectralPhase;

f_i = linspace(f(1), f(end), 131).';
Af_i = interp1(f, Af, f_i, 'linear');
phi_i = interp1(f, phi, f_i, 'linear');

testCase.TestData.func(p, f_i);

assertEqual(testCase, max(abs(p.spectralAmplitude-Af_i)), 0, ...
  'relTol', testCase.TestData.reltol, 'absTol', testCase.TestData.abstol);
assertEqual(testCase, max(abs(p.spectralPhase-phi_i)), 0, ...
  'relTol', testCase.TestData.reltol, 'absTol', testCase.TestData.abstol);
end

%%
function setupOnce(testCase)
% get handle to private function
testCase.TestData.func = getPrivateFunction('../@LaserPulse/private', 'interpFreqDomain');
% set relative tolerance for equality comparison
testCase.TestData.reltol = 1e-6;
testCase.TestData.abstol = 1e-6;
end