function  tests = waveUnit_test
% tests = waveUnit_test is a test function for WaveUnit.m,

tests = functiontests(localfunctions);
end

%%
function test_constructor(testCase)
% test fullname, prefix and base unit
for p = testCase.TestData.prefixes
  for u = testCase.TestData.baseunits
    unitname = [p{1},u{1}];
    unit = WaveUnit(unitname);
    assertTrue(testCase, strcmp(unitname, unit.name));
    assertTrue(testCase, strcmp(p, unit.SIprefix));
    assertTrue(testCase, strcmp(u, unit.baseUnit));
  end
end
% test prefixes and exponents
exponent = -24;
prefixes = testCase.TestData.prefixes;
assert(numel(prefixes) == numel(-24:3:24), ...
  'the test suite does not contain all SI prefixes');
for p = testCase.TestData.prefixes
  unit = WaveUnit([p{1},'s']);
  assertEqual(testCase, unit.exponent, exponent);
  exponent = exponent + 3;
end
% test dimensions
dimensions = testCase.TestData.dimensions;
baseunits = testCase.TestData.baseunits;
assert(numel(dimensions) == numel(baseunits), ...
  'testsuite have wrong dimensions or baseunits data');
for n = 1:numel(baseunits)
  unit = WaveUnit(baseunits{n});
  assertTrue(testCase, strcmp(dimensions{n}, unit.dimension));
end
end

%% test equality operator
function test_eq(testCase)
assertEqual(testCase, ...
  WaveUnit('km'), WaveUnit('km'));
assertNotEqual(testCase, ...
  WaveUnit('km'), WaveUnit('mm'));
assertNotEqual(testCase, ...
  WaveUnit('km'), WaveUnit('ks'));
assertNotEqual(testCase, ...
  WaveUnit('km'), WaveUnit('ms'));
end

%%
function test_invertUnit(testCase)
prefixes = testCase.TestData.prefixes;
invPrefixes = prefixes(end:-1:1);
for n=1:numel(prefixes)
  % from time to frequency
  un1 = WaveUnit([prefixes{n}, 's']).inverse;
  assertTrue(testCase, isa(un1, 'WaveUnit'));
  un2 = WaveUnit([invPrefixes{n}, 'Hz']);
  assertEqual(testCase, un1, un2);
  % from frequency to time
  un1 = WaveUnit([prefixes{n}, 'Hz']).inverse;
  assertTrue(testCase, isa(un1, 'WaveUnit'));
  un2 = WaveUnit([invPrefixes{n}, 's']);
  assertEqual(testCase, un1, un2);
end
end


%%
function test_convert(testCase)
% test same units
assertEqual(testCase, WaveUnit.convert(1, 'ms','ms'), 1);
assertEqual(testCase, WaveUnit.convert(1.2, 'ms','s'), 1.2e-3);
assertEqual(testCase, WaveUnit.convert(2, 's','ms'), 2000);
assertEqual(testCase, WaveUnit.convert(1, 'Ym','ym'), 1e48);
% test eV to Joule and vice-versa
assertEqual(testCase, WaveUnit.convert(1, 'eV', 'J'), testCase.TestData.electronCharge, ...
  'RelTol', testCase.TestData.reltol)
assertEqual(testCase, WaveUnit.convert(1e19, 'eV', 'J'), 1.6, 'AbsTol', 0.01)
assertEqual(testCase, WaveUnit.convert(1, 'MeV', 'J'), 1.6e-13, 'AbsTol', 0.01)
assertEqual(testCase, WaveUnit.convert(1.6, 'J', 'eV'), 1e19, 'RelTol', 0.01);
assertEqual(testCase, WaveUnit.convert(1.6, 'aJ', 'eV'), 10, 'RelTol', 0.01);
% test nonscalar input
x = repmat(magic(3),1,1,4);
y = WaveUnit.convert(x, 'eV', 'meV');
assertSize(testCase, y, size(x));
assertTrue(testCase, all(abs(y(:)-1000*x(:))<testCase.TestData.abstol));
end

%%
function test_frequency2wavelength(testCase)
c = testCase.TestData.speedOfLight;
assertEqual(testCase, WaveUnit.frequency2wavelength(1, 'GHz', 'm'), 0.3, 'RelTol', 0.01);
assertEqual(testCase, ...
  WaveUnit.frequency2wavelength(1e-2, 'GHz', 'mm'), c*1e-4,'RelTol',testCase.TestData.reltol);
assertEqual(testCase, ...
  WaveUnit.frequency2wavelength(2.3, 'Hz', 'm'), c/2.3,'relTol',testCase.TestData.reltol);
