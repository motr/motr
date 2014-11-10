function buildCatalyticExecutable()

% Check that compilation has been done, do it if not
% Use parsejpg8 as the canary in the coalmine
if ~isParsejpg8MexFilePresent()
  compileMexFunctions();
end

% figure out where the root of the Ohayon code is
thisScriptFileName=mfilename('fullpath');
thisScriptDirName=fileparts(fileparts(thisScriptFileName));
%mouseStuffRootDirName=thisScriptDirName;

% % determine the current architecture
% archStr=computer('arch');                

% Compile matlab script
exeDirName=fullfile(thisScriptDirName,'Deploy');
if ~exist(exeDirName,'dir')
  mkdir(exeDirName);
end

% Invoke mcc to compile the catalytic executable.
cmdLine= ...
  sprintf(['mcc -m -v -o catalytic ' ...
           '-d %s ' ...
           'catalytic ' ...
           ], ...
           exeDirName);
eval(cmdLine);

end
