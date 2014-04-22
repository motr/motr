function mouseButtonReleasedAfterEllipseHandleDrag(self,hObject,eventdata)  %#ok
  self.motionobj = [];
  % unset the callbacks for the drag
  set(self.fig,'WindowButtonMotionFcn', ...
               @(src,event)(self.updatePointer()));
  set(self.fig,'WindowButtonUpFcn',[]);
  % mark the open file as needing saving
  self.needssaving=1;
  self.updateControlVisibilityAndEnablement();
  self.updateWindowTitle();  
end  % method