assertEqual(testCase, ...
  WaveUnit.frequency2wavelength(Inf, 'Hz', 'm'), 0);
assertTrue(testCase, isinf(WaveUnit.frequency2wavelength(0, 'Hz', 'm')));
[~, wlUnit] = WaveUnit.frequency2wavelength(1, 'THz', 'auto');
assertTrue(testCase, isa(wlUnit, 'WaveUnit'));
assertTrue(testCase, strcmp(wlUnit.dimension, 'length'));
% test skipping second unit
[x, u] = WaveUnit.frequency2wavelength(1, 'GHz');
assertTrue(testCase, strcmp(u.name, 'm'));
assertEqual(testCase, x, 0.3,'relTol', 0.01);
% test nonscalar input
x = repmat(magic(3),1,1,4);
y = WaveUnit.frequency2wavelength(x, 'GHz', 'm');
assertSize(testCase, y, size(x));
assertTrue(testCase, all(abs(y(:)-0.3./x(:))<1e-2));
end

%%
function test_wavelength2frequency(testCase)
c = testCase.TestData.speedOfLight;
assertEqual(testCase, ...
  WaveUnit.wavelength2frequency(1000, 'nm', 'PHz'), c*1e-9,'RelTol',testCase.TestData.reltol);
assertEqual(testCase, ...
  WaveUnit.wavelength2frequency(3, 'm', 'Hz'), c/3,'RelTol',testCase.TestData.reltol);
assertEqual(testCase, ...
  WaveUnit.wavelength2frequency(Inf, 'm', 'Hz'), 0);
assertTrue(testCase, isinf(WaveUnit.wavelength2frequency(0, 'm', 'Hz')));
[~, freqUnit] = WaveUnit.wavelength2frequency(1, 'um', 'auto');
assertTrue(testCase, isa(freqUnit, 'WaveUnit'));
assertTrue(testCase, strcmp(freqUnit.dimension, 'frequency'));
% test skipping second unit
[x, u] = WaveUnit.wavelength2frequency(3e8, 'm');
assertTrue(testCase, strcmp(u.name, 'Hz'));
assertEqual(testCase, x, 1,'relTol', 0.01);
% test nonscalar input
x = repmat(magic(3),1,1,4);
y = WaveUnit.wavelength2frequency(x, 'm', 'GHz');
assertSize(testCase, y, size(x));
assertTrue(testCase, all(abs(y(:)-0.3./x(:))<1e-2));
end

%%
function test_frequency2energy(testCase)
h = testCase.TestData.PlanckConstant;
assertEqual(testCase, WaveUnit.frequency2energy(1,'PHz', 'eV'), h*1e15, ...
  'RelTol', testCase.TestData.reltol);
assertEqual(testCase, WaveUnit.frequency2energy(0,'Hz','eV'), 0);
[~, enUnit] = WaveUnit.frequency2energy(3.2, 'kHz', 'auto');
assertTrue(testCase, isa(enUnit, 'WaveUnit'));
assertTrue(testCase, strcmp(enUnit.dimension, 'energy'));
% test skipping second unit
[x, u] = WaveUnit.frequency2energy(375, 'THz');
assertTrue(testCase, strcmp(u.name, 'eV'));
assertEqual(testCase, x, 1.55,'relTol', 0.01);
% test nonscalar input
x = repmat(magic(3),1,1,4);
y = WaveUnit.frequency2energy(x, 'Hz', 'eV');
assertSize(testCase, y, size(x));
assertTrue(testCase, all(abs(y(:)-h*x(:))<testCase.TestData.abstol));
end
%%
function test_energy2frequency(testCase)
h = testCase.TestData.PlanckConstant;
assertEqual(testCase, WaveUnit.energy2frequency(2.3,'eV', 'Hz'), 2.3/h, ...
  'RelTol', testCase.TestData.reltol);
assertEqual(testCase, WaveUnit.energy2frequency(0,'MeV','kHz'), 0);
[~, enUnit] = WaveUnit.energy2frequency(3.2e1, 'meV', 'auto');
assertTrue(testCase, isa(enUnit, 'WaveUnit'));
assertTrue(testCase, strcmp(enUnit.dimension, 'frequency'));
% test skipping second unit
[x, u] = WaveUnit.energy2frequency(1.55, 'eV');
assertTrue(testCase, strcmp(u.name, 'Hz'));
assertEqual(testCase, x, 3.75e14,'relTol', 0.01);
% test nonscalar input
x = repmat(magic(3),1,1,4);
y = WaveUnit.energy2frequency(x, 'eV', 'Hz');
assertSize(testCase, y, size(x));
assertTrue(testCase, all(abs(y(:)-x(:)/h)<testCase.TestData.abstol));
end

