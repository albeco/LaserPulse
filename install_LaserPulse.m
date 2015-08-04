function install_LaserPulse()
%INSTALL_LASERPULSE_MANUAL install documentation for the LaserPulse class

%% adding LaserPulse folder to search path
wantsSearchPath = questdlg('Would you like to add the LaserPulse folder to matlab search path?', ...
  'Adding Folders to Search Path');
if strcmp(wantsSearchPath, 'Yes')
  disp('Adding LaserPulse folders to search path...')
  currentDir = pwd;
  addpath(currentDir);
  addpath(fullfile(currentDir,'utilities'));
  addpath(fullfile(currentDir,'examples'));
  disp('Saving updated search folder..')
  savepath;
end
%% install manual in html format
wantsManual = questdlg('Would you like to install the manual for the LaserPulse class?', ...
  'Installing Manual');
if strcmp(wantsManual, 'Yes')
  disp('Installing LaserPulse manual.')
  installManual();
end

%% install example files in html format
wantsManual = questdlg('Would you like to install the documentation for the example files?', ...
  'Installing Examples');
if strcmp(wantsManual, 'Yes')
  disp('Installing examples files documentation.');
  installExamples();
end

end

function installManual()
% publish the html manual

% create manual folder if it does not exist
manualFolder = fullfile('.','manual');
if ~exist(manualFolder,'dir')
  mkdir(manualFolder);
end
% go to manual source folder
cd 'manual_source';
% set destination folder
publishOptions = struct('outputDir', fullfile('..', manualFolder));
%  get file names
files = dir( fullfile('.', '*.m' ) );
%  loop over files and publish them
for n = 1 : numel( files )
  publish(files(n).name, publishOptions);
end
% go back to main folder
cd ..
end

function installExamples()
% publish the example files in html format

% create example doc folder if it does not exist
exampleDocFolder = fullfile('.','manual','example_files');
if ~exist(exampleDocFolder,'dir')
  mkdir(exampleDocFolder);
end
% go to manual source folder
cd 'examples';
% set destination folder
publishOptions = struct('outputDir', fullfile('..', exampleDocFolder));
%  get file names
files = dir( fullfile('.', '*.m' ) );
%  loop over files and publish them
for n = 1 : numel( files )
  publish(files(n).name, publishOptions);
end
% go back to main folder
cd ..
end