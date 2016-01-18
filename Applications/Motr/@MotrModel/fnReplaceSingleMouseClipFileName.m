function err = fnReplaceSingleMouseClipFileName(self, clipIndex, newAbsoluteFileNameOfClip)

% This is used, for instance, when the clip file has been moved, bu the
% user has located the new one for us.  This doesn't change the training
% status at all.

% Get the experiment info out of the model
originalListOfAbsoluteFileNamesForEachClip = self.clipSMFNAbs ;

% Change the file name for the indicated clip
newListOfAbsoluteFileNamesForEachClip = originalListOfAbsoluteFileNamesForEachClip ;
newListOfAbsoluteFileNamesForEachClip{clipIndex} = newAbsoluteFileNameOfClip ;

% Save the new info into the clipFN.mat file
err = MotrModel.saveClipFN(self.expDirName, self.clipFNAbs, newListOfAbsoluteFileNamesForEachClip, self.getParameterFileNameAbs() ) ;

% Commit the new clip file name only if writing to the clipFN.mat file
% worked
if isempty(err)
    % Save the new info into the model
    self.clipSMFNAbs = newListOfAbsoluteFileNamesForEachClip ;
end

% Now update the GUI to reflect the status
self.changed() ;

end
