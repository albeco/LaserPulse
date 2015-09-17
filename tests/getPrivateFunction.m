function privFunc = getPrivateFunction(privateDir, funcName)
% GETPRIVATEFUNCTION returns a handle to a function given as string.
%
% It allows to use functions which are not be accessible from the current
% scope, like for example functions stored in 'private' folders.

% 2015 Alberto Comin, LMU Muenchen

oldDir = cd(privateDir);         % go to the private directory
privFunc = str2func(funcName);   % get the private function handle
cd(oldDir);                      % go back to the original directory
end