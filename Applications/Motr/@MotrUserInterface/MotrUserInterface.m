classdef MotrUserInterface < handle
    
    properties (Dependent=true)
        UserData  % alias for model, for backwards-compatibility
        userdata  % alias for model, for backwards-compatibility
        handles  % alias for self, for backwards-compatibility
        pointer  % for backwards-compatibility
    end
    
    properties  % protected in spirit, hence the underscore, but making them truly protected is annoying
        model_
        
        figureGH_
        operationsPanel_
        trainButton_
        trackButton_
        resultsButton_
        experimentPanel_
        singleMouseClipsListbox_
        singleMouseClipsLabelText_
        experimentClipsListbox_
        experimentClipsLabelText_
        chooseExperimentButton_
        experimentNameText_
        processingModeButtonGroup_
        clusterModeRadiobutton_
        localModeRadiobutton_
    end
    
    methods
        function self=MotrUserInterface()
            %fprintf('MotrUserInterface::MotrUserInterface()\n');
            
            global g_strctGlobalParam g_bMouseHouse g_bVERBOSE g_iLogLevel;
            global g_CaptainsLogDir g_logImIndex;
            
            g_bMouseHouse = true;
            g_bVERBOSE = false;
            g_iLogLevel = 0;
            % SO Feb 08 2012 : Adam, I prefer not to change the current directory during a matlab session. But in any case, please keep the variable convensions. 
            %                  If you use global variables, add a "g_" prefix to them.
            % Want to store a global that contains the root directory for
            % all the Ohayons code---this allows us to be independent of what
            % the current working directory is.
            global g_strMouseStuffRootDirName;
            thisFileName=mfilename('fullpath');
            thisDirName=fileparts(thisFileName);
            thisDirParts=split_on_filesep(thisDirName);
              % a cell array with each dir an element
            mouseStuffRootParts=thisDirParts(1:end-3);
            g_strMouseStuffRootDirName=combine_with_filesep(mouseStuffRootParts);

            if g_iLogLevel > 0
               g_logImIndex = 0;
               ts = num2str(fix(clock)); ts(findstr(ts,' ')) = [];  %#ok<FSTR>
               g_CaptainsLogDir = ['Logs/Log' ts];
               mkdir(g_CaptainsLogDir);
               sLogFile = fullfile(g_CaptainsLogDir, 'logFile.txt');
               fid = fopen(sLogFile, 'w');
               fclose(fid);
            else
               clear global g_CaptainsLogDir g_logImIndex;
            end

            %dbstop if error;

            % Choose default command line output for MouseHouse
            %self.output = hObject;

            % set handles.expDirName, handles.iExpCurr, handles.expCurr,
            % handles.iSingleMouseClipCurr, handles.trainingStatusCodeExpCurr,
            % handles.iClipCurr, handles.trackingStatusCodeExpCurr, as
            % appropriate
            %initGUIExpInfo(hObject,handles);
            %initUserData(hObject);

            %fnUpdateStatus(handles);
            %fnUpdateStatusMinimal(handles);
            %fnUpdateGUIStatus(hObject);
            %updateLocalClusterRadiobuttons(hObject);
            %updateEnablementOfLocalClusterRadiobuttons(hObject);

            % Load various algorithm parameters from the XML file
            g_strctGlobalParam = ...
                fnLoadAlgorithmsConfigXML(fullfile(g_strMouseStuffRootDirName, ...
                                                   'Config','Algorithms.xml'));
            % g_strctGlobalParam=fnLoadAlgorithmsConfigNative();
            %   % eliminate dependence on XML file.  Checked that these assign the same
            %   % value to g_strctGlobalParam.  ALT, 2012-01-09

            if exist('MouseTrackProj.prj','file')
               rmpath(genpath(fullfile(g_strMouseStuffRootDirName,'Deploy')));
            end

            % Update handles structure
            %guidata(hObject, self);
            
            % Create the figure, sync it to the model (which isn't set yet,
            % but that's ok
            self.createFigure_() ;
            self.update_() ;
        end
        
        function delete(self)
            %fprintf('MotrUserInterface::delete()\n');
            self.deleteFigure() ;
            if ~isempty(self.model_) && isvalid(self.model_) ,
                self.model_.unregisterUserInterface() ;
            end
            self.model_ = [] ;
        end
        
        function deleteFigure(self)
            % Calling this deletes the figure GH
            if ~isempty(self.figureGH_) && ishghandle(self.figureGH_) ,
                delete(self.figureGH_) ;
            end                
            self.figureGH_ = [] ;            
        end
        
        function result = get.UserData(self)
            result = self.model_ ;
        end
            
        function result = get.userdata(self)
            result = self.model_ ;
        end
            
        function result = get.handles(self)
            result = self ;
        end
            
        function createFigure_(self)
            screenSize = get(0,'ScreenSize') ;
            %screenWidth = screenSize(3) ;
            screenHeight = screenSize(4) ;
            
            figureWidth = 650 ;
            figureHeight = 344 ;
            figureX = 100 ;
            figureY = screenHeight - figureHeight - 22 - 100;  % 22 is the approx title bar width
            
            %figureNormedMultiplier = [figureWidth figureHeight figureWidth figureHeight]
            
            self.figureGH_ = figure(...
            'Units','pixels',...
            'Position',[figureX figureY figureWidth figureHeight],...
            'Visible','on',...
            'Color',get(0,'defaultfigureColor'),...
            'IntegerHandle','off',...
            'MenuBar','none',...
            'Name','Motr 1.04',...
            'NumberTitle','off',...
            'PaperPosition',get(0,'defaultfigurePaperPosition'),...
            'InvertHardcopy',get(0,'defaultfigureInvertHardcopy'),...
            'ScreenPixelsPerInchMode','manual',...
            'Tag','figure1',...
            'Resize','off', ...
            'CloseRequestFcn',@(source,event)(self.closeRequested()), ...
            'UserData',[]);
%            'HandleVisibility','callback',...

                        
            
            %
            % Operations panel
            %
            
            self.operationsPanel_ = uipanel(...
            'Parent',self.figureGH_,...
            'FontUnits',get(0,'defaultuipanelFontUnits'),...
            'Units','pixels',...
            'Title','Operations',...
            'Position',[10          144          122          183],...
            'Clipping','off',...
            'Tag','hOperations');

            %operationsPanelPosition = get(self.operationsPanel_,'Position') ;
            %operationsPanelWidth = operationsPanelPosition(3) ;
            %operationsPanelHeight = operationsPanelPosition(4) ;            
            %operationsPanelNormedMultiplier = [operationsPanelWidth operationsPanelHeight operationsPanelWidth operationsPanelHeight]
            
            self.trainButton_ = uicontrol(...
            'Parent',self.operationsPanel_,...
            'FontUnits',get(0,'defaultuicontrolFontUnits'),...
            'Units','pixels',...
            'String','Train',...
            'Position',[14           116          90          40],...
            'Callback',@(hObject,eventdata)(self.trainButtonActuated()),...
            'Children',[],...
            'Tag','hTrain',...
            'FontWeight','bold');
%            'Callback',@(hObject,eventdata)MouseHouse_export('hTrain_Callback',hObject,eventdata,guidata(hObject)),...

            self.trackButton_ = uicontrol(...
            'Parent',self.operationsPanel_,...
            'FontUnits',get(0,'defaultuicontrolFontUnits'),...
            'Units','pixels',...
            'String','Track',...
            'Position',[ 14          66          90          40],...
            'Callback',@(hObject,eventdata)(self.trackButtonActuated()),...
            'Children',[],...
            'Tag','hTrack',...
            'FontWeight','bold');
        
            self.resultsButton_ = uicontrol(...
            'Parent',self.operationsPanel_,...
            'FontUnits',get(0,'defaultuicontrolFontUnits'),...
            'Units','pixels',...
            'String','Results',...
            'Position',[14           16          90          40],...
            'Callback',@(hObject,eventdata)(self.hResults_Callback()),...
            'Children',[],...
            'Tag','hResults',...
            'FontWeight','bold');
            %'Callback',@(hObject,eventdata)MouseHouse_export('hResults_Callback',hObject,eventdata,guidata(hObject)),...

                        
            
            %
            % Experiment panel
            %
            
            self.experimentPanel_ = uipanel(...
            'Parent',self.figureGH_,...
            'FontUnits',get(0,'defaultuipanelFontUnits'),...
            'Units','pixels',...
            'Title','Experiment',...
            'Position',[148           10          492          320],...
            'Clipping','off',...
            'Tag','hExperiment');

            leftPadWidth = 18 ;
            experimentNameTextWidth = 374 ;
            experimentNameTextHeight = 20 ;
            chooseExperimentNameButtonWidth = 76 ;
            chooseExperimentNameButtonHeight = 24 ;            
            experimentContentWidth = 460 ;
            experimentClipsListboxWidth = experimentContentWidth ;
            experimentClipsListboxHeight = 100 ;
            singleMouseClipsListboxWidth = experimentContentWidth ;
            singleMouseClipsListboxHeight = 100 ;
            heightBetweenExperimentClipsAndSingleMouseClips = 10 ;
            heightBetweenSingleMouseClipsAndExperimentName = 16 ;
            labelTextHeight = 14 ;
            bottomPadHeight = 14 ;
            listboxLabelOffsetHeight = 2 ;
            
            self.experimentClipsListbox_ = uicontrol(...
            'Parent',self.experimentPanel_,...
            'FontUnits',get(0,'defaultuicontrolFontUnits'),...
            'Units','pixels',...
            'String',blanks(0),...
            'Style','listbox',...
            'Value',1,...
            'Position',[leftPadWidth bottomPadHeight experimentClipsListboxWidth experimentClipsListboxHeight],...
            'BackgroundColor',[1 1 1],...
            'Callback',@(hObject,eventdata)(self.hExperimentClipsListbox_Callback()),...
            'Children',[],...
            'KeyPressFcn',@(hObject,eventdata)(self.hExperimentClipsListbox_KeyPressFcn(eventdata)),...
            'Tag','hExperimentClipsListbox');
            
            experimentClipsLabelTextYOffset = bottomPadHeight+experimentClipsListboxHeight+listboxLabelOffsetHeight ;
            self.experimentClipsLabelText_ = uicontrol(...
            'Parent',self.experimentPanel_,...
            'FontUnits',get(0,'defaultuicontrolFontUnits'),...
            'Units','pixels',...
            'String','Experiment Clips',...
            'Style','text',...
            'Position',[leftPadWidth experimentClipsLabelTextYOffset experimentClipsListboxWidth labelTextHeight],...
            'Children',[],...
            'HorizontalAlignment','left', ...
            'Tag','hExperimentClipsText',...
            'FontWeight','bold');
%            'BackgroundColor',[1 0.8 0.2],...
        
            singleMouseClipsListboxYOffset = experimentClipsLabelTextYOffset + labelTextHeight + heightBetweenExperimentClipsAndSingleMouseClips ;
            self.singleMouseClipsListbox_ = uicontrol(...
            'Parent',self.experimentPanel_,...
            'FontUnits',get(0,'defaultuicontrolFontUnits'),...
            'Units','pixels',...
            'String',blanks(0),...
            'Style','listbox',...
            'Value',1,...
            'Position',[leftPadWidth singleMouseClipsListboxYOffset singleMouseClipsListboxWidth singleMouseClipsListboxHeight],...
            'BackgroundColor',[1 1 1],...
            'Callback',@(hObject,eventdata)(self.hSingleMouseListbox_Callback()),...
            'Children',[],...
            'KeyPressFcn',@(hObject,eventdata)(self.hSingleMouseListbox_KeyPressFcn(eventdata)),...
            'Tag','hSingleMouseListbox');

            singleMouseClipsLabelTextYOffset = singleMouseClipsListboxYOffset + singleMouseClipsListboxHeight + listboxLabelOffsetHeight ;
            self.singleMouseClipsLabelText_ = uicontrol(...
            'Parent',self.experimentPanel_,...
            'FontUnits',get(0,'defaultuicontrolFontUnits'),...
            'Units','pixels',...
            'String','Single Mouse Clips',...
            'Style','text',...
            'Position',[leftPadWidth singleMouseClipsLabelTextYOffset singleMouseClipsListboxWidth labelTextHeight],...
            'Children',[],...
            'HorizontalAlignment','left', ...
            'Tag','hsingleMouseClipsText',...
            'FontWeight','bold');
%            'BackgroundColor',[0 1 1],...

            experimentNameTextYOffset = singleMouseClipsLabelTextYOffset + labelTextHeight + heightBetweenSingleMouseClipsAndExperimentName ;
            self.experimentNameText_ = uicontrol(...
            'Parent',self.experimentPanel_,...
            'FontUnits',get(0,'defaultuicontrolFontUnits'),...
            'Units','pixels',...
            'HorizontalAlignment','left',...
            'String','No experiment selected',...
            'Style','text',...
            'Position',[leftPadWidth experimentNameTextYOffset experimentNameTextWidth experimentNameTextHeight],...
            'BackgroundColor',[1 1 1],...
            'Children',[],...
            'Tag','experimentNameText',...
            'FontAngle','italic');
            
            chooseExperimentButtonXOffset = leftPadWidth + experimentContentWidth - chooseExperimentNameButtonWidth ;  % flush right
            chooseExperimentButtonYOffset = experimentNameTextYOffset - (chooseExperimentNameButtonHeight-experimentNameTextHeight)/2 ;
              % center the button on the text field vertically
              
            
            self.chooseExperimentButton_ = uicontrol(...
            'Parent',self.experimentPanel_,...
            'FontUnits',get(0,'defaultuicontrolFontUnits'),...
            'Units','pixels',...
            'String','Choose',...
            'Position',[chooseExperimentButtonXOffset chooseExperimentButtonYOffset chooseExperimentNameButtonWidth chooseExperimentNameButtonHeight],...
            'Callback',@(hObject,eventdata)(self.chooseButtonActuated()),...
            'Children',[],...
            'Tag','chooseExperimentButton');
%            'Callback',@(hObject,eventdata)MouseHouse_export('chooseExperimentButton_Callback',hObject,eventdata,guidata(hObject)),...
                        
            
            %
            % Processing Mode panel
            %
            
            self.processingModeButtonGroup_ = uibuttongroup(...
            'Parent',self.figureGH_,...
            'FontUnits','points',...
            'Units','pixels',...
            'SelectionChangeFcn',@(hObject,eventdata)(self.hProcessingModeGroup_SelectionChangeFcn(eventdata)),...
            'Title','Processing Mode',...
            'Position',[ 21.6944801026957          32.5552050473186          100.962772785623          84.6435331230284],...
            'Clipping','off',...
            'Tag','hProcessingModeGroup');

            self.clusterModeRadiobutton_ = uicontrol(...
            'Parent',self.processingModeButtonGroup_,...
            'FontUnits',get(0,'defaultuicontrolFontUnits'),...
            'Units','pixels',...
            'String','Cluster',...
            'Style','radiobutton',...
            'Value',1,...
            'Position',[   20           14          60          24],...
            'Children',[],...
            'Tag','hClusterMode');

            self.localModeRadiobutton_ = uicontrol(...
            'Parent',self.processingModeButtonGroup_,...
            'FontUnits',get(0,'defaultuicontrolFontUnits'),...
            'Units','pixels',...
            'String','Local',...
            'Style','radiobutton',...
            'Position',[  20          38          60          24],...
            'Children',[],...
            'Tag','hLocalMode');
        
%             % Make some context menus
%             cmenu1 = uicontextmenu('Parent',self.figureGH_) ;
%             uimenu(cmenu1, 'Label', 'View Movie', 'Callback', {@fnViewExperiment,self});
%             set(self.experimentClipsListbox_,'uicontextmenu',cmenu1);
% 
%             cmenu2 = uicontextmenu('Parent',self.figureGH_) ; 
%             uimenu(cmenu2, ...
%                    'Label', 'View Movie', ...
%                    'Callback', {@fnViewSingleMouse,self});
%             set(self.singleMouseClipsListbox_,'uicontextmenu',cmenu2);        
        end

        function closeRequested(self)
            if ~isempty(self.model_) && isvalid(self.model_) ,
                self.model_.unregisterUserInterface() ;                
            end
            self.model_ = [] ;
            self.deleteFigure() ;
        end
        
        function setModel(self,model)
            self.model_ = model ;
            model.registerUserInterface(self) ;
            self.update_() ;
        end        
       
        function modelChanged(self)
            self.update_() ;
        end
        
        function trainButtonActuated(self)
            % --- Executes on button press in hTrain.
            % hObject    handle to hTrain (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)

            % get userdata
            %u=get(hFig,'userdata');
            u = self.model_ ;
            
            % If no experiment has been selected, prompt the user to select one.
            expSelected=u.expSelected;
            if ~expSelected
              self.chooseExperiment_();
            end

            % need to re-load userdat, since fnChooseExperiment() might have changed it
            u=get(self,'userdata');
            expSelected=u.expSelected;

            % If there's _still_ no experiment selected (maybe the user hit "Cancel"),
            % then just return
            if ~expSelected
              return;
            end

            % Get thee single-cmouse clip file names from the userdata.
            clipSMFNAbs=u.clipSMFNAbs;

            % If no single-mouse clips have been selected, prompt the user to select
            % them,
            if isempty(clipSMFNAbs)
              fnSelectSingleMouseClips(self);
            else
              % Even if there are single-mouse clips, see if the user wants to select
              % new ones.
              answer = questdlg('Do you want to select new single-mouse clips?', ...
                                'Question', ...
                                'Yes','No, keep these', ...
                                'Yes');
              if isempty(answer) || strcmpi(answer,'cancel')
                return;
              elseif strcmpi(answer,'Yes')
                fnSelectSingleMouseClips(self);
              end
            end

            % Need to re-load userdata, since fnSelectSingleMouseClips() might have
            % changed it.
            %u=get(hFig,'userdata');
            clipSMFNAbs=u.clipSMFNAbs;

            % If there are no single-mouse clips selected, just return
            if isempty(clipSMFNAbs)
              return;
            end

            % Even though the user pushed the "Train" button to get here, see if
            % they really want to do training.
            answer = questdlg('Do you want to run Training now?', ...
                              'Question','Yes','No, later','Yes');
            if isempty(answer) || strcmpi(answer,'cancel') || ...
                strcmpi(answer,'No, later')
                return
            end

            % If we get here, the user has opted to run training.

            % Set the training status to "in progress"
            u.trainStatus=3;
            %set(hFig,'userdata',u);

            % sync the view
            fnUpdateGUIStatus(self);

            % Do the training.
            wasTrainingSuccessful=fnTrain(self);

            % If we get here, and training finished successfully, update the model
            % accordingly.
            if wasTrainingSuccessful ,
              %u=get(hFig,'userdata');
              u.trainStatus=4;
              %set(hFig,'userdata',u);
            end

            % sync the view to the model
            self.update_();
        end
        
        function trackButtonActuated(self)
            % --- Executes on button press in hTrack.
            % hObject    handle to hTrack (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)

            % get userdata
            model = self.model_ ;            
            expDirName=model.expDirName;
            clipFNAbs=model.clipFNAbs;

            % Generate the dir, file names we'll need.
            sTuningDir = fullfile(expDirName, 'Tuning');
            sDetectionFile = fullfile(sTuningDir, 'Detection.mat');
            sClassifiersFile = fullfile(sTuningDir, 'Identities.mat');

            % Make sure the classifiers file is present.
            if ~exist(sClassifiersFile,'file')
              h=msgbox('Error. Identities file missing. Did the single mouse movies finish processing?');
              waitfor(h);
              return;
            end;

            % Figure out what clips will be tracked.
            if isempty(clipFNAbs)
              fnSelectExperimentClips(self, false);
            else
              answer = ...
                questdlg('Do you want to select new experiment clips?', ...
                         'Question', ...
                         'Yes', ...
                         'Yes, but keep the old ones', ...
                         'No, keep these', ...
                         'Yes');
              if isempty(answer)
                return;
              end
              if strcmpi(answer(1:3),'Yes')
                bAppend = length(answer)>3;
                fnSelectExperimentClips(self, bAppend);
              end
            end

            % fnSelectExperiment() modifies the the userdata, so re-read it
            %model=get(hFig,'userdata');
            clipFNAbs=model.clipFNAbs;
            iClipCurr=model.iClipCurr;

            % If there are no clips, for whatever reason, return without doing
            % anything.
            if isempty(clipFNAbs)
              return;
            end

            % Check for the "detection" file, and generate it if it's absent.
            if exist(sDetectionFile, 'file')
              answer = ...
                questdlg('Detection is already tuned. Do you want to retune it?', ...
                         'Question', ...
                         'Yes, but starting from the previous tuning', ...
                         'Yes, ignore previous tuning', ...
                         'No, keep existing tuning', ...
                         'No, keep existing tuning');
              if strcmpi(answer, 'Yes, but starting from the previous tuning')
                strctID = load(sClassifiersFile);  % Load the classifiers file.
                iNumMice = length(strctID.strctIdentityClassifier.m_astrctClassifiers);
                TuneSegmentationGUI(iNumMice, sTuningDir);
              elseif strcmpi(answer, 'Yes, ignore previous tuning')
                strctMovieInfo = fnReadVideoInfo(clipFNAbs{iClipCurr});
                strctID = load(sClassifiersFile);  % Load the classifiers file.
                set(self,'pointer','watch');
                drawnow('expose');  drawnow('update');
                fnTuneBackgroundFromScratch(strctMovieInfo, strctID, sTuningDir);
                set(self,'pointer','arrow');
                drawnow('expose');  drawnow('update');
              end
            else
              clipFNAbsThis=clipFNAbs{iClipCurr};
              strctMovieInfo = fnReadVideoInfo(clipFNAbsThis);
              strctID = load(sClassifiersFile);  % Load the classifiers file.
              set(self,'pointer','watch');
              drawnow('expose');  drawnow('update');
              fnTuneBackgroundFromScratch(strctMovieInfo, strctID, sTuningDir);
              set(self,'pointer','arrow');
              drawnow('expose');  drawnow('update');
            end

            % Even though they got here by pressing the "Track" button, ask the user
            % if they want to run tracking.
            answer = ...
              questdlg('Do you want to run tracking now?', ...
                       'Question', ...
                       'Yes', ...
                       'No, later', ...
                       'Yes');
            if isempty(answer) || strcmpi(answer,'No, later')
              return;
            end

            % Finally, run tracking...
            fnTrack(self);
        end  % function
        
        function update_(self)
            % Update the processing mode enablement
            isLinuxAndClusterExecutablePresent = islinux() && MotrUserInterface.isClusterExecutablePresent() ;
            set(self.localModeRadiobutton_ ,'Enable',onIff(isLinuxAndClusterExecutablePresent));
            set(self.clusterModeRadiobutton_ ,'Enable',onIff(isLinuxAndClusterExecutablePresent));            

            % Update the processing mode widgets
            if isempty(self.model_)
                clusterMode=false;
            else
                clusterMode=self.model_.clusterMode;
            end
            set(self.localModeRadiobutton_ , 'Value', ~clusterMode);
            set(self.clusterModeRadiobutton_, 'Value',  clusterMode);
            
            % get the model out, and stuff
            if isempty(self.model_) ,
                expSelected = false ;
            else
                model = self.model_ ;
                % Get relevant info out of the u structure
                expSelected=model.expSelected;
                %expDirName=u.expDirName;
            end

            % % update the listbox of experiment names
            % if expSelected
            %     expDirName=u.expDirName;
            %     listItem={'--- Select a New Experiment ---' expDirName}';
            % else
            %     listItem={'--- Select a New Experiment ---'};
            % end
            % if expSelected
            %     iCurrListItem=2;
            % else
            %     iCurrListItem=1;
            % end    
            % set(handles.hChooseExp, 'String', listItem);
            % set(handles.hChooseExp, 'Value', iCurrListItem);

            % update the experiment name
            if expSelected ,
                expDirName=model.expDirName;
                set(self.experimentNameText_, 'String', expDirName);
                set(self.experimentNameText_, 'FontAngle', 'normal');
            else
                set(self.experimentNameText_, 'String', 'No experiment selected');
                set(self.experimentNameText_, 'FontAngle', 'italic');
            end     

            % unpack u, if there's an experiment
            if expSelected ,
                % get stuff out of u
                clipFNAbs=model.clipFNAbs;
                clipSMFNAbs=model.clipSMFNAbs;
                iClipCurr=model.iClipCurr;
                iClipSMCurr=model.iClipSMCurr;
                trainStatus=model.trainStatus;
                trackStatus=model.trackStatus;
            else
                % if no experiments, set things to default values and exit
                set(self.singleMouseClipsListbox_, 'Value', 1);
                set(self.singleMouseClipsListbox_, 'String', {''});
                set(self.experimentClipsListbox_, 'Value', 1);
                set(self.experimentClipsListbox_, 'String', {''});
                %C = fnGetColorCode();
                %set(self.trainButton_, 'BackgroundColor', C(1,:));
                %set(self.trackButton_, 'BackgroundColor', C(1,:));
                set(self.trainButton_, 'Enable', 'off');
                set(self.trackButton_, 'Enable', 'off');
                set(self.resultsButton_, 'Enable', 'off');
                return
            end    

            % Set Train and Track button enablement
            set(self.trainButton_, 'Enable', 'on');
            if trainStatus>=4
              set(self.trackButton_, 'Enable', 'on');
            else
              set(self.trackButton_, 'Enable', 'off');
            end

            % update the single-mouse clips
            set(self.singleMouseClipsListbox_, 'String', clipSMFNAbs);
            set(self.singleMouseClipsListbox_, 'Value', max(1,iClipSMCurr));

            % generate the clip listbox items by coloring the clip names
            % appropriately
            clipListString=MotrUserInterface.colorizeClips(clipFNAbs,trackStatus,iClipCurr);

            % update the clip listbox
            set(self.experimentClipsListbox_, 'String', clipListString);
            set(self.experimentClipsListbox_, 'Value', max(1,iClipCurr));  % setting this to -1 causes listbox to not be rendered, sometimes

            % update the enablement of the Results button
            if length(clipFNAbs)>0 && trackStatus(iClipCurr)==4  %#ok
                set(self.resultsButton_, 'Enable', 'on');
            else
                set(self.resultsButton_, 'Enable', 'off');
            end

%             % get the color code
%             C = fnGetColorCode();

%             % update the training button color
%             set(self.trainButton_, 'BackgroundColor', C(trainStatus,:));

%             % update the tracking button color
%             if isempty(clipFNAbs)
%                 trackStatusOverall=1;
%             else
%                 trackStatusOverall=max(trackStatus);
%             end
%             set(self.trackButton_, 'BackgroundColor', ...
%                                 C(trackStatusOverall,:));

            % Update the processing mode widgets
            clusterMode=model.clusterMode;
            set(self.localModeRadiobutton_ , 'Value', ~clusterMode);
            set(self.clusterModeRadiobutton_, 'Value',  clusterMode);

            isLinuxAndClusterExecutablePresent = islinux() && MotrUserInterface.isClusterExecutablePresent() ;
            set(self.localModeRadiobutton_ ,'Enable',onIff(isLinuxAndClusterExecutablePresent));
            set(self.clusterModeRadiobutton_ ,'Enable',onIff(isLinuxAndClusterExecutablePresent));            
        end  % function
        
        function chooseButtonActuated(self)
            self.chooseExperiment_();
            clear global g_a2fDistToWall; % make fnSegmentForeground2 re-compute g_a2fDistToWall
        end

        function chooseExperiment_(self)
            global g_strctGlobalParam g_strMouseStuffRootDirName
            
            % get the userdata, see if there's a current experiment
            model = self.model_ ;
            expSelected=model.expSelected;

            % get the listbox selection
            %handles=guidata(hFig);
            %iList = get(handles.hChooseExp, 'Value');

            sExp = uigetdir('.', ...
                            'Choose directory of an experiment');
            if sExp==0  % means user hit Cancel button
              fnUpdateGUIStatus(self);
              return;
            end
            %sExp = fnConvertToAbsolutePath(sExp);
            if expSelected
                expDirName=model.expDirName;
                if any(strcmp(sExp, expDirName))
                    % this means they selected the current experiment
                    fnUpdateGUIStatus(self);
                    %msgbox(['An experiment named ' sExp ' already exists']);
                    return;

                else
                    % this means they selected a different experiment from the current
                    % one--so check whether the user wants to use the same Config file.
                    % [KMS, 2015-09-09]
                    buttonName = questdlg('Do you want to use the same Configuration file?','config question','Yes','No, use the Default', 'No, let me choose a different one','Yes');

                    if strcmp(buttonName,'No, use the Default') == 1;
                        g_strctGlobalParam = ...
                            fnLoadAlgorithmsConfigXML(fullfile(g_strMouseStuffRootDirName, ...
                            'Config','Algorithms.xml'));
                        % g_strctGlobalParam=fnLoadAlgorithmsConfigNative();
                        %   % eliminate dependence on XML file.  Checked that these assign the same
                        %   % value to g_strctGlobalParam.  ALT, 2012-01-09
                    elseif strcmp(buttonName,'No, let me choose a different one') == 1;
                        fileName = uigetfile('.xml','Please select a Configuration file',[g_strMouseStuffRootDirName '\Config']);
                        g_strctGlobalParam = ...
                            fnLoadAlgorithmsConfigXML(fullfile(g_strMouseStuffRootDirName, ...
                            'Config',fileName));
                    end
                    clear buttonName fileName

                end
            end
            setCurrentExperiment(self, sExp);
        end  % function
    
        function result = get(self,propertyName)
            result = self.(propertyName) ;
        end
        
        function set(self,propertyName,value)
            self.(propertyName) = value ;
        end
        
        function value = get.pointer(self) 
            value = get(self.figureGH_,'Pointer') ;
        end
        
        function set.pointer(self,value) 
            set(self.figureGH_,'Pointer',value) ;
            %drawnow('expose');  drawnow('update');
        end
        
        function result = guidata(self)
            % this is so I don't have to change a lot of legacy code
            result = self ;
        end
        
        function fnUpdateGUIStatus(self)
            self.update_() ;
        end
        
        function hResults_Callback(self)
            %[iStatus, sExpName, aiNumJobs, acExperimentClips] = fnGetExpInfo();
            u=get(self,'userdata');
            expDirName=u.expDirName;
            clipFNAbs=u.clipFNAbs;
            iClipCurr=u.iClipCurr;
            clipFNAbsThis=clipFNAbs{iClipCurr};
            %clipInfo = fnReadVideoInfo(clipFNThis);
            [dummy, clipBaseName] = fileparts(clipFNAbsThis);  %#ok
            tuningDirName = fullfile(expDirName, 'Tuning');
            jobsDirName = fullfile(expDirName, 'Jobs');
            resultsDirName = fullfile(expDirName, 'Results');
            tracksDirName = fullfile(resultsDirName, 'Tracks');
            trackFN = fullfile(tracksDirName, [clipBaseName '_tracks.mat']);
            if ~exist(trackFN,'file')
              % try the old-school output file name
              trackFN = fullfile(tracksDirName, [clipBaseName '.mat']);
            end
            classifiersFN = fullfile(tuningDirName, 'Identities.mat');
            launchResultsEditor(jobsDirName, ...
                                resultsDirName, ...
                                tuningDirName, ...
                                classifiersFN, ...
                                clipFNAbsThis, ...
                                trackFN);
        end  % function
        
        function hSingleMouseListbox_Callback(self)
            iVal = get(self.singleMouseClipsListbox_,'Value');
            fnSetCurrentSingleMouseClip(self,iVal);
        end
        
        function hSingleMouseListbox_KeyPressFcn(self,eventdata)
            val = get(self.singleMouseClipsListbox_, 'Value');
            if strcmp(eventdata.Key, 'delete')
               %acClipName = cellstr(get(hObject, 'String'));
               %fnUpdateStatus(handles, 'acSingleMouseClips', val);
               fnDeleteSingleMouseClip(self, val)
            elseif strcmp(eventdata.Key, 'return')
               fnVerifyTracking(self.handles, val);
            end
        end  % function
        
        function hExperimentClipsListbox_Callback(self)
            iVal = get(self.experimentClipsListbox_,'Value');
            fnSetCurrentExpClip(self,iVal);
        end

        function hExperimentClipsListbox_KeyPressFcn(self, eventdata)
            if strcmp(eventdata.Key, 'delete')
               %acClipName = cellstr(get(hObject, 'String'));
               val = get(self.experimentClipsListbox_, 'Value');
               %fnUpdateStatus(handles, 'acExperimentClips', val);
               fnDeleteClip(self,val);
            end
        end
        
        function hProcessingModeGroup_SelectionChangeFcn(self, eventdata)
            tag=get(eventdata.NewValue,'Tag');
            if strcmp(tag,'hLocalMode')
                clusterMode = 0;
            else
                clusterMode = 1;
            end
            u=get(self,'userdata');
            u.clusterMode=clusterMode;
            %set(gcbf,'userdata',u);
        end
        
    end  % methods
        
    methods (Static=true)
        function clipListString=colorizeClips(clipFNAbs,trackStatus,iCurrClip)
            % Takes a cell array of strings containing the clip file names, and their
            % respective statuses, and the index of the current clip and returns
            % a cell array of HTML strings used to populate the clip listbox, in which
            % clips are colored according to their status code.

            % get color info
            C = MotrUserInterface.fnGetColorCode();
            Chtml = MotrUserInterface.fnGetHtmlColorStrings(C);

            % colorize each clip name appropriately
            nClips=length(clipFNAbs);
            clipListString=cell(1,nClips);
            for i=1:nClips
                iStatus = trackStatus(i);
                if i == iCurrClip
                    clipListString{i} = ['<html><bgcolor="' Chtml{iStatus,1,2} ...
                                         '"><font color="' Chtml{iStatus,2,2} '">' ...
                                         clipFNAbs{i} '</font></html>'];
                else
                    clipListString{i} = ['<html><bgcolor="' Chtml{iStatus,1,1} ...
                                         '"><font color="' Chtml{iStatus,2,1} '">' ...
                                         clipFNAbs{i} '</font></html>'];
                end
            end                        
        end  % function
        
        function C = fnGetColorCode()
            % This is the color code used for coloring clip file names
            C = [ 0   1    0   ; ...
                  1   1    0   ; ...
                  1   0.8  0.2 ; ...
                  1   0    0   ];
        end
        
        function Chtml = fnGetHtmlColorStrings(C)
            % Given a "list" of colors, returns a cell array with some HTML
            % snippets used to color the FG, BG of the clip file names
            nColors = size(C, 1) ;
            Chtml = cell(nColors,2,2);
            for i=1:nColors , 
               Chtml{i,1,1} = sprintf('rgb(%f,%f,%f)', 255*C(i,:));
               Chtml{i,2,1} = sprintf('rgb(%f,%f,%f)', [0 0 0]); % 255*(1-C(i,:)));
               Chtml{i,1,2} = sprintf('rgb(%f,%f,%f)', 230*C(i,:));
               Chtml{i,2,2} = sprintf('rgb(%f,%f,%f)', [0 0 0]); % 255-230*C(i,:));
            end
        end
        
        function result=isClusterExecutablePresent()
            % figure out where the root of the Motr code is
            thisScriptFileName=mfilename('fullpath');
            thisScriptDirName=fileparts(thisScriptFileName);
            thisScriptDirParts=split_on_filesep(thisScriptDirName);
              % a cell array with each dir an element
            motrRootParts=thisScriptDirParts(1:end-2);
            motrRootDirNameAbs=combine_with_filesep(motrRootParts);

            % Construct the absolute file name of the executable
            exeDirNameAbs= ...
              fullfile(motrRootDirNameAbs,'Deploy','MouseTrackProj','src');

            exeFNAbs=fullfile(exeDirNameAbs,'MouseTrackProj');                

            % Check whether the executable exists                
            result=exist(exeFNAbs,'file');
        end
        
        function fnWaitForAllJobsToFinish(acstrJobFiles)
            iNumJobs = length(acstrJobFiles);
            for iJob=1:iNumJobs
               while ~exist(acstrJobFiles{iJob}, 'file')
                  %pause(60);
                  pause(10);  % Hope this is OK.  --ALT, 2012-02-21
               end
            end
        end
        
    end  % static methods
    
end  % classdef
