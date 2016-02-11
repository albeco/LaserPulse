function  tests = increaseTimeRange_test
% test function for the increaseTimeRange method of LaserPulse
  tests = functiontests(localfunctions);
end



function testTimeDomain_realPulse(testCase)
step = 0.1;
x = (-10:step:10).';
y = exp(-x.^2);
p = LaserPulse(x,'s',y);
desiredTimeRange = 20;
p.increaseTimeRange(desiredTimeRange);
% check if timeStep remained the same
assertEqual(testCase, step, p.timeStep, 'AbsTol', testCase.TestData.abstol);
% checking inf the time range is right +/- one step
actualTimeRange = max(p.timeArray)-min(p.timeArray);
assertEqual(testCase, desiredTimeRange, actualTimeRange, 'AbsTol', 2*step);
% check if values are not changed too much by interpolation
y2 = interp1(p.timeArray, p.temporalField, x, 'pchip');
assertEqual(testCase, y, y2, 'AbsTol', testCase.TestData.abstol);
end

function testTimeDomain_fracTimeRange(testCase)
step = 0.03;
x = (-10:step:10).';
y = exp(-x.^2);
p = LaserPulse(x,'s',y);
desiredTimeRange = 25.4;
p.increaseTimeRange(desiredTimeRange);
% check if timeStep remained the same
assertEqual(testCase, step, p.timeStep, 'AbsTol', testCase.TestData.abstol);
% checking inf the time range is right within a couple of steps (number of steps is rounded to even)
actualTimeRange = max(p.timeArray)-min(p.timeArray);
assertEqual(testCase, desiredTimeRange, actualTimeRange, 'AbsTol', 2*step);
% check if values are not changed too much by interpolation
y2 = interp1(p.timeArray, p.temporalField, x, 'pchip');
assertEqual(testCase, real(y), real(y2), 'AbsTol', testCase.TestData.abstol);
end

function testTimeDomain_complexPulse(testCase)
step = 0.03;
x = (-10:step:10).';
y = exp(-x.^2 +1i*sin(2*pi*x));
p = LaserPulse(x,'s',y);
desiredTimeRange = 25.4;
p.increaseTimeRange(desiredTimeRange);
% check if timeStep remained the same
assertEqual(testCase, step, p.timeStep, 'AbsTol', testCase.TestData.abstol);
% checking inf the time range is right within a couple of steps (number of steps is rounded to even)
actualTimeRange = max(p.timeArray)-min(p.timeArray);
assertEqual(testCase, desiredTimeRange, actualTimeRange, 'AbsTol', 2*step);
% check if values are not changed too much by interpolation
y2 = interp1(p.timeArray, p.temporalField, x, 'pchip');
assertEqual(testCase, real(y), real(y2), 'AbsTol', 1e-2);
assertEqual(testCase, imag(y), imag(y2), 'AbsTol', 1e-2);
end

function testFreqDomain_realPulse(testCase)
freqstep = 0.1;
x = (-10:freqstep:10).';
y = exp(-x.^2);
step = 1/freqstep/numel(x);
p = LaserPulse(x,'Hz',y);
desiredTimeRange = 20;
p.increaseTimeRange(desiredTimeRange);
% check if timeStep remained the same
assertEqual(testCase, step, p.timeStep, 'AbsTol', testCase.TestData.abstol);
% checking inf the time range is right +/- one step
actualTimeRange = max(p.timeArray)-min(p.timeArray);
assertEqual(testCase, desiredTimeRange, actualTimeRange, 'AbsTol', 2*step);
% check if values are not changed too much by interpolation
y2 = interp1(p.frequencyArray, p.spectralField, x, 'pchip');
assertEqual(testCase, y, y2, 'AbsTol', testCase.TestData.abstol);
end

function testFreqDomain_fracTimeRange(testCase)
freqstep = 0.03;
x = (-10:freqstep:10).';
y = exp(-x.^2);
step = 1/freqstep/numel(x);
p = LaserPulse(x,'Hz',y);
desiredTimeRange = 57.4;
p.increaseTimeRange(desiredTimeRange);
% check if timeStep remained the same
assertEqual(testCase, step, p.timeStep, 'AbsTol', testCase.TestData.abstol);
% checking inf the time range is right within a couple of steps (number of steps is rounded to even)
actualTimeRange = max(p.timeArray)-min(p.timeArray);
assertEqual(testCase, desiredTimeRange, actualTimeRange, 'AbsTol', 2*step);
% check if values are not changed too much by interpolation
y2 = interp1(p.frequencyArray, p.spectralField, x, 'pchip');
assertEqual(testCase, real(y), real(y2), 'AbsTol', testCase.TestData.abstol);
end

function testFreqDomain_complexPulse(testCase)
freqstep = 0.03;
x = (-10:freqstep:10).';
y = exp(-x.^2 +1i*sin(4*pi*x));
step = 1/freqstep/numel(x);
p = LaserPulse(x,'Hz',y);
desiredTimeRange = 132.45;
p.increaseTimeRange(desiredTimeRange);
% check if timeStep remained the same
assertEqual(testCase, step, p.timeStep, 'AbsTol', testCase.TestData.abstol);
% checking inf the time range is right within a couple of steps (number of steps is rounded to even)
actualTimeRange = max(p.timeArray)-min(p.timeArray);
assertEqual(testCase, desiredTimeRange, actualTimeRange, 'AbsTol', 2*step);
% check if values are not changed too much by interpolation
y2 = interp1(p.frequencyArray, p.spectralField, x, 'pchip');
assertEqual(testCase, real(y), real(y2), 'AbsTol', 1e-2);
assertEqual(testCase, imag(y), imag(y2), 'AbsTol', 1e-2);
end


function setupOnce(testCase)
% set relative tolerance for equality comparison
testCase.TestData.reltol = 1e-3;
testCase.TestData.abstol = 1e-3;
end
