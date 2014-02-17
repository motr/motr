function fnCreateJob(strMovieFileName, ~, ...
                     aiFrameInterval, strctBootstrap, strAdditionalInfoFile,...
                     strOutputFile, iUID, ...
                     strJobInputFileName,bLearnIdentity)

global g_strctGlobalParam g_iLogLevel g_bMouseHouse  %#ok
   
if exist('bLearnIdentity','var') && bLearnIdentity==true
   strctJob.m_sFunction = 'fnLearnMouseIdentity';
else
   bLearnIdentity = false;
   strctJob.m_sFunction = 'fnMainFrameLoop';
end;

strctJob.m_strMovieFileName = strMovieFileName;
strctJob.m_aiFrameInterval = aiFrameInterval;
strctJob.m_strctBootstrap = strctBootstrap;
strctJob.m_strAdditionalInfoFile = strAdditionalInfoFile;
strctJob.m_strOutputFile = strOutputFile;
strctJob.m_iUID = iUID;
strctJob.m_bLearnIdentity = bLearnIdentity;  %#ok
strPath=fileparts(strJobInputFileName);
if ~exist(strPath,'dir')
    mkdir(strPath);
end;
if ~fnGetLogMode(1)
   g_iLogLevel = 0;
   save(strJobInputFileName, 'strctJob','g_strctGlobalParam','g_iLogLevel','g_bMouseHouse');
else
   global g_CaptainsLogDir  %#ok
   save(strJobInputFileName, 'strctJob','g_strctGlobalParam','g_iLogLevel','g_bMouseHouse','g_CaptainsLogDir');
end
return
