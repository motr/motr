function buildClusterExecutable()

% figure out where the root of the Ohayon code is
thisScriptFileName=mfilename('fullpath');
thisScriptDirName=fileparts(thisScriptFileName);
thisScriptDirParts=split_on_filesep(thisScriptDirName);
  % a cell array with each dir an element
mouseStuffRootParts=thisScriptDirParts(1:end-2);
g_strMouseStuffRootDirName=combine_with_filesep(mouseStuffRootParts);

% determine the current architecture
archStr=computer('arch');                

% Compile matlab script
exeDirName= ...
  fullfile(g_strMouseStuffRootDirName,'Deploy','MouseTrackProj','src');
if ~exist(exeDirName,'dir')
  mkdir(exeDirName);
end

% % Do not use mcc directly. This will occupy a matlab license and will not 
% % release it until the user closes matlab! (SO, 16 Oct 2011)
% % Just to be clear---it will occupy a license for the Matlab Compiler
% % Toolbox, which won't be released until the user closes Matlab. 
% % Note: In order for this to work, mcc must be on the user's path
% % (ALT, 19 Oct 2011)
% prjFN=fullfile(g_strMouseStuffRootDirName,'Deploy','MouseTrackProj.prj');
% %cmdLine=sprintf('mcc -F %s',prjFN);
% cmdLine=sprintf('deploytool -build %s',prjFN);
% system(cmdLine);
% % system(['mcc -nocache -m -v -g -d ./Deploy/MouseTrackProj/src -o MouseTrackProj -C ' ...
% %         '-R -nodisplay ' ...
% %         './Modules/Jobs/fnJobAlgorithm.m ' ...
% %         '-a ./Modules/MEX/linux64/fnEM.mexa64 ' ...
% %         '-a ./Modules/MEX/linux64/fndllViterbi.mexa64 ' ...
% %         '-a ./Modules/MEX/linux64/fnFastInterp2.mexa64 ' ...
% %         '-a ./Modules/MEX/linux64/fnLabelsHist.mexa64 ' ...
% %         '-a ./Modules/MEX/linux64/fnSelectLabels.mexa64 ' ...
% %         '-a ./Modules/MEX/linux64/parsejpg8.mexa64 ' ...
% %         '-a ./Modules/MEX/linux64/fnHOGfeatures.mexa64 ' ...
% %         '-a ./Modules/MEX/linux64/fnViterbiLikelihoodForHeadTail.mexa64 ']);

% deal with nodisplay-like functionality in a platform agnostic way
if isunix()
  strNoDisplaySwitch='-R -nodisplay ';
elseif ispc()
  strNoDisplaySwitch='-R -noFigureWindows ';
end

% Invoke mcc to compile the MouseTrackProj executable.
cmdLine= ...
  sprintf(['mcc -o MouseTrackProj -W main:MouseTrackProj -T link:exe ' ...
                '-d "%s" ' ....
                '-C ' ...
                '-w enable:specified_file_mismatch ' ...
                '-w enable:repeated_file ' ...
                '-w enable:switch_ignored ' ...
                '-w enable:missing_lib_sentinel ' ...
                '-w enable:demo_license ' ...
                '-v ' ...
                strNoDisplaySwitch ...
                '-R -singleCompThread ' ...
                '-R -nojvm ' ...
                '-I "%s/Applications" ' ...
                '-I "%s/Applications/MouseHouseGUI" ' ...
                '-I "%s/Applications/MouseHouseGUI/PostProcess" ' ...
                '-I "%s/Applications/Repository" ' ...
                '-I "%s/Config" ' ...
                '-I "%s/Documentation" ' ...
                '-I "%s/ExtraModules" ' ...
                '-I "%s/ExtraModules/AnnotationGUI" ' ...
                '-I "%s/ExtraModules/BackgroundDiffGUI" ' ...
                '-I "%s/ExtraModules/BehaviorAnalysis" ' ...
                '-I "%s/ExtraModules/CompareFunctions" ' ...
                '-I "%s/ExtraModules/DebuggingUtilities" ' ...
                '-I "%s/ExtraModules/GroundTruthGUI" ' ...
                '-I "%s/ExtraModules/PerformanceAnalysis" ' ...
                '-I "%s/ExtraModules/UtilityScripts" ' ...
                '-I "%s/ExtraModules/gentleBoost" ' ...
                '-I "%s/Modules" ' ...
                '-I "%s/Modules/Classifiers" ' ...
                '-I "%s/Modules/Core" ' ...
                '-I "%s/Modules/ReliableFramesGUI" ' ...
                '-I "%s/Modules/ResultsEditor" ' ...
                '-I "%s/Modules/TuneSegmentation" ' ...
                '-I "%s/Modules/VideoWrapper" ' ...
                '-I "%s/Modules/Viterbi" ' ...
                '-I "%s/Modules/XML" ' ...
                '"%s/Modules/Jobs/fnJobAlgorithm.m" ' ...
                '-a "%s/Modules/MEX/%s/fndllViterbi.%s" ' ...
                '-a "%s/Modules/MEX/%s/fnEM.%s" ' ...
                '-a "%s/Modules/MEX/%s/fnFastInterp2.%s" ' ...
                '-a "%s/Modules/MEX/%s/fnHOGfeatures.%s" ' ...
                '-a "%s/Modules/MEX/%s/fnLabelsHist.%s" ' ...
                '-a "%s/Modules/MEX/%s/fnSelectLabels.%s" ' ...
                '-a "%s/Modules/MEX/%s/fnViterbiLikelihoodForHeadTail.%s" ' ...
                '-a "%s/Modules/MEX/%s/parsejpg8.%s" '], ...
          exeDirName, ...
          g_strMouseStuffRootDirName, ...
          g_strMouseStuffRootDirName, ...
          g_strMouseStuffRootDirName, ...
          g_strMouseStuffRootDirName, ...
          g_strMouseStuffRootDirName, ...
          g_strMouseStuffRootDirName, ...
          g_strMouseStuffRootDirName, ...
          g_strMouseStuffRootDirName, ...
          g_strMouseStuffRootDirName, ...
          g_strMouseStuffRootDirName, ...
          g_strMouseStuffRootDirName, ...
          g_strMouseStuffRootDirName, ...
          g_strMouseStuffRootDirName, ...
          g_strMouseStuffRootDirName, ...
          g_strMouseStuffRootDirName, ...
          g_strMouseStuffRootDirName, ...
          g_strMouseStuffRootDirName, ...
          g_strMouseStuffRootDirName, ...
          g_strMouseStuffRootDirName, ...
          g_strMouseStuffRootDirName, ...
          g_strMouseStuffRootDirName, ...
          g_strMouseStuffRootDirName, ...
          g_strMouseStuffRootDirName, ...
          g_strMouseStuffRootDirName, ...
          g_strMouseStuffRootDirName, ...
          g_strMouseStuffRootDirName, ...
          g_strMouseStuffRootDirName, archStr, mexext(), ...
          g_strMouseStuffRootDirName, archStr, mexext(), ...
          g_strMouseStuffRootDirName, archStr, mexext(), ...
          g_strMouseStuffRootDirName, archStr, mexext(), ...
          g_strMouseStuffRootDirName, archStr, mexext(), ...
          g_strMouseStuffRootDirName, archStr, mexext(), ...
          g_strMouseStuffRootDirName, archStr, mexext(), ...
          g_strMouseStuffRootDirName, archStr, mexext() );
system(cmdLine);

% converted this to using system(), rather than eval('![...]')
exeFN=fullfile(exeDirName,'MouseTrackProj');
system(exeFN);

end