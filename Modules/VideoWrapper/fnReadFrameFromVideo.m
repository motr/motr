function Output = fnReadFrameFromVideo(strctVideoInfo, iFrame)
% Wrapper to read frames from video files.
%
%
%Copyright (c) 2008 Shay Ohayon, California Institute of Technology.
% This file is a part of a free software. you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation (see GPL.txt)

%global g_strVideoWrapper
strFileName = strctVideoInfo.m_strFileName;

bForceBW = 1;
[dummy,dummy, strExt] = fileparts(strFileName);  %#ok
if strcmpi(strExt,'.seq')
    Output = fnReadFrameFromSeq(strctVideoInfo, iFrame);
    if bForceBW && size(Output,3) > 1
        Output = Output(:,:,1);
    end;
elseif strcmpi(strExt,'.avi') || strcmpi(strExt,'.wmv')
   vidObj = mmreader(strFileName);
   a3fFrameThis=vidObj.read(iFrame);  % uint8, w x h x 3
   Output=uint8(mean(double(a3fFrameThis),3));  
else
    error('fnReadFrameFromVideo:unsupportedFileType', ...
          'Unable to read %s files.', ...
          strExt);
end

% if isempty(g_strVideoWrapper) || strcmpi(g_strVideoWrapper,'matlab')
%     strctTmp = aviread(strFileName, iFrame);
%     Output = strctTmp.cdata;
%     if bForceBW && size(Output,3) > 1
%         Output = Output(:,:,1);
%     end;
% elseif strcmpi(g_strVideoWrapper,'directx')
%     Handle = DirectXInterface('Open',strFileName);
%     DirectXInterface('Start',Handle);
%     DirectXInterface('Seek',Handle,round(iFrame));
%     Output = DirectXInterface('GetMovieFrame',Handle);
%     if bForceBW && size(Output,3) > 1
%         Output = Output(:,:,1);
%     end;
%     DirectXInterface('Stop',Handle);
%     DirectXInterface('Close',Handle);
% elseif strcmpi(g_strVideoWrapper,'dxavi')
%     [hdl, t] = dxAviOpenMex(strFileName);
%     inf.Width = t(1);
%     inf.Height = t(2);
%     inf.NumFrames = t(3);
%     pixmap = dxAviReadMex(hdl, iFrame);
%     Output = reshape(pixmap,[inf.Height,inf.Width,3]);
%     Output = Output(:,:,1);
%     dxAviCloseMex(hdl);
% elseif strcmpi(g_strVideoWrapper,'avifile')
%     hHandle = AviFileInterfaceMex('Open',strFileName);
%     %strcInfo = AviFileInterfaceMex('Info',hHandle);
%     AviFileInterfaceMex('Seek',hHandle,iFrame);
%     Output = AviFileInterfaceMex('GetFrame',hHandle);
%    if bForceBW && size(Output,3) > 1
%         Output = Output(:,:,1);
%     end;
%     AviFileInterfaceMex('Close',hHandle);
% elseif strcmpi(g_strVideoWrapper,'videoio')
%     vr = videoReader(strFileName,'preciseFrames',-1);
%     seek(vr,iFrame);
%     next(vr);
%     img = getframe(vr);
%     Output = img(:,:,1);
%     close(vr);
% end;
