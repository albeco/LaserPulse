function efield = subsref(pulse, ref)
%SUBSREF interpolates the electric field of a LaserPulse
% it can give the field in either time or frequency domain, depending of the
% setting of the 'activeDomain' property.
%
% USAGE:
% t = -10 : 0.01 : 10;
% p = LaserPulse('fs', t, exp(-t.^2/4))
% % real component of temporal field
% p.activeDomain = 'time';
% ti = -5:0.1:5;
% figure; plot(p.timeArray, real(p.temporalField), '-', ti, real(p(ti)), '--')
%
% % real component of spectral field
% p.activeDomain = 'frequency';
% fi = -1:0.1:1;
% figure; plot(p.frequencyArray, real(p.spectralField), '-', fi, real(p(fi)), '--')

% 2018 Alberto Comin

switch ref(1).type
  case '.'
    efield = pulse.(ref(1).subs);
    return
  case '{}'
    error('LaserPulse:subsref:argChk', 'unsupported {} indexing');
  case '()'
    if strcmp(pulse.activeDomain, 'time')
        efield = interpolate(pulse.timeArray, pulse.temporalField, ...
          ref(1).subs{1});
    else
        efield = interpolate(pulse.frequencyArray, pulse.spectralField, ...
          ref(1).subs{1});
    end
    if length(ref(1).subs) > 1
      efield = efield(:, ref(1).subs{2:end});
    end
end

if length(ref) > 1
  efield = subsref(efield, ref(2:end));
end

end

function yi = interpolate(x, y, xi)
  if xi == ':'
    yi = y;
  else
    yi = interp1(x, y, xi, 'linear', nan);
  end
end

