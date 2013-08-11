classdef AutoTrackSettingsModel < handle
  
  properties (SetAccess=private)
    % buttondownfcn
    %currentFrameROI  % the image, limited to the ROI, for the current frame
%     nr  % number of rows in the ROI
%     nc  % number of cols in the ROI
    r0  % the lowest-index row of the ROI in the full frame
    r1  % the highest-index row of the ROI in the full frame
    c0  % the lowest-index col of the ROI in the full frame
    c1  % the highest-index col of the ROI in the full frame
    roiImageGH  % the image HG object, showing the ROI, with background blacked out (or whited out, depending)
    %perimeterLine  % the line showing the boundary between foreground and background
    fillRegionBoundLine  % the line showing the current fill region
    fillRegionAnchorCorner  % the corner of the fill region that is fixed during the drag
    fillRegionPointerCorner  % the corner of the fill region under the pointer during the drag
    
    backgroundImage
    backgroundThreshold
    foregroundSign
    trackingROIHalfWidth
    backgroundColor
    iFlies
    iFrame
    trx
    currentFrame
    nRows  % number of rows in the full frame (not the tracking ROI)
    nCols  % number of cols in the full frame (not the tracking ROI)
    
    isInEyedropperMode
  end  % properties
  
  methods
    % ---------------------------------------------------------------------
    function self=AutoTrackSettingsModel(catalyticController)
      self.backgroundImage=catalyticController.getBackgroundImage();
      self.backgroundThreshold=catalyticController.getBackgroundThreshold();
      self.foregroundSign=catalyticController.getForegroundSign();
      self.trackingROIHalfWidth=catalyticController.getMaximumJump();
      self.backgroundColor=128;  
        % would be nice to change this back to the median of the current frame ROI
      self.iFlies = catalyticController.getAutoTrackFly();
      self.iFrame = catalyticController.getAutoTrackFrame();
      self.trx=catalyticController.getTrx();
      self.currentFrame=catalyticController.getCurrentFrame();
      self.nRows=catalyticController.getNRows();
      self.nCols=catalyticController.getNCols();
      self.isInEyedropperMode=false;
      self.syncROIBounds();
    end
    
    
    % ---------------------------------------------------------------------
    function incrementBackgroundThreshold(self,delta)
      self.backgroundThreshold=self.backgroundThreshold+delta;
      %self.syncROIBounds();
    end
    
    
    % ---------------------------------------------------------------------
    function setForegroundSign(self, newValue)
      self.foregroundSign=newValue;
    end  
    
    
    % ---------------------------------------------------------------------
    function setBackgroundColorToSample(self,x,y)
      self.backgroundColor=self.currentFrame(y,x);
    end
    
        
    % ---------------------------------------------------------------------
    function doBackgroundFill(self)
      if isempty(self.fillRegionAnchorCorner) || isempty(self.fillRegionPointerCorner)
        return
      end
      
      r0 = min(self.fillRegionAnchorCorner(2),self.fillRegionPointerCorner(2));
      r1 = max(self.fillRegionAnchorCorner(2),self.fillRegionPointerCorner(2));
      c0 = min(self.fillRegionAnchorCorner(1),self.fillRegionPointerCorner(1));
      c1 = max(self.fillRegionAnchorCorner(1),self.fillRegionPointerCorner(1));
      r0 = max(round(r0),1);
      r1 = min(round(r1),self.nRows);
      c0 = max(round(c0),1);
      c1 = min(round(c1),self.nCols);
      bgcurr=self.backgroundImage;
      bgcurr(r0:r1,c0:c1) = self.backgroundColor;
      self.backgroundImage=bgcurr;
    end
    
    
    
    % ---------------------------------------------------------------------
    function setFillRegionCorners(self,fillRegionAnchorCorner,fillRegionPointerCorner)
      self.fillRegionAnchorCorner = fillRegionAnchorCorner;
      self.fillRegionPointerCorner = fillRegionPointerCorner;
    end
    
    
    % ---------------------------------------------------------------------
    function setIsInEyedropperMode(self,newValue)
      self.isInEyedropperMode = newValue;
    end
    
    
    % ---------------------------------------------------------------------
    function forgetFillRegionCorners(self)
      self.fillRegionAnchorCorner=[];
      self.fillRegionPointerCorner=[];
    end
        
    
    % ---------------------------------------------------------------------
    function incrementTrackingROIHalfWidth(self, delta)  %#ok
      self.trackingROIHalfWidth=self.trackingROIHalfWidth+delta;
      self.syncROIBounds();
    end
    
  end  % methods
    
  % -----------------------------------------------------------------------
  methods (Access=private)
    % --------------------------------------------------------------------
    function syncROIBounds(self)
      [self.r0,self.r1,self.c0,self.c1] = ...
        computeTrackingROI(self.trx, ...
                           self.iFlies, ...
                           self.iFrame, ...
                           self.nRows, ...
                           self.nCols, ...
                           self.trackingROIHalfWidth);
    end   
  end  % private methods
  
end  % classdef
