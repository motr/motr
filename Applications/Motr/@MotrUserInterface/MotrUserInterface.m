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
        parameterFileNameLabelText_        
        parameterFileNameEdit_        
        changeParameterFileNameButton_
        chooseExperimentDirNameButton_
        experimentDirNameLabelText_
        experimentDirNameEdit_
        processingModeButtonGroup_
        clusterModeRadiobutton_
        localModeRadiobutton_
    end
    
    methods
        function self=MotrUserInterface()
            %fprintf('MotrUserInterface::MotrUserInterface()\n');
            
            global g_bMouseHouse g_bVERBOSE g_iLogLevel;
            global g_CaptainsLogDir g_logImIndex;
            
            g_bMouseHouse = true;
            g_bVERBOSE = false;
            g_iLogLevel = 0;
            % SO Feb 08 2012 : Adam, I prefer not to change the current directory during a matlab session. But in any case, please keep the variable convensions. 
            %                  If you use global variables, add a "g_" prefix to them.
            % Want to store a global that contains the root directory for
            % all the Ohayons code---this allows us to be independent of what
            % the current working directory is.
%             global g_strMouseStuffRootDirName;
%             thisFileName=mfilename('fullpath');
%             thisDirName=fileparts(thisFileName);
%             thisDirParts=split_on_filesep(thisDirName);
%               % a cell array with each dir an element
%             mouseStuffRootParts=thisDirParts(1:end-3);
%             g_strMouseStuffRootDirName=combine_with_filesep(mouseStuffRootParts);

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

%             % Load various algorithm parameters from the XML file
%             g_strctGlobalParam = ...
%                 fnLoadAlgorithmsConfigXML(fullfile(g_strMouseStuffRootDirName, ...
%                                                    'Config','Algorithms.xml'));
%                                                
%             % g_strctGlobalParam=fnLoadAlgorithmsConfigNative();
%             %   % eliminate dependence on XML file.  Checked that these assign the same
%             %   % value to g_strctGlobalParam.  ALT, 2012-01-09

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
            
            labelTextHeight = 14 ;
            extentToPositionWidth = 0 ;
            labelToEditSpaceWidth = 2 ;
            editHeight = 20 ;
            
            operationsPanelWidth = 122 ;
            
            experimentPanelLeftPadWidth = 18 ;
            experimentPanelRightPadWidth = 10 ;
            %experimentDirNameEditHeight = editHeight ;            
            chooseExperimentDirNameButtonWidth = 76 ;
            chooseExperimentDirNameButtonHeight = 24 ;            
            experimentContentWidth = 600 ;
            experimentClipsListboxWidth = experimentContentWidth ;
            experimentClipsListboxHeight = 100 ;
            singleMouseClipsListboxWidth = experimentContentWidth ;
            singleMouseClipsListboxHeight = 100 ;
            heightBetweenExperimentClipsAndSingleMouseClips = 10 ;
            heightBetweenSingleMouseClipsAndParameterFileName = 14 ;
            heightBetweenParameterFileNameAndExperimentDirName = 8 ;
            experimentPanelBottomPadHeight = 14 ;
            experimentPanelTopPadHeight = 6 ;
            heightOfPanelLabelShim = 22 ;
            listboxLabelOffsetHeight = 2 ;
            changeParameterFileNameButtonWidth = 76 ;
            changeParameterFileNameButtonHeight = 24 ;            
            widthBetweenParameterFileNameTextAndButton = 8 ;
            widthBetweenExperimentDirNameTextAndButton = 8 ;
            
            parameterFileNameRowHeight = max([labelTextHeight editHeight changeParameterFileNameButtonHeight]) ;
            experimentDirNameRowHeight = max([labelTextHeight editHeight chooseExperimentDirNameButtonHeight]) ;
            
            experimentPanelHeight = experimentPanelBottomPadHeight + ...
                                    experimentClipsListboxHeight + ...
                                    listboxLabelOffsetHeight + ...
                                    labelTextHeight + ...
                                    heightBetweenExperimentClipsAndSingleMouseClips+ ...
                                    singleMouseClipsListboxHeight + ...
                                    listboxLabelOffsetHeight + ...
                                    labelTextHeight + ...
                                    heightBetweenSingleMouseClipsAndParameterFileName + ...
                                    parameterFileNameRowHeight + ...
                                    heightBetweenParameterFileNameAndExperimentDirName + ...
                                    experimentDirNameRowHeight + ...
                                    experimentPanelTopPadHeight + ...
                                    heightOfPanelLabelShim ;
            experimentPanelWidth = experimentPanelLeftPadWidth + experimentContentWidth + experimentPanelRightPadWidth ;

            figureLeftPad = 10 ;
            figureRightPad = 10 ;
            figureBottomPad = 10 ;
            figureTopPad = 10 ;
            interPanelWidth = 10 ;

            experimentPanelXOffset = figureLeftPad + operationsPanelWidth + interPanelWidth ;  % 148
            
            %figureWidth = 650 ;
            %figureHeight = 344 ;
            figureWidth = figureLeftPad + operationsPanelWidth + interPanelWidth + experimentPanelWidth + figureRightPad;
            figureHeight = figureBottomPad + experimentPanelHeight + figureTopPad ;            
            figureX = 100 ;
            figureY = screenHeight - figureHeight - 22 - 100;  % 22 is the approx title bar width
            
            %figureNormedMultiplier = [figureWidth figureHeight figureWidth figureHeight]
            
            self.figureGH_ = ...
                figure('Units','pixels',...
                       'Position',[figureX figureY figureWidth figureHeight],...
                       'Color',get(0,'defaultUIControlBackgroundColor'), ...
                       'IntegerHandle','off',...
                       'MenuBar','none',...
                       'Name','Motr 1.06',...
                       'NumberTitle','off',...
                       'Tag','motr',...
                       'Resize','off', ...
                       'CloseRequestFcn',@(source,event)(self.closeRequested()));
