function  tests = centerArray_test
  tests = functiontests(localfunctions);
end

%%
function testColumnEvenPoints(testCase)

tolerance = testCase.TestData.abstol;
relTolerance = testCase.TestData.reltol;

x = (1:10).';
[y, x0, dx] = testCase.TestData.func(x);

assertEqual(testCase, x0, x(1+floor(length(x)/2)), 'RelTol', relTolerance, 'AbsTol', tolerance);
assertEqual(testCase, dx, x(2)-x(1), 'RelTol', relTolerance, 'AbsTol', tolerance);
assertEqual(testCase, max(abs(y+x0-x)), 0, 'RelTol', relTolerance, 'AbsTol', tolerance);
end

function testColumnOddPoints(testCase)

tolerance = testCase.TestData.abstol;
relTolerance = testCase.TestData.reltol;

x = (1:15).';
[y, x0, dx] = testCase.TestData.func(x);

assertEqual(testCase, x0, x(1+floor(length(x)/2)), 'RelTol', relTolerance, 'AbsTol', tolerance);
assertEqual(testCase, dx, x(2)-x(1), 'RelTol', relTolerance, 'AbsTol', tolerance);
assertEqual(testCase, max(abs(y+x0-x)), 0, 'RelTol', relTolerance, 'AbsTol', tolerance);
end

function testRowEvenPoints(testCase)

tolerance = testCase.TestData.abstol;
relTolerance = testCase.TestData.reltol;

x = linspace(12, 45.7, 100);
[y, x0, dx] = testCase.TestData.func(x);

assertEqual(testCase, x0, x(1+floor(length(x)/2)), 'RelTol', relTolerance, 'AbsTol', tolerance);
assertEqual(testCase, dx, x(2)-x(1), 'RelTol', relTolerance, 'AbsTol', tolerance);
assertEqual(testCase, max(abs(y+x0-x)), 0, 'RelTol', relTolerance, 'AbsTol', tolerance);
end

function testRowOddPoints(testCase)

tolerance = testCase.TestData.abstol;
relTolerance = testCase.TestData.reltol;


x = linspace(12, 45.7, 19);
[y, x0, dx] = testCase.TestData.func(x);

assertEqual(testCase, x0, x(1+floor(length(x)/2)), 'RelTol', relTolerance, 'AbsTol', tolerance);
assertEqual(testCase, dx, x(2)-x(1), 'RelTol', relTolerance, 'AbsTol', tolerance);
assertEqual(testCase, max(abs(y+x0-x)), 0, 'RelTol', relTolerance, 'AbsTol', tolerance);
end

%%
function setupOnce(testCase)
% get handle to private function
testCase.TestData.func = getPrivateFunction('../@LaserPulse/private', 'centerArray');
% set relative tolerance for equality comparison
testCase.TestData.reltol = 1e-6;
testCase.TestData.abstol = 1e-6;
end
