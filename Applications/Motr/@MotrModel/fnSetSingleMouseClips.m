function fnSetSingleMouseClips(self, clipSMFNAbs)
% Makes the clip names in the cell array of strings clipSMFNAbs to be the
% single-mouse clip names for the experiment, updates the main window as
% needed.

% get model
expDirName = self.expDirName ;

% make clipSMFN a col vector
if size(clipSMFNAbs,1)==1 && size(clipSMFNAbs,2)>1
    clipSMFNAbs=clipSMFNAbs';
end

% set current SM clip
iClipSMCurr=1;

% figure out the new training status
trainStatus=MotrModel.determineTrainStatus(expDirName,clipSMFNAbs);

% write stuff to the userdata
self.clipSMFNAbs=clipSMFNAbs;
self.iClipSMCurr=iClipSMCurr;
self.trainStatus=trainStatus;
%set(hFig,'userdata',u);

% update the clipFN.mat
MotrModel.saveClipFN(expDirName,self.clipFNAbs,clipSMFNAbs,self.getParameterFileNameAbs())

% now update the GUI to reflect the status
%fnUpdateGUIStatus(self);
self.changed();

end