%            'HandleVisibility','callback',...

                        
            
            %
            % Operations panel
            %
            
            self.operationsPanel_ = uipanel(...
            'Parent',self.figureGH_,...
            'Units','pixels',...
            'Title','Operations',...
            'Position',[figureLeftPad          144          operationsPanelWidth          183],...
            'Clipping','off',...
            'Tag','hOperations');

            %operationsPanelPosition = get(self.operationsPanel_,'Position') ;
            %operationsPanelWidth = operationsPanelPosition(3) ;
            %operationsPanelHeight = operationsPanelPosition(4) ;            
            %operationsPanelNormedMultiplier = [operationsPanelWidth operationsPanelHeight operationsPanelWidth operationsPanelHeight]
            
            self.trainButton_ = uicontrol(...
            'Parent',self.operationsPanel_,...
            'Units','pixels',...
            'String','Train',...
            'Position',[14           116          90          40],...
            'Callback',@(hObject,eventdata)(self.trainButtonActuated()),...
            'Tag','hTrain',...
            'FontWeight','bold');
%            'Callback',@(hObject,eventdata)MouseHouse_export('hTrain_Callback',hObject,eventdata,guidata(hObject)),...

            self.trackButton_ = uicontrol(...
            'Parent',self.operationsPanel_,...
            'Units','pixels',...
            'String','Track',...
            'Position',[ 14          66          90          40],...
            'Callback',@(hObject,eventdata)(self.trackButtonActuated()),...
            'Tag','hTrack',...
            'FontWeight','bold');
        
            self.resultsButton_ = uicontrol(...
            'Parent',self.operationsPanel_,...
            'Units','pixels',...
            'String','Results',...
            'Position',[14           16          90          40],...
            'Callback',@(hObject,eventdata)(self.hResults_Callback()),...
            'Tag','hResults',...
            'FontWeight','bold');
            %'Callback',@(hObject,eventdata)MouseHouse_export('hResults_Callback',hObject,eventdata,guidata(hObject)),...

                        
            
            %
            % Experiment panel
            %
            
            self.experimentPanel_ = uipanel(...
            'Parent',self.figureGH_,...
            'Units','pixels',...
            'Title','Experiment',...
            'Position',[experimentPanelXOffset           figureBottomPad          experimentPanelWidth          experimentPanelHeight],...
            'Tag','hExperiment');
            
            self.experimentClipsListbox_ = uicontrol(...
            'Parent',self.experimentPanel_,...
            'Units','pixels',...
            'String',blanks(0),...
            'Style','listbox',...
            'Value',1,...
            'Position',[experimentPanelLeftPadWidth experimentPanelBottomPadHeight experimentClipsListboxWidth experimentClipsListboxHeight],...
            'BackgroundColor',[1 1 1],...
            'Callback',@(hObject,eventdata)(self.hExperimentClipsListbox_Callback()),...
            'KeyPressFcn',@(hObject,eventdata)(self.hExperimentClipsListbox_KeyPressFcn(eventdata)),...
            'Tag','hExperimentClipsListbox');
            
            experimentClipsLabelTextYOffset = experimentPanelBottomPadHeight+experimentClipsListboxHeight+listboxLabelOffsetHeight ;
            self.experimentClipsLabelText_ = uicontrol(...
            'Parent',self.experimentPanel_,...
            'Units','pixels',...
            'String','Experiment Clips',...
            'Style','text',...
            'Position',[experimentPanelLeftPadWidth experimentClipsLabelTextYOffset experimentClipsListboxWidth labelTextHeight],...
            'Children',[],...
            'HorizontalAlignment','left', ...
            'Tag','hExperimentClipsText',...
            'FontWeight','bold');
