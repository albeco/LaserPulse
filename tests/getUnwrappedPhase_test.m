function  tests = getUnwrappedPhase_test
% GETUNWRAPPEDPHASE_TEST is a test function for getUnwrappedPhase.m,
% a private function of LaserPulse Class

% 2015 Alberto Comin, LMU Muenchen

tests = functiontests(localfunctions);
end

%%
function testLinearPhase(testCase)

tolerance = testCase.TestData.abstol;

x = (1:100).';
z = exp((x-30).^2/100) .* exp(1i * pi/10 * x);
[~, ix0, ~] = testCase.TestData.getCM([], abs(z).^2, 'total');
% wrapped phase
phi = angle(z);
phiUnwrap = testCase.TestData.func(z);

% check if phase is really uwrapped
assertLessThanOrEqual(testCase, max(diff(phiUnwrap)), pi);
% check that phase is not altered
assertEqual(testCase, mod(max(abs(phi-angle(exp(1i*phiUnwrap)))), 2*pi), 0, ...
  'AbsTol',tolerance);
% check that the phase is unwrapped from the center
assertEqual(testCase, mod(phi(ix0)-phiUnwrap(ix0),2*pi), 0, 'AbsTol',tolerance);
end

function testQuadraticPhase(testCase)

tolerance = testCase.TestData.abstol;

x = (1:100).';
z = exp((x-30).^2/100) .* exp(1i * pi/10 * x.^2);
[~, ix0, ~] = testCase.TestData.getCM([], abs(z).^2, 'total');
% wrapped phase
phi = angle(z);
phiUnwrap = testCase.TestData.func(z);

% check if phase is really uwrapped
assertLessThanOrEqual(testCase, max(diff(phiUnwrap)), pi);
% check that phase is not altered
assertEqual(testCase, mod(max(abs(phi-angle(exp(1i*phiUnwrap)))), 2*pi), 0, ...
  'AbsTol',tolerance);
% check that the phase is unwrapped from the center
assertEqual(testCase, mod(phi(ix0)-phiUnwrap(ix0),2*pi), 0, 'AbsTol',tolerance);
end

function testMultipleSubPulses(testCase)

tolerance = testCase.TestData.abstol;

x = (1:100).';
coeff = 0:pi/10:pi/2;
z = repmat(exp((x-30).^2/100), 1, numel(coeff)) .* ...
  exp(1i * bsxfun(@times, coeff, x.^2));
[~, ix0, ~] = testCase.TestData.getCM([], abs(z).^2, 'total');
% wrapped phase
phi = angle(z);
phiUnwrap = testCase.TestData.func(z);

% check if phase is really uwrapped
assertLessThanOrEqual(testCase, max(max(diff(phiUnwrap))), pi);
% check that phase is not altered
assertEqual(testCase, mod(max(max(abs(phi-angle(exp(1i*phiUnwrap))))), 2*pi), 0, ...
  'AbsTol',tolerance);
% check that the phase is unwrapped from the center
totalMax = @(x) max(x(:));
assertEqual(testCase, totalMax(abs(mod(phi(ix0,:)-phiUnwrap(ix0,:),2*pi))), 0, 'AbsTol',tolerance);
end

function testMultipleSubPulses_Tensor(testCase)

tolerance = testCase.TestData.abstol;

x = (1:100).';
coeff = 0:pi/10:pi/2;
z = repmat(exp((x-30).^2/100), 1, numel(coeff)) .* ...
  exp(1i * bsxfun(@times, coeff, x.^2));
z = repmat(z,1,1,3,2);
[~, ix0, ~] = testCase.TestData.getCM([], abs(z).^2, 'total');
% wrapped phase
phi = angle(z);
phiUnwrap = testCase.TestData.func(z);

% check if phase is really uwrapped
totalMax = @(x) max(x(:));
assertLessThanOrEqual(testCase, totalMax(diff(phiUnwrap)), pi);
% check that phase is not altered
assertEqual(testCase, mod(totalMax(abs(phi-angle(exp(1i*phiUnwrap)))), 2*pi), 0, ...
  'AbsTol',tolerance);
% check that the phase is unwrapped from the center
assertEqual(testCase, totalMax(abs(mod(phi(ix0,:)-phiUnwrap(ix0,:),2*pi))), 0, 'AbsTol',tolerance);
end

%%
function setupOnce(testCase)
% get handle to private function
testCase.TestData.getCM  = getPrivateFunction('../@LaserPulse/private', 'getCenterOfMass');
testCase.TestData.func = getPrivateFunction('../@LaserPulse/private', 'getUnwrappedPhase');
% set relative tolerance for equality comparison
testCase.TestData.reltol = 1e-6;
testCase.TestData.abstol = 1e-6;
end
