function  tests = getCenterOfMass_test
% GETCENTEROFMASS_TEST is a test function for getCenterOfMass.m,
% a private function of LaserPulse Class

% 2015 Alberto Comin, LMU Muenchen
  tests = functiontests(localfunctions);
end

%%
function testOneColumn(testCase)
tolerance = testCase.TestData.abstol;

n = 10;
y = rand(n,1);
x = (1:n).';

[x0, ix0, cm] = testCase.TestData.func(x, y);
cmExp = sum(x.*y)/sum(y);
[~, ix0Exp] = min(abs(cmExp-x));
x0Exp = x(ix0Exp);

assertEqual(testCase, cm, cmExp,'AbsTol',tolerance);
assertEqual(testCase, x0, x0Exp,'AbsTol',tolerance);
assertEqual(testCase, ix0, ix0Exp,'AbsTol',tolerance);
end

function testOneColumnNoX(testCase)
tolerance = testCase.TestData.abstol;

n = 10;
y = rand(n,1);
x = (1:n).';

[x0, ix0, cm] = testCase.TestData.func([], y);
cmExp = sum(x.*y)/sum(y);
[~, ix0Exp] = min(abs(cmExp-x));
x0Exp = x(ix0Exp);

assertEqual(testCase, cm, cmExp,'AbsTol',tolerance);
assertEqual(testCase, x0, x0Exp,'AbsTol',tolerance);
assertEqual(testCase, ix0, ix0Exp,'AbsTol',tolerance);
end

function testMatrixFirstColumn(testCase)
tolerance = testCase.TestData.abstol;

n = 10;
y = rand(n,n);
x = (1:n).';

[x0, ix0, cm] = testCase.TestData.func(x, y, 'first');
cmExp = sum(x.*y(:,1))/sum(y(:,1));
[~, ix0Exp] = min(abs(cmExp-x));
x0Exp = x(ix0Exp);

assertEqual(testCase, cm, cmExp,'AbsTol',tolerance);
assertEqual(testCase, x0, x0Exp,'AbsTol',tolerance);
assertEqual(testCase, ix0, ix0Exp,'AbsTol',tolerance);
end

function testMatrixMiddleColumn(testCase)
tolerance = testCase.TestData.abstol;

n = 10;
y = rand(n,n);
x = (1:n).';

[x0, ix0, cm] = testCase.TestData.func(x, y, 'middle');
nmiddle = ceil(size(y,2) / 2);
cmExp = sum(x.*y(:,nmiddle))/sum(y(:,nmiddle));
[~, ix0Exp] = min(abs(cmExp-x));
x0Exp = x(ix0Exp);

assertEqual(testCase, cm, cmExp,'AbsTol',tolerance);
assertEqual(testCase, x0, x0Exp,'AbsTol',tolerance);
assertEqual(testCase, ix0, ix0Exp,'AbsTol',tolerance);
end

function testMatrixTotalIntensity(testCase)
tolerance = testCase.TestData.abstol;

n = 10;
y = rand(n,n);
x = (1:n).';

[x0, ix0, cm] = testCase.TestData.func(x, y, 'total');
cmExp = sum(sum(bsxfun(@times, x,y))) / sum(sum(y));
[~, ix0Exp] = min(abs(cmExp-x));
x0Exp = x(ix0Exp);

assertEqual(testCase, cm, cmExp,'AbsTol',tolerance);
assertEqual(testCase, x0, x0Exp,'AbsTol',tolerance);
assertEqual(testCase, ix0, ix0Exp,'AbsTol',tolerance);
end

function testTensorFirstColumn(testCase)
tolerance = testCase.TestData.abstol;

n = 10;
y = rand(n,n,3);
x = (1:n).';

[x0, ix0, cm] = testCase.TestData.func(x, y, 'first');
y = reshape(y, size(y,1), []);
cmExp = sum(x.*y(:,1))/sum(y(:,1));
[~, ix0Exp] = min(abs(cmExp-x));
x0Exp = x(ix0Exp);

assertEqual(testCase, cm, cmExp,'AbsTol',tolerance);
assertEqual(testCase, x0, x0Exp,'AbsTol',tolerance);
assertEqual(testCase, ix0, ix0Exp,'AbsTol',tolerance);
end

function testTensorTotalIntensity(testCase)
tolerance = testCase.TestData.abstol;

n = 10;
y = rand(n,n,3);
x = (1:n).';

[x0, ix0, cm] = testCase.TestData.func(x, y, 'total');

y = reshape(y, size(y,1), []);
cmExp = sum(sum(bsxfun(@times, x,y))) / sum(sum(y));

[~, ix0Exp] = min(abs(cmExp-x));
x0Exp = x(ix0Exp);

assertEqual(testCase, cm, cmExp,'AbsTol',tolerance);
assertEqual(testCase, x0, x0Exp,'AbsTol',tolerance);
assertEqual(testCase, ix0, ix0Exp,'AbsTol',tolerance);
end

%%
function setupOnce(testCase)
% get handle to private function
testCase.TestData.func = getPrivateFunction('../@LaserPulse/private', 'getCenterOfMass');
% set relative tolerance for equality comparison
testCase.TestData.reltol = 1e-6;
testCase.TestData.abstol = 1e-6;
end
