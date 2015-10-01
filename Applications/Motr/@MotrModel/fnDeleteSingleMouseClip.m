function fnDeleteSingleMouseClip(self, iClipSM)

% Get the experiment info out of the figure.
%self=get(ui,'userdata');
expDirName=self.expDirName;
clipSMFNAbs=self.clipSMFNAbs;
iClipSMCurr=self.iClipSMCurr;
trainStatus=self.trainStatus;

% Want to know how many clips before deletion
nClipSMBefore=length(clipSMFNAbs);

% get rid of the inidicated clip in clipSMFN
clipSMFNAbs(iClipSM)=[];

% update iClipSMCurr
if nClipSMBefore==1
  iClipSMCurr=-1;  % no clips left
elseif iClipSMCurr==nClipSMBefore
  iClipSMCurr=iClipSMCurr-1;
end

% Change the training status, if needed
if nClipSMBefore==1
  trainStatus=1;
end

% Save the new info into the userdata.
self.clipSMFNAbs=clipSMFNAbs;
self.trainStatus=trainStatus;
self.iClipSMCurr=iClipSMCurr;
%set(hFig,'userdata',u);

% Save the new info into the clipFN file
MotrModel.saveClipFN(expDirName,self.clipFNAbs,clipSMFNAbs,self.getParameterFileNameAbs());

% now update the GUI to reflect the status
%fnUpdateGUIStatus(ui);
self.changed() ;

end
