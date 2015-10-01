function setCurrentExperiment(self, expDirName)

% % Get relevant info out of the handles structure
% exp=handles.exp;
% iExpCurr=handles.iExpCurr;
% iClipCurr=handles.iClipCurr;
% iClipSMCurr=handles.iClipSMCurr;
% trainStatus=handles.trainStatus;
% trackStatus=handles.trackStatus;

% is there a clipFN.mat file?  If so, try to load it.
fileName=fullfile(expDirName,'clipFN.mat');
if exist(fileName,'file')
    % if clipFN.mat exists, try to load it
    try
        [clipFNAbs,clipSMFNAbs,parameterFileNameAbs]=MotrModel.loadClipFN(fileName,expDirName);
        loadedClipFN=true;
    catch excp
        if strcmp(excp.identifier,'loadClipFN:wrongFormat')
            loadedClipFN=false;
            buttonLabel=...
                questdlg(['There is a clipFN.mat file in the directory, but ' ...
                          'it is in an unknown format.  ' ...
                          'Overwrite it and proceed?'], ...
                         'Unknown format', ...
                         'Overwrite and proceed','Cancel', ...
                         'Overwrite and proceed');
            if strcmp(buttonLabel,'Overwrite and proceed')
                % Delete the clipFN.mat file---a new one will likely be
                % written soon.
                delete(fileName);
            else
                return;
            end
        else
            rethrow(excp);
        end
    end
else
    loadedClipFN=false;
    clipFNAbs=[] ;
    clipSMFNAbs=[];
    parameterFileNameAbs=[];
end

% set the current experiment in the model
model = self.model_ ;
model.setCurrentExperiment(expDirName, loadedClipFN, clipFNAbs, clipSMFNAbs, parameterFileNameAbs) ;

end
