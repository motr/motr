function fnAddClips(self, clipFNAbsNew, bAppend)

% Get the experiment info out of the figure.
expDirName=self.expDirName;
clipFNAbs=self.clipFNAbs;
iClipCurr=self.iClipCurr;
trackStatus=self.trackStatus;

% figure out the tracking status of the new clips
nClipNew=length(clipFNAbsNew);
trackStatusNew=zeros(nClipNew,1);
for i=1:nClipNew
  trackStatusNew(i)=MotrModel.determineTrackStatus(expDirName,clipFNAbsNew{i});
end

% update the clips, depending on bAppend
if bAppend
  clipFNAbs = [clipFNAbs;clipFNAbsNew];
  trackStatus=[trackStatus;trackStatusNew];
else
  clipFNAbs = clipFNAbsNew;
  trackStatus=trackStatusNew;
  iClipCurr=1;
end

% Save the new info into the userdata.
self.clipFNAbs=clipFNAbs;
self.trackStatus=trackStatus;
self.iClipCurr=iClipCurr;
%set(hFig,'userdata',u);

% Save the new info into the clipFN file
MotrModel.saveClipFN(expDirName,clipFNAbs,self.clipSMFNAbs, self.getParameterFileNameAbs() ) ;

% now update the GUI to reflect the status
%fnUpdateGUIStatus(self);
self.changed();

end