%%
function test_wavelength2energy(testCase)
c = testCase.TestData.speedOfLight;
h = testCase.TestData.PlanckConstant;
assertEqual(testCase, WaveUnit.wavelength2energy(800, 'nm', 'eV'), 1.55, 'RelTol', 1e-2);
assertEqual(testCase, WaveUnit.wavelength2energy(800, 'nm', 'eV'), c*h/8e-7, ...
  'RelTol', testCase.TestData.reltol);
[~, enUnit] = WaveUnit.wavelength2energy(3.2e1, 'm', 'auto');
assertTrue(testCase, isa(enUnit, 'WaveUnit'));
assertTrue(testCase, strcmp(enUnit.dimension, 'energy'));
% test skipping second unit
[x, u] = WaveUnit.wavelength2energy(800, 'nm');
assertTrue(testCase, strcmp(u.name, 'eV'));
assertEqual(testCase, x, 1.55, 'relTol', 0.01);
% test nonscalar input
x = repmat(magic(3),1,1,4);
y = WaveUnit.wavelength2energy(x, 'm', 'eV');
assertSize(testCase, y, size(x));
assertTrue(testCase, all(abs(y(:)-c*h./x(:))<testCase.TestData.abstol));
end

%%
function test_energy2wavelength(testCase)
c = testCase.TestData.speedOfLight;
h = testCase.TestData.PlanckConstant;
assertEqual(testCase, WaveUnit.energy2wavelength(1.55, 'eV', 'um'), 0.8, 'RelTol', 1e-2);
assertEqual(testCase, WaveUnit.energy2wavelength(1.55, 'eV', 'm'), c*h/1.55, ...
  'RelTol', testCase.TestData.reltol);
[~, wlUnit] = WaveUnit.energy2wavelength(3.2e4, 'eV', 'auto');
assertTrue(testCase, isa(wlUnit, 'WaveUnit'));
assertTrue(testCase, strcmp(wlUnit.dimension, 'length'));
% test skipping second unit
[x, u] = WaveUnit.energy2wavelength(1.55, 'eV');
assertTrue(testCase, strcmp(u.name, 'm'));
assertEqual(testCase, x, 8e-7,'relTol', 0.01);
% test nonscalar input
x = repmat(magic(3),1,1,4);
y = WaveUnit.energy2wavelength(x, 'eV', 'm');
assertSize(testCase, y, size(x));
assertTrue(testCase, all(abs(y(:)-c*h./x(:))<testCase.TestData.abstol));
end
%%
function test_optimize(testCase)
dimensions = testCase.TestData.dimensions;
baseunits = testCase.TestData.baseunits;
assert(numel(dimensions) == numel(baseunits), ...
  'testsuite have wrong dimensions or baseunits data');
for n = 1:numel(baseunits)
  value = rand(5,5,3).*10.^randi([-24,24],5,5,3); %test multimensional arrays
  unit = ['M',baseunits{n}];
  [~, newUnit] = WaveUnit.optimize(value, unit);
  assertTrue(testCase, strcmp(newUnit.baseUnit, baseunits{n}));
  assertTrue(testCase, strcmp(newUnit.dimension, dimensions{n}));
end
for n = 1:numel(baseunits)
  value = rand*10^randi([-24,24]);
  unit = ['n',baseunits{n}];
  [~, newUnit] = WaveUnit.optimize(value, unit);
  assertTrue(testCase, strcmp(newUnit.baseUnit, baseunits{n}));
  assertTrue(testCase, strcmp(newUnit.dimension, dimensions{n}));
end
end

%%
function setupOnce(testCase)
testCase.TestData.electronCharge = 1.602176620898e-19; % Coulomb
testCase.TestData.speedOfLight = 2.99792458e8; % m/s
testCase.TestData.PlanckConstant = 4.13566766225e-15; % eV * s
testCase.TestData.prefixes = ...
  {'y','z','a','f','p','n','u','m','','k','M','G','T','P','E','Z','Y'};
testCase.TestData.baseunits = {'m', 's', 'Hz', 'eV', 'J'};
testCase.TestData.dimensions = ...
  {'length', 'time', 'frequency', 'energy', 'energy'};
% set relative tolerance for equality comparison
testCase.TestData.reltol = 1e-6;
testCase.TestData.abstol = 1e-6;
end
