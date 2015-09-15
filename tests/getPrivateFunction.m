function privFunc = getPrivateFunction(privateDir, funcName)
  oldDir = cd(privateDir);         % go to the private directory
  privFunc = str2func(funcName);   % get the private function handle
  cd(oldDir);                      % go back to the original directory
end