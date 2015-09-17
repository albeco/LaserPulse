function  tests = zeropad_test
% ZEROPAD_TEST is a test function for zeropad.m,
% a private function of LaserPulse Class

% 2015 Alberto Comin, LMU Muenchen
  tests = functiontests(localfunctions);
end

%%
function testZeroPadTimeDomain(testCase)

func = testCase.TestData.func;

% check with combinations of even and odd number of points
assertTrue(testCase,checkTimeZeroPadding(func, 10, 4));
assertTrue(testCase,checkTimeZeroPadding(func, 10, 5));
assertTrue(testCase,checkTimeZeroPadding(func, 11, 4));
assertTrue(testCase,checkTimeZeroPadding(func, 11, 5));
end

function testZeroPadFreqDomain(testCase)

func = testCase.TestData.func;

% check with combinations of even and odd number of points
assertTrue(testCase,checkFreqZeroPadding(func, 10, 4));
assertTrue(testCase,checkFreqZeroPadding(func, 10, 5));
assertTrue(testCase,checkFreqZeroPadding(func, 11, 4));
assertTrue(testCase,checkFreqZeroPadding(func, 11, 5));
end

function comp = checkTimeZeroPadding(func, nPoints, nExtraPoints)

t = (1:nPoints)';
p = LaserPulse(t,'s',t);
func(p,'time',nExtraPoints)

x = ifftshift(p.temporalAmplitude);
x = [x(1:ceil(nPoints/2));x(ceil(nPoints/2)+1+nExtraPoints:end)];
x = fftshift(x);

comp = all(x==t);
end

function comp = checkFreqZeroPadding(func, nPoints, nExtraPoints)

f = (1:nPoints)';
p = LaserPulse(f,'Hz',f);
func(p,'frequency',nExtraPoints)

x = ifftshift(p.spectralAmplitude);
x = [x(1:ceil(nPoints/2));x(ceil(nPoints/2)+1+nExtraPoints:end)];
x = fftshift(x);

comp = all(x==f);
end


%%
function setupOnce(testCase)
% get handle to private function
testCase.TestData.func = getPrivateFunction('../@LaserPulse/private', 'zeropad');
% set relative tolerance for equality comparison
testCase.TestData.reltol = 1e-6;
testCase.TestData.abstol = 1e-6;
end
