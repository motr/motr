function fnDeleteClip(self, iClip)

% Get the experiment info out of the figure.
%model=get(self,'userdata');
expDirName=self.expDirName;
clipFNAbs=self.clipFNAbs;
iClipCurr=self.iClipCurr;
trackStatus=self.trackStatus;

% Want to know how many clips before deletion
nClipBefore=length(clipFNAbs);

% get rid of the inidicated clip in clipFN, trackStatus
clipFNAbs(iClip)=[];
trackStatus(iClip)=[];

% update iClipCurr
if nClipBefore==1
  iClipCurr=-1;  % no clips left
elseif iClipCurr==nClipBefore
  iClipCurr=iClipCurr-1;
end

% Save the new info into the userdata.
self.clipFNAbs=clipFNAbs;
self.trackStatus=trackStatus;
self.iClipCurr=iClipCurr;
%set(hFig,'userdata',u);

% Save the new info into the clipFN file
MotrModel.saveClipFN(expDirName,clipFNAbs,self.clipSMFNAbs,self.getParameterFileNameAbs()) ;

% now update the GUI to reflect the status
%fnUpdateGUIStatus(self);
self.changed();

end
