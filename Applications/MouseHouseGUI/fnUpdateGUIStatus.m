function fnUpdateGUIStatus(hFig)

% get the handles
handles=guidata(hFig);

% get the userdata from the GUI
u=get(hFig,'userdata');

% Get relevant info out of the u structure
expSelected=u.expSelected;
%expDirName=u.expDirName;

% get the number of experiments

% update the listbox of experiment names
if expSelected
    expDirName=u.expDirName;
    listItem={'--- Select a New Experiment ---' expDirName}';
else
    listItem={'--- Select a New Experiment ---'};
end
if expSelected
    iCurrListItem=2;
else
    iCurrListItem=1;
end    
set(handles.hChooseExp, 'String', listItem);
set(handles.hChooseExp, 'Value', iCurrListItem);

% unpack u, if there's an experiment
if expSelected
    % get stuff out of u
    clipFNAbs=u.clipFNAbs;
    clipSMFNAbs=u.clipSMFNAbs;
    iClipCurr=u.iClipCurr;
    iClipSMCurr=u.iClipSMCurr;
    trainStatus=u.trainStatus;
    trackStatus=u.trackStatus;
else
    % if no experiments, set things to default values and exit
    set(handles.hSingleMouseListbox, 'Value', 1);
    set(handles.hSingleMouseListbox, 'String', {''});
    set(handles.hExperimentClipsListbox, 'Value', 1);
    set(handles.hExperimentClipsListbox, 'String', {''});
    C = fnGetColorCode();
    set(handles.hTrain, 'BackgroundColor', C(1,:));
    set(handles.hTrack, 'BackgroundColor', C(1,:));
    return;
end    

% update the single-mouse clips
set(handles.hSingleMouseListbox, 'String', clipSMFNAbs);
set(handles.hSingleMouseListbox, 'Value', iClipSMCurr);

% generate the clip listbox items by coloring the clip names
% appropriately
clipListString=colorizeClips(clipFNAbs,trackStatus,iClipCurr);

% update the clip listbox
set(handles.hExperimentClipsListbox, 'String', clipListString);
set(handles.hExperimentClipsListbox, 'Value', iClipCurr);

% update the enablement of the Results button
if length(clipFNAbs)>0 && trackStatus(iClipCurr)==4  %#ok
    set(handles.hResults, 'Enable', 'on');
else
    set(handles.hResults, 'Enable', 'off');
end

% get the color code
C = fnGetColorCode();

% update the training button color
set(handles.hTrain, 'BackgroundColor', C(trainStatus,:));

% update the tracking button color
if isempty(clipFNAbs)
    trackStatusOverall=1;
else
    trackStatusOverall=max(trackStatus);
end
set(handles.hTrack, 'BackgroundColor', ...
                    C(trackStatusOverall,:));

end
