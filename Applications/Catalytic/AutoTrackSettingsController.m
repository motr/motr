classdef AutoTrackSettingsController < handle
  
  properties
    catalyticController  % the parent CatalyticController
    model
    view    
  end  % properties
  
  methods
    % ---------------------------------------------------------------------
    function self=AutoTrackSettingsController(catalyticController)
      self.catalyticController=catalyticController;
      self.model=AutoTrackSettingsModel(catalyticController);
      self.view=AutoTrackSettingsView(self.model,self);
    end
    
    
    % ---------------------------------------------------------------------
    function thresholdPlusButtonTwiddled(self, hObject, eventdata)  %#ok
      % hObject    handle to thresholdPlusButton (see GCBO)
      % eventdata  reserved - to be defined in a future version of MATLAB
      % self    structure with self and user data (see GUIDATA)
      
      self.model.incrementBackgroundThreshold(1);
      self.view.updateBackgroundThresholdText();
      self.view.updateSegmentationPreview();
    end
    
    
    % ---------------------------------------------------------------------
    function thresholdMinusButtonTwiddled(self, hObject, eventdata)  %#ok
      % hObject    handle to thresholdMinusButton (see GCBO)
      % eventdata  reserved - to be defined in a future version of MATLAB
      % self    structure with self and user data (see GUIDATA)
      
      self.model.incrementBackgroundThreshold(-1);
      self.view.updateBackgroundThresholdText();
      self.view.updateSegmentationPreview();
    end
        
    
    % ---------------------------------------------------------------------
    function foregroundSignPopupTwiddled(self, source, event)  %#ok
      % hObject    handle to foregroundSignPopup (see GCBO)
      % eventdata  reserved - to be defined in a future version of MATLAB
      % self    structure with self and user data (see GUIDATA)
      
      % Hints: contents = get(hObject,'String') returns foregroundSignPopup contents as cell array
      %        contents{get(hObject,'Value')} returns selected item from foregroundSignPopup
      
      iSelection = get(source,'value');
      if iSelection == 1
        self.model.setForegroundSign(1);
      elseif iSelection == 2
        self.model.setForegroundSign(-1);
      else
        self.model.setForegroundSign(0);
      end
      self.view.updateSegmentationPreview();
    end
   
    
    
    % ---------------------------------------------------------------------
    function doneButtonTwiddled(self, hObject, eventdata)  %#ok
      self.catalyticController.setBackgroundImageForCurrentAutoTrack(self.model.backgroundImage);
      self.catalyticController.setBackgroundThreshold(self.model.backgroundThreshold);
      self.catalyticController.setMaximumJump(self.model.trackingROIHalfWidth);      
      self.catalyticController.setForegroundSign(self.model.foregroundSign);
      self.view.close();
    end
    
    
    
    % ---------------------------------------------------------------------
    function cancelButtonTwiddled(self, hObject, eventdata)  %#ok
      self.view.close()
    end
    
    
    
    % ---------------------------------------------------------------------
    function eyedropperRadiobuttonTwiddled(self, source, event)  %#ok
      value=get(source,'value');
      self.model.setIsInEyedropperMode(value);
    end
    
    
    
    % ---------------------------------------------------------------------
    function mouseButtonDownInMainAxes(self, hObject, eventdata)  %#ok
      %fprintf('Entered mouseButtonDownInMainAxes()\n');
      r=self.view.getMainAxesCurrentPoint();
      x = min(max(1,round(r(1))),self.model.nCols);
      y = min(max(1,round(r(2))),self.model.nRows);
      
      if self.model.isInEyedropperMode ,
        self.model.setBackgroundColorToSample(x,y);
        self.view.updateBackgroundColorImage();
      else
        self.view.startFillRegionDrag(x,y);
      end
    end
    
    
    % ---------------------------------------------------------------------
    function debugbuttonTwiddled(self, hObject, eventdata)  %#ok
      keyboard;
    end
    
    
    % ---------------------------------------------------------------------
    function fillbuttonTwiddled(self, hObject, eventdata)  %#ok
      self.model.doBackgroundFill();
      self.view.updateSegmentationPreview();
    end
    
    
    
    % ---------------------------------------------------------------------
    function mouseMoved(self,hObject,eventdata)  %#ok
      %if isfield(self,'choosepatch') || ~self.choosepatch
      %fprintf('Entered mouseMoved()\n');
      if isempty(self.view.choosepatch) || ~self.view.choosepatch
        return
      end
      %fprintf('Entered mouseMoved() inner sanctum\n');
      
      r=self.view.getMainAxesCurrentPoint();
      x=r(1);  y=r(2);
      x = min(max(self.model.c0,round(x)),self.model.c1);
      y = min(max(self.model.r0,round(y)),self.model.r1);
      self.view.continueFillRegionDrag(x,y);
    end
    
    
    % ---------------------------------------------------------------------
    function mouseButtonReleased(self,hObject,eventdata)  %#ok
      [fillRegionAnchorCorner,fillRegionPointerCorner]=self.view.endFillRegionDrag();
      self.model.setFillRegionCorners(fillRegionAnchorCorner,fillRegionPointerCorner)
    end
    
    
    % ---------------------------------------------------------------------
    function trackingROIHalfWidthPlusButtonTwiddled(self, hObject, eventdata)  %#ok
      %self.catalyticController.incrementMaximumJump(+1);
      self.model.incrementTrackingROIHalfWidth(1);
      self.view.updateTrackingROIHalfWidthText();
      self.view.updateSegmentationPreview();
    end
    
    
    
    % ---------------------------------------------------------------------
    function trackingROIHalfWidthMinusButtonTwiddled(self, hObject, eventdata)  %#ok
      self.model.incrementTrackingROIHalfWidth(-1);
      self.view.updateTrackingROIHalfWidthText();
      self.view.updateSegmentationPreview();
    end
    
    
    
    % ---------------------------------------------------------------------
    function closeRequested(self)  %#ok
      % do nothing: user must click done or cancel
      %delete(self.fig);
    end
    end
    
end  % classdef
