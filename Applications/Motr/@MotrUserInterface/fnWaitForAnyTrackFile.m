function fnWaitForAnyTrackFile(self, expDirName, fnClip)

nClip = length(fnClip);
bExist = false;
while true
  for i=1:nClip
    if MotrModel.fnExistTrackFile(expDirName, fnClip{i})
      %fnUpdateStatus(handles, 'expClipStatus', iClip, 4);
      fnSetClipTrackStatusCode(self, i, 4);  % means done
      bExist = true;
    end
  end
  if bExist
    return;
  end
  pause(10);  % Hope this is OK.  -- ALT, 2012-02-21
end
