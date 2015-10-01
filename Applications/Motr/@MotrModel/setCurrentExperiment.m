function setCurrentExperiment(self, expDirName, loadedClipFN, clipFNAbs, clipSMFNAbs, parameterFileNameAbs)

% % Get relevant info out of the handles structure
% exp=handles.exp;
% iExpCurr=handles.iExpCurr;
% iClipCurr=handles.iClipCurr;
% iClipSMCurr=handles.iClipSMCurr;
% trainStatus=handles.trainStatus;
% trackStatus=handles.trackStatus;

% If we loaded clipFN.mat successfully, determine statuses
if loadedClipFN ,
    % init iClipCurr
    nClip=length(clipFNAbs);
    if nClip>0
        iClipCurr=1;
    else
        iClipCurr=-1;
    end
    % init iClipSMCurr
    nClipSM=length(clipSMFNAbs);
    if nClipSM>0
        iClipSMCurr=1;
    else
        iClipSMCurr=-1;
    end
    trainStatus=MotrModel.determineTrainStatus(expDirName,clipSMFNAbs);
    nClip=length(clipFNAbs);
    trackStatus=zeros(nClip,1);
    for j=1:nClip
        trackStatus(j)=MotrModel.determineTrackStatus(expDirName,clipFNAbs{j});
    end    
else
    % if no clipFN.mat, init to defaults
    clipFNAbs=cell(0,1);
    clipSMFNAbs=cell(0,1);
    iClipCurr=-1;
    iClipSMCurr=-1;
    trainStatus=1;
    trackStatus=zeros(0,1);
    parameterFileNameAbs = defaultParameterFileNameAbs() ;
end

% load the parameter file
global g_strctGlobalParam
g_strctGlobalParam = fnLoadAlgorithmsConfigXML(parameterFileNameAbs) ;

% save to the userdata
self.expSelected=true;
self.expDirName=expDirName;
self.clipFNAbs=clipFNAbs;
self.clipSMFNAbs=clipSMFNAbs;
self.iClipCurr=iClipCurr;
self.iClipSMCurr=iClipSMCurr;
self.trainStatus=trainStatus; 
self.trackStatus=trackStatus; 
self.parameterFileNameAbs_ = parameterFileNameAbs ;

% notify dependents that self has changed
self.changed() ;
%fnUpdateGUIStatus(self);

end
