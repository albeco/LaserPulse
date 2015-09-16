function  tests = centralDiff_test
% CENTRALDIFF_TEST is a test function for centtralDiff.m,
% a private function of LaserPulse Class

% 2015 Alberto Comin, LMU Muenchen
  tests = functiontests(localfunctions);
end

%%
function testRampEven(testCase)

tolerance = testCase.TestData.abstol;
relTolerance = testCase.TestData.reltol;

n = 10;
x = (1:n).';

xDiff = testCase.TestData.func(x);
expDiff = gradient(x);
comp = all(abs(xDiff-expDiff) < tolerance);

assertTrue(testCase, comp);
end

function testRampOdd(testCase)

tolerance = testCase.TestData.abstol;

n = 11;
x = (1:n).';

xDiff = testCase.TestData.func(x);
expDiff = gradient(x);
comp = all(abs(xDiff-expDiff) < tolerance);

assertTrue(testCase, comp);
end

function testRandomColumn(testCase)

tolerance = testCase.TestData.abstol;

n = 30;
x = rand(n,1);

xDiff = testCase.TestData.func(x);
expDiff = gradient(x);
comp = all(abs(xDiff-expDiff) < tolerance);

assertTrue(testCase, comp);
end

function testRandomMatrix(testCase)

tolerance = testCase.TestData.abstol;

n = 3;
x = rand(3,3);

xDiff = testCase.TestData.func(x);

expDiff = zeros(size(x));
for n=1:size(x,2)
  expDiff(:,n) = gradient(x(:,n));
end

comp = all(abs(xDiff(:)-expDiff(:)) < tolerance);

assertTrue(testCase, comp);
end

function testRandomTensor(testCase)

tolerance = testCase.TestData.abstol;

x = rand(3,3,3,4);

xDiff = testCase.TestData.func(x);

% convert to matrix, apply gradient to each column, then convert back
xsize = size(x);
x = reshape(x,size(x,1),[]);
expDiff = zeros(size(x));
for n=1:size(x,2)
    expDiff(:,n) = gradient(x(:,n));
end
expDiff = reshape(expDiff, xsize);

comp = all(abs(xDiff(:)-expDiff(:)) < tolerance);
assertTrue(testCase, comp);
end

%%
function setupOnce(testCase)
% get handle to private function
testCase.TestData.func = getPrivateFunction('../@LaserPulse/private', 'centralDiff');
% set relative tolerance for equality comparison
testCase.TestData.reltol = eps;
testCase.TestData.abstol = eps;
end
