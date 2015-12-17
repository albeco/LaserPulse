function  tests = integrateFromCenter_test
% INTEGRATEFROMCENTER_TEST is a test function for integrateFromCenter.m,
% a private function of LaserPulse Class

% 2015 Alberto Comin, LMU Muenchen
tests = functiontests(localfunctions);
end

%%
function testZero(testCase)

tolerance = testCase.TestData.abstol;
relTolerance = testCase.TestData.reltol;

x = (-10:1e-3:10).';
ix0 = randi(numel(x));
x0 = x(ix0);

y = 0*x;
exactInt = 0*x;

calcInt = testCase.TestData.func(x, y, x0, 1);
disp(max(abs(calcInt-exactInt)./(exactInt+eps)))
comp = all(abs(calcInt-exactInt) < ...
  max(tolerance, relTolerance * max(abs(calcInt), abs(exactInt))));
assertTrue(testCase, comp);

end

%%
function testPowerLaw(testCase)

tolerance = testCase.TestData.abstol;
relTolerance = testCase.TestData.reltol;

x = (-10:1e-3:10).';

for i = 1:10
  ix0 = randi(numel(x));
  x0 = x(ix0);
  n = randi(3);
  y = (x-x0).^n;
  exactInt = 1/(n+1)*(x-x0).^(n+1);
  
  calcInt = testCase.TestData.func(x, y, x0, 1);
  comp = all(abs(calcInt-exactInt) < ...
    max(tolerance, relTolerance * max(abs(calcInt), abs(exactInt))));
  assertTrue(testCase, comp);
end
end

%%
function testMultipleColumns(testCase)

tolerance = testCase.TestData.abstol;
relTolerance = testCase.TestData.reltol;

x = (-10:1e-3:10).';

for i = 1:10
  ix0 = randi(numel(x));
  x0 = x(ix0);
  n = randi(3);
  y = [(x-x0).^n, sin((x-x0)/n), exp((x-x0)/n)];
  exactInt = [1/(n+1)*(x-x0).^(n+1), -n*cos((x-x0)/n), n*exp((x-x0)/n)];
  exactInt = bsxfun(@minus, exactInt, exactInt(ix0,:));
  
  calcInt = testCase.TestData.func(x, y, x0, 1);
  comp = abs(calcInt-exactInt) < ...
    max(tolerance, relTolerance * max(abs(calcInt), abs(exactInt)));
  comp = all(comp(:));
  assertTrue(testCase, comp);
end
end
%%
function testMultipleDimensions(testCase)

tolerance = testCase.TestData.abstol;
relTolerance = testCase.TestData.reltol;

x = (-10:1e-3:10).';

for i = 1:10
  ix0 = randi(numel(x));
  x0 = x(ix0);
  n = randi(3);
  y = [(x-x0).^n, sin(x-x0), exp(x-x0)];
  exactInt = [1/(n+1)*(x-x0).^(n+1), -cos(x-x0), exp(x-x0)];
  exactInt = bsxfun(@minus, exactInt, exactInt(ix0,:));
  
  % create 3d matrix
  y = cat(3, y, n*y);
  exactInt = cat(3, exactInt, n*exactInt);
  
  calcInt = testCase.TestData.func(x, y, x0, 1);
  comp = abs(calcInt-exactInt) < ...
    max(tolerance, relTolerance * max(abs(calcInt), abs(exactInt)));
  comp = all(comp(:));
  assertTrue(testCase, comp);
end
end

%%
function setupOnce(testCase)
% get handle to private function
testCase.TestData.func = getPrivateFunction('../@LaserPulse/private', 'integrateFromCenter');
% set relative tolerance for equality comparison
testCase.TestData.reltol = 1e-3;
testCase.TestData.abstol = 1e-3;
end