%            'BackgroundColor',[1 0.8 0.2],...
        
            singleMouseClipsListboxYOffset = experimentClipsLabelTextYOffset + labelTextHeight + heightBetweenExperimentClipsAndSingleMouseClips ;
            self.singleMouseClipsListbox_ = uicontrol(...
            'Parent',self.experimentPanel_,...
            'Units','pixels',...
            'String',blanks(0),...
            'Style','listbox',...
            'Value',1,...
            'Position',[experimentPanelLeftPadWidth singleMouseClipsListboxYOffset singleMouseClipsListboxWidth singleMouseClipsListboxHeight],...
            'BackgroundColor',[1 1 1],...
            'Callback',@(hObject,eventdata)(self.hSingleMouseListbox_Callback()),...
            'KeyPressFcn',@(hObject,eventdata)(self.hSingleMouseListbox_KeyPressFcn(eventdata)),...
            'Tag','hSingleMouseListbox');

            singleMouseClipsLabelTextYOffset = singleMouseClipsListboxYOffset + singleMouseClipsListboxHeight + listboxLabelOffsetHeight ;
            self.singleMouseClipsLabelText_ = uicontrol(...
            'Parent',self.experimentPanel_,...
            'Units','pixels',...
            'String','Single Mouse Clips',...
            'Style','text',...
            'Position',[experimentPanelLeftPadWidth singleMouseClipsLabelTextYOffset singleMouseClipsListboxWidth labelTextHeight],...
            'HorizontalAlignment','left', ...
            'Tag','hsingleMouseClipsText',...
            'FontWeight','bold');
%            'BackgroundColor',[0 1 1],...

            % Parameter file name row
            parameterFileNameRowYOffset = singleMouseClipsLabelTextYOffset + labelTextHeight + heightBetweenSingleMouseClipsAndParameterFileName ;
            parameterFileNameLabelTextYOffset = ...
                parameterFileNameRowYOffset + ...
                (parameterFileNameRowHeight-labelTextHeight)/2 ;
            self.parameterFileNameLabelText_ = ...
                uicontrol('Parent',self.experimentPanel_,...
                          'Style','text',...
                          'Units','pixels',...
                          'HorizontalAlignment','left',...
                          'String','Parameter File:',...
                          'Tag','parameterFileNameEdit');
            parameterFileNameLabelTextExtent = get(self.parameterFileNameLabelText_,'Extent') ;
            parameterFileNameLabelTextExtentWidth = parameterFileNameLabelTextExtent(3) ;
            parameterFileNameLabelTextWidth = parameterFileNameLabelTextExtentWidth + extentToPositionWidth ;
            set(self.parameterFileNameLabelText_, ...
                'Position',[experimentPanelLeftPadWidth parameterFileNameLabelTextYOffset parameterFileNameLabelTextWidth labelTextHeight]);
                      
            parameterFileNameEditXOffset = experimentPanelLeftPadWidth + parameterFileNameLabelTextWidth + labelToEditSpaceWidth ; 
            parameterFileNameEditYOffset = ...
                parameterFileNameRowYOffset + ...
                (parameterFileNameRowHeight-editHeight)/2 ;
            parameterFileNameEditWidth = ...
                experimentContentWidth - ...
                (parameterFileNameLabelTextWidth + labelToEditSpaceWidth + changeParameterFileNameButtonWidth + widthBetweenParameterFileNameTextAndButton) ;
            self.parameterFileNameEdit_ = ...
                uicontrol('Parent',self.experimentPanel_,...
                          'Style','edit',...
                          'Enable','off', ...
                          'Units','pixels',...
                          'HorizontalAlignment','left',...
                          'String','',...
                          'Position',[parameterFileNameEditXOffset parameterFileNameEditYOffset parameterFileNameEditWidth editHeight],...
                          'Tag','parameterFileNameEdit', ...
                          'BackgroundColor','w');
                      
            changeParameterFileNameButtonXOffset = parameterFileNameEditXOffset + parameterFileNameEditWidth + widthBetweenParameterFileNameTextAndButton ;
                % above is flush right
            changeParameterFileNameButtonYOffset = parameterFileNameLabelTextYOffset - (changeParameterFileNameButtonHeight-labelTextHeight)/2 ;
              % center the button on the text field vertically            
            self.changeParameterFileNameButton_ = ...
                uicontrol('Parent',self.experimentPanel_,...
                          'Units','pixels',...
                          'String','Change',...
                          'Position',[changeParameterFileNameButtonXOffset changeParameterFileNameButtonYOffset ...
                                      changeParameterFileNameButtonWidth changeParameterFileNameButtonHeight], ...
                          'Callback',@(hObject,eventdata)(self.changeParameterFileNameButtonActuated()), ...
                          'Tag','changeParameterFileNameButton');
                      
            % Experiment directory name row  
            experimentDirNameRowYOffset = parameterFileNameRowYOffset + parameterFileNameRowHeight + heightBetweenParameterFileNameAndExperimentDirName ;
            experimentDirNameLabelTextYOffset = ...
                experimentDirNameRowYOffset + ...
                (experimentDirNameRowHeight-labelTextHeight)/2 ;
            self.experimentDirNameLabelText_ = ...
                uicontrol('Parent',self.experimentPanel_,...
                          'Style','text',...
                          'Units','pixels',...
                          'HorizontalAlignment','left',...
                          'String','Experiment Directory:',...
                          'Tag','experimentDirNameEdit');
            experimentDirNameLabelTextExtent = get(self.experimentDirNameLabelText_,'Extent') ;
            experimentDirNameLabelTextExtentWidth = experimentDirNameLabelTextExtent(3) ;
            experimentDirNameLabelTextWidth = experimentDirNameLabelTextExtentWidth + extentToPositionWidth ;
            set(self.experimentDirNameLabelText_, ...
                'Position',[experimentPanelLeftPadWidth experimentDirNameLabelTextYOffset experimentDirNameLabelTextWidth labelTextHeight]);
                      
            experimentDirNameEditXOffset = experimentPanelLeftPadWidth + experimentDirNameLabelTextWidth + labelToEditSpaceWidth ; 
            experimentDirNameEditYOffset = ...
                experimentDirNameRowYOffset + ...
                (experimentDirNameRowHeight-editHeight)/2 ;
            experimentDirNameEditWidth = ...
                experimentContentWidth - ...
                (experimentDirNameLabelTextWidth + labelToEditSpaceWidth + chooseExperimentDirNameButtonWidth + widthBetweenExperimentDirNameTextAndButton) ;
            self.experimentDirNameEdit_ = ...
                uicontrol('Parent',self.experimentPanel_,...
                          'Style','edit',...
                          'Enable','off', ...
                          'Units','pixels',...
                          'HorizontalAlignment','left',...
                          'String','No experiment selected',...
                          'Position',[experimentDirNameEditXOffset experimentDirNameEditYOffset experimentDirNameEditWidth editHeight],...
                          'Tag','experimentDirNameEdit', ...
                          'BackgroundColor','w', ...
                          'FontAngle','italic');
                      
            chooseExperimentDirNameButtonXOffset = experimentDirNameEditXOffset + experimentDirNameEditWidth + widthBetweenExperimentDirNameTextAndButton ;
                % above is flush right
            chooseExperimentDirNameButtonYOffset = experimentDirNameRowYOffset + experimentDirNameRowHeight/2 - chooseExperimentDirNameButtonHeight/2 ;
              % center the button in the row vertically            
            self.chooseExperimentDirNameButton_ = ...
                uicontrol('Parent',self.experimentPanel_,...
                          'Units','pixels',...
                          'String','Change',...
                          'Position',[chooseExperimentDirNameButtonXOffset chooseExperimentDirNameButtonYOffset ...
                                      chooseExperimentDirNameButtonWidth chooseExperimentDirNameButtonHeight], ...
                          'Callback',@(hObject,eventdata)(self.chooseExperimentDirNameButtonActuated()), ...
                          'Tag','chooseExperimentDirNameButton');

                      
                      
            %
            % Processing Mode panel
            %
            
            self.processingModeButtonGroup_ = uibuttongroup(...
            'Parent',self.figureGH_,...
            'Units','pixels',...
            'SelectionChangeFcn',@(hObject,eventdata)(self.hProcessingModeGroup_SelectionChangeFcn(eventdata)),...
            'Title','Processing',...
            'Position',[ 21.6944801026957          32.5552050473186          100.962772785623          84.6435331230284],...
            'Tag','hProcessingModeGroup');

            self.clusterModeRadiobutton_ = uicontrol(...
            'Parent',self.processingModeButtonGroup_,...
            'Units','pixels',...
            'String','Cluster',...
            'Style','radiobutton',...
            'Value',1,...
            'Position',[   20           14          60          24],...
            'Tag','hClusterMode');

            self.localModeRadiobutton_ = uicontrol(...
            'Parent',self.processingModeButtonGroup_,...
            'Units','pixels',...
            'String','Local',...
            'Style','radiobutton',...
            'Position',[  20          38          60          24],...
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
            model = self.model_ ;
            
            % If no experiment has been selected, just return
            expSelected=model.expSelected;
            if ~expSelected
                return
                %self.chooseExperiment_();
            end

%             % need to re-load userdat, since fnChooseExperiment() might have changed it
%             u=get(self,'userdata');
%             expSelected=u.expSelected;

%             % If there's _still_ no experiment selected (maybe the user hit "Cancel"),
%             % then just return
%             if ~expSelected
%               return;
%             end

            % Get thee single-cmouse clip file names from the userdata.
            clipSMFNAbs=model.clipSMFNAbs;

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
                                'No, keep these');
              if isempty(answer) || strcmpi(answer,'cancel')
                return
              elseif strcmpi(answer,'Yes')
                fnSelectSingleMouseClips(self);
              end
            end

            % Need to re-load userdata, since fnSelectSingleMouseClips() might have
            % changed it.
            %u=get(hFig,'userdata');
            clipSMFNAbs=model.clipSMFNAbs;

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
            model.trainStatus=3;
            %set(hFig,'userdata',u);

            % sync the view
            fnUpdateGUIStatus(self);

            % Do the training.
            wasTrainingSuccessful=fnTrain(self);

            % If we get here, and training finished successfully, update the model
            % accordingly.
            if wasTrainingSuccessful ,
              %u=get(hFig,'userdata');
              model.trainStatus=4;
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
            %expDirName=model.expDirName;
            %clipFNAbs=model.clipFNAbs;

            % Read in g_strctGlobalParam from disk, if it's not set already
            global g_strctGlobalParam

            % Define a local callback function, which will only be used once
            function err = callbackForNewParameterFileName(parameterFileNameAbs)
                err = model.setParameterFileNameAbs(parameterFileNameAbs) ;
            end                  

            if isempty(g_strctGlobalParam) ,
                originalAbsoluteFileNameOfParameterFile = model.parameterFileNameAbs_ ;
                fileNameFilter = {'*.xml', 'Extensible Markup Language Files (*.xml)'; ...
                                  '*.*', 'All Files' } ;
                [doesFileExist, ~, absoluteFileNameOfParameterFile, callbackError] = ...
                    MotrUserInterface.checkIfFileExistsAndAskUserToLocateIfNot(originalAbsoluteFileNameOfParameterFile , ...
                                                                               fileNameFilter , ...
                                                                               @callbackForNewParameterFileName) ;
                if ~doesFileExist || ~isempty(callbackError), 
                    %success = false ;
                    return
                end                                             
                g_strctGlobalParam = fnLoadAlgorithmsConfigXML(absoluteFileNameOfParameterFile) ;
            end
            
            % Generate the dir, file names we'll need.
            sTuningDir = fullfile(model.expDirName, 'Tuning');
            sDetectionFile = fullfile(sTuningDir, 'Detection.mat');
            sClassifiersFile = fullfile(sTuningDir, 'Identities.mat');

            % Make sure the classifiers file is present.
            if ~exist(sClassifiersFile,'file')
              h=msgbox('Error. Identities file missing. Did the single mouse movies finish processing?');
              waitfor(h);
              return
            end

            % Figure out what clips will be tracked.
            if isempty(model.clipFNAbs)
              fnSelectExperimentClips(self, false);
            else
              answer = ...
                questdlg('Do you want to select new experiment clips?', ...
                         'Question', ...
                         'Yes', 'Yes, but keep the old ones', 'No, keep these', ...
                         'No, keep these');
              if isempty(answer)
                return;
              end
              if strcmpi(answer(1:3),'Yes')
                bAppend = length(answer)>3;
                fnSelectExperimentClips(self, bAppend);
              end
            end

            % If there are no clips, for whatever reason, return without doing
            % anything.
            if isempty(model.clipFNAbs)
              return
            end

            % Make sure all the clips are where we think they are
            nClips = length(model.clipFNAbs) ;
            for clipIndex=1:nClips ,
                optionalVideoInfo = self.checkThatClipExistsThenReadVideoInfo(clipIndex) ;
                if isempty(optionalVideoInfo) ,
                  return
                end
            end            
            % If we get here, all the clip files are where they should be
            
            % Check for the "detection" file, and generate it if it's absent.
            iClipCurr=model.iClipCurr;
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
                %strctMovieInfo = fnReadVideoInfo(clipFNAbs{iClipCurr});
                optionalVideoInfo = self.checkThatClipExistsThenReadVideoInfo(iClipCurr) ;
                if isempty(optionalVideoInfo) ,
                  return
                end
                strctMovieInfo = optionalVideoInfo{1} ;
                strctID = load(sClassifiersFile);  % Load the classifiers file.
                set(self,'pointer','watch');
                drawnow('expose');  drawnow('update');
                fnTuneBackgroundFromScratch(strctMovieInfo, strctID, sTuningDir);
                set(self,'pointer','arrow');
                drawnow('expose');  drawnow('update');
              end
            else
              %clipFNAbsThis=clipFNAbs{iClipCurr};
              %strctMovieInfo = fnReadVideoInfo(clipFNAbsThis);
              optionalVideoInfo = self.checkThatClipExistsThenReadVideoInfo(iClipCurr) ;
              if isempty(optionalVideoInfo) ,
                return
              end
              strctMovieInfo = optionalVideoInfo{1} ;              
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
              return
            end

            % Finally, run tracking...
            fnTrack(self);
        end  % function
        
        function update_(self)
            % Update the processing mode enablement
            isLinuxAndClusterExecutablePresent = islinux() && MotrUserInterface.isClusterExecutablePresent() ;
            set(self.localModeRadiobutton_ ,'Enable',onIff(isLinuxAndClusterExecutablePresent));
            set(self.clusterModeRadiobutton_ ,'Enable',onIff(isLinuxAndClusterExecutablePresent));            

            % Get a few things out of the model, or use fallback values if
            % no model
            if isempty(self.model_)
                model=[];
                expSelected = false ;
                expDirName = [] ;
                parameterFileNameAbs = [] ;
                clusterMode=false;
            else
                model = self.model_ ;
                expSelected=model.expSelected;
                expDirName=model.expDirName;                
                parameterFileNameAbs = model.getParameterFileNameAbs() ;
                clusterMode=model.clusterMode;
            end
            
            % Set the processing mode radiobuttons
            set(self.localModeRadiobutton_  , 'Value', ~clusterMode) ;
            set(self.clusterModeRadiobutton_, 'Value',  clusterMode) ;
            
            % if no experiment, set things to default values and exit
            if ~expSelected ,
                set(self.experimentDirNameEdit_, 'String', 'No experiment selected');
                set(self.experimentDirNameEdit_, 'FontAngle', 'italic');
                set(self.parameterFileNameEdit_, 'String', 'None');
                set(self.parameterFileNameEdit_, 'FontAngle', 'italic');
                set(self.singleMouseClipsListbox_, 'Value', 1);
                set(self.singleMouseClipsListbox_, 'String', {''});
                set(self.experimentClipsListbox_, 'Value', 1);
                set(self.experimentClipsListbox_, 'String', {''});
                C = MotrUserInterface.fnGetColorCode() ;
                set(self.trainButton_, 'BackgroundColor', C(1,:));
                set(self.trackButton_, 'BackgroundColor', C(1,:));
                set(self.trainButton_, 'Enable', 'off');
                set(self.trackButton_, 'Enable', 'off');
                set(self.resultsButton_, 'Enable', 'off');
                set(self.changeParameterFileNameButton_, 'Enable', 'off');
                set(self.singleMouseClipsListbox_, 'Enable', 'off');
                set(self.experimentClipsListbox_, 'Enable', 'off');
                return
            end
            
            % if get here, there's an experiment

            % update the experiment name
            set(self.experimentDirNameEdit_, 'String', expDirName);
            set(self.experimentDirNameEdit_, 'FontAngle', 'normal');
            set(self.parameterFileNameEdit_, 'String', parameterFileNameAbs);
            set(self.parameterFileNameEdit_, 'FontAngle', 'normal');
            
            % get stuff out of model
            clipFNAbs = model.clipFNAbs ;
            clipSMFNAbs = model.clipSMFNAbs ;
            iClipCurr = model.iClipCurr ;
            iClipSMCurr = model.iClipSMCurr ;
            trainStatus = model.trainStatus ;
            trackStatus = model.trackStatus ;
                
            % Set Train and Track button enablement
            set(self.changeParameterFileNameButton_, 'Enable', 'on');
            set(self.trainButton_, 'Enable', 'on');
            if trainStatus>=4
              set(self.trackButton_, 'Enable', 'on');
            else
              set(self.trackButton_, 'Enable', 'off');
            end

            % update the single-mouse clips
            set(self.singleMouseClipsListbox_, 'Enable', 'on');
            set(self.singleMouseClipsListbox_, 'String', clipSMFNAbs);
            set(self.singleMouseClipsListbox_, 'Value', max(1,iClipSMCurr));

            % generate the clip listbox items by coloring the clip names
            % appropriately
            clipListString=MotrUserInterface.colorizeClips(clipFNAbs,trackStatus,iClipCurr);

            % update the clip listbox
            set(self.experimentClipsListbox_, 'Enable', 'on');
            set(self.experimentClipsListbox_, 'String', clipListString);
            set(self.experimentClipsListbox_, 'Value', max(1,iClipCurr));  % setting this to -1 causes listbox to not be rendered, sometimes

            % update the enablement of the Results button
            if length(clipFNAbs)>0 && trackStatus(iClipCurr)==4  %#ok
                set(self.resultsButton_, 'Enable', 'on');
            else
                set(self.resultsButton_, 'Enable', 'off');
            end

            % get the color code
            C = MotrUserInterface.fnGetColorCode();

            % update the training button color
            set(self.trainButton_, 'BackgroundColor', C(trainStatus,:));

            % update the tracking button color
            if isempty(clipFNAbs)
                trackStatusOverall=1;
            else
                trackStatusOverall=max(trackStatus);
            end
            set(self.trackButton_, 'BackgroundColor', ...
                                   C(trackStatusOverall,:));

            % Update the processing mode widgets
            clusterMode=model.clusterMode;
            set(self.localModeRadiobutton_ , 'Value', ~clusterMode);
            set(self.clusterModeRadiobutton_, 'Value',  clusterMode);                
        end  % function
        
        function changeParameterFileNameButtonActuated(self)
            model = self.model_ ;
            originalParameterFileNameAbs = model.getParameterFileNameAbs() ;            
            originalParameterDirNameAbs = fileparts(originalParameterFileNameAbs) ;
            [fileName,pathName] = ...
                uigetfile({'*.xml', 'XML Files (*.xml)'; ...
                           '*.*', 'All Files' }, ...
                          'Change Parameter File...', ...
                          originalParameterDirNameAbs);
            if fileName==0 , % means user hit Cancel button
                return
            end
            parameterFileNameAbs = fullfile(pathName,fileName) ;
            err = model.setParameterFileNameAbs(parameterFileNameAbs) ;          
            if ~isempty(err) ,
                errordlg(err.message,'Error','modal');
            end
        end
        
        function chooseExperimentDirNameButtonActuated(self)
            % get the userdata, see if there's a current experiment
            model = self.model_ ;
            wasExpSelectedAlready = model.expSelected ;
            originalExpDirName = model.expDirName ;
            
            % get the listbox selection
            %handles=guidata(hFig);
            %iList = get(handles.hChooseExp, 'Value');

            newExpDirName = uigetdir('.', ...
                                     'Choose directory of an experiment');
            if newExpDirName==0 ,  % means user hit Cancel button
              fnUpdateGUIStatus(self);  % doesn't seem necessary...
              return
            end
            %sExp = fnConvertToAbsolutePath(sExp);
            if wasExpSelectedAlready ,
                if isequal(newExpDirName, originalExpDirName) ,
                    % this means they selected the current experiment
                    fnUpdateGUIStatus(self);  % is this necessary?
                    return
                end
            end
            setCurrentExperiment(self, newExpDirName);
        end
    
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
            model=get(self,'userdata');
            %expDirName=model.expDirName;
            %clipFNAbs=model.clipFNAbs;
            %iClipCurr=model.iClipCurr;
            %absoluteFileNameOfSelectedClip = clipFNAbs{iClipCurr} ;
            
            % Make sure we can find the clip file
            iClipCurr=model.iClipCurr;
            optionalVideoInfo = self.checkThatClipExistsThenReadVideoInfo(iClipCurr) ;
            if isempty(optionalVideoInfo) ,
                return
            end
            
            % Sort out the names of various things stored in the experiment
            % directory.
            absoluteFileNameOfSelectedClip = model.clipFNAbs{iClipCurr} ;
            [dummy, clipBaseName] = fileparts(absoluteFileNameOfSelectedClip);  %#ok
            expDirName=model.expDirName;
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
            
            % Finally, launch the results editor
            launchResultsEditor(jobsDirName, ...
                                resultsDirName, ...
                                tuningDirName, ...
                                classifiersFN, ...
                                absoluteFileNameOfSelectedClip, ...
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
               self.model_.fnDeleteClip(self,val);
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

        function optionalVideoInfo = checkThatClipExistsThenReadVideoInfo(self, indexOfClip)          
          % Try to find the file if it has gone missing
          model = get(self,'userdata') ;
          originalAbsoluteFileNameOfClip = model.clipFNAbs{indexOfClip} ;
          [doesFileExist, ~, absoluteFileNameOfClip, callbackError] = ...
            MotrUserInterface.checkIfFileExistsAndAskUserToLocateIfNot( ...
              originalAbsoluteFileNameOfClip, ...
              {'*.avi', 'Microsoft AVI Videos (*.avi)'; ...
               '*.mj2', 'Motion JPEG 2000 Videos (*.mj2)'; ...
               '*.seq', 'Norpix Sequence Videos (*.seq)'; ...
               '*.ufmf', 'Micro Fly Movie Format Videos (*.ufmf)'; ...
               '*.*', 'All Files' }, ...
              @(absoluteFileNameOfClipFile)(model.fnReplaceClipFileName(indexOfClip, absoluteFileNameOfClipFile)) ) ;
          if ~doesFileExist || ~isempty(callbackError) ,
            optionalVideoInfo = cell(1,0) ;
            return
          end
          % At this point, absoluteFileNameOfClip existed the last time we checked
          videoInfo = fnReadVideoInfo(absoluteFileNameOfClip);
          optionalVideoInfo = { videoInfo } ;
        end  % function

        function optionalVideoInfo = checkThatSingleMouseClipExistsThenReadVideoInfo(self, indexOfSingleMouseClip)          
          % Try to find the file if it has gone missing
          model = get(self,'userdata') ;
          originalAbsoluteFileNameOfClip = model.clipSMFNAbs{indexOfSingleMouseClip} ;
          [doesFileExist, ~, absoluteFileNameOfClip, callbackError] = ...
            MotrUserInterface.checkIfFileExistsAndAskUserToLocateIfNot( ...
              originalAbsoluteFileNameOfClip, ...
              {'*.avi', 'Microsoft AVI Videos (*.avi)'; ...
               '*.mj2', 'Motion JPEG 2000 Videos (*.mj2)'; ...
               '*.seq', 'Norpix Sequence Videos (*.seq)'; ...
               '*.ufmf', 'Micro Fly Movie Format Videos (*.ufmf)'; ...
               '*.*', 'All Files' }, ...
              @(absoluteFileNameOfClipFile)(model.fnReplaceSingleMouseClipFileName(indexOfSingleMouseClip, absoluteFileNameOfClipFile)) ) ;
          if ~doesFileExist || ~isempty(callbackError) ,
            optionalVideoInfo = cell(1,0) ;
            return
          end
          % At this point, absoluteFileNameOfClip existed the last time we checked
          videoInfo = fnReadVideoInfo(absoluteFileNameOfClip);
          optionalVideoInfo = { videoInfo } ;
        end  % function

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
            motrRootDirNameAbs = motrRootDirName() ;

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
        
        function [doesFileExist, didUserLocateFileManually, absoluteFileName, callbackError] = ...
          checkIfFileExistsAndAskUserToLocateIfNot(originalAbsoluteFileName, ...
                                                   filter, ...
                                                   callbackForNewFileName)                                                 
            % Make sure we can find the file
            if exist(originalAbsoluteFileName,'file') ,
                % Easy case
                doesFileExist = true ;
                didUserLocateFileManually = false ;
                absoluteFileName = originalAbsoluteFileName ;
            else
                [~, baseName, ext] = fileparts(originalAbsoluteFileName);
                fileName = [baseName ext] ;
                answer = questdlg(sprintf('The file %s is missing.  Would you like to locate it?', fileName) , ...
                                  'Missing file', ...
                                  'Yes', 'No', 'Cancel', ...
                                  'Cancel');
                if isequal(answer,'Yes') ,
                    % User wants to locate the missing file
                    
                    % If possible, sort the filter entries to put the file
                    % type of originalAbsoluteFileName at the top.
                    resortedFilter = MotrUserInterface.sortFilterEntriesToPutGivenExtensionFirst(filter, ext);                    
                    
                    % Put up the file picker dialog
                    [filename,pathname] = ...
                        uigetfile(resortedFilter, ...
                                  'Locate File...', ...
                                  originalAbsoluteFileName);
                    if ischar(filename) ,
                        % User picked a new file
                        absoluteFileName = fullfile(pathname,filename) ;
                        doesFileExist = exist(absoluteFileName,'file') ;
                        didUserLocateFileManually = true ;
                    else
                        % User cancelled out of the file picker
                        doesFileExist = false ;
                        didUserLocateFileManually = false ;
                        absoluteFileName = originalAbsoluteFileName ;
                    end
                else
                    % User declined to locate the missing file
                    doesFileExist = false ;
                    didUserLocateFileManually = false ;
                    absoluteFileName = originalAbsoluteFileName ;
                end
            end
        
            % Deal with success/failure
            if doesFileExist ,
                if didUserLocateFileManually ,
                    % Do whatever might need doing with the new file name
                    callbackError = callbackForNewFileName(absoluteFileName) ;
                    if ~isempty(callbackError) ,
                        errordlg(sprintf('There was a problem with the new file: %s',callbackError.message), ...
                                 'Error','modal');
                    end
                else
                    callbackError = [] ;
                end
            else
                % Clip file doesn't exist
                callbackError = [] ;
                if didUserLocateFileManually ,
                    % Strange case: The user picked a file, but it
                    % failed to exist when checked.
                    [~, baseName, ext] = fileparts(absoluteFileName);
                    fileName = [baseName ext] ;
                    uiwait(errordlg(sprintf('Unable to find file %s.',fileName), ...
                                    'Error','modal'));
                else
                    % The file didn't exist, and the user declined to
                    % locate one, or cancelled out of the file picker.
                    % In this case, no need to throw up an error dialog.
                end
            end

        end  % function
        
        function sortedFilter = sortFilterEntriesToPutGivenExtensionFirst(filter, extension)
          % filter should be something like       
          % {'*.avi', 'Microsoft AVI Videos (*.avi)'; ...
          %  '*.mj2', 'Motion JPEG 2000 Videos (*.mj2)'; ...
          %  '*.seq', 'Norpix Sequence Videos (*.seq)'; ...
          %  '*.ufmf', 'Micro Fly Movie Format Videos (*.ufmf)'; ...
          %  '*.*', 'All Files' }
          %
          % extension should be something like '.seq'
          %
          % If difficulties are encountered, we just return the unaltered
          % filter as sortedFilter.
          
          wildcards = filter(:,1) ;          
          function isMatch = doesWildcardMatchExtension(wildcard, extension)
            isMatch = strncmp(fliplr(wildcard),fliplr(extension),length(extension)) ;
          end          
          extensions = repmat({extension}, size(wildcards)) ;
          isMatch = cellfun(@doesWildcardMatchExtension, wildcards, extensions) ;
          if any(isMatch) ,
            matchIndex = find(isMatch,1) ;
            nRows = size(filter,1) ;
            originalOrder = 1:nRows ;
            newOrder = [matchIndex setdiff(originalOrder,matchIndex) ] ;
            sortedFilter = filter(newOrder,:) ;
          else
            sortedFilter = filter ;
          end
          
        end  % function
        
    end  % static methods
    
end  % classdef
