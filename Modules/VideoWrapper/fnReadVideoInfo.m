function strctVideoInfo = fnReadVideoInfo(strFileName)
% Wrapper to read frames from video files.
% 
%
%Copyright (c) 2008 Shay Ohayon, California Institute of Technology. 
% This file is a part of a free software. you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation (see GPL.txt)

%global g_strVideoWrapper

[dummy,dummy,strExt] = fileparts(strFileName);  %#ok
if strcmpi(strExt,'.seq')
  strctVideoInfo = fnReadSeqInfo(strFileName);
  return;
end;

if strcmpi(strExt,'.avi') || strcmpi(strExt,'.wmv')
  vidObj=mmreader(strFileName);
  strctVideoInfo.m_strFileName = strFileName;
  strctVideoInfo.m_fFPS = vidObj.FrameRate;
  strctVideoInfo.m_iNumFrames = vidObj.NumberOfFrames;
  strctVideoInfo.m_iHeight = vidObj.Height;
  strctVideoInfo.m_iWidth = vidObj.Width;
  strctVideoInfo.m_afTimestamp = ...
    (1/strctVideoInfo.m_fFPS)*(0:(strctVideoInfo.m_iNumFrames-1));  % s
  return;
end;

error('fnReadVideoInfo:unsupportedFileType', ...
      'Unable to get info on %s files.', ...
      strExt);

% try
%   if isempty(g_strVideoWrapper) || strcmpi(g_strVideoWrapper,'matlab') || ...
%       strcmpi(g_strVideoWrapper,'directx') || strcmpi(g_strVideoWrapper,'dxavi')
%     strctTmp = aviinfo(strFileName);
%     strctVideoInfo.m_strFileName = strFileName;
%     strctVideoInfo.m_iNumFrames = strctTmp.NumFrames;
%     strctVideoInfo.m_iHeight = strctTmp.Height;
%     strctVideoInfo.m_iWidth = strctTmp.Width;
%     strctVideoInfo.m_fFPS = strctTmp.FramesPerSecond;
%   elseif strcmpi(g_strVideoWrapper,'avifile')
%     hHandle = AviFileInterfaceMex('Open',strFileName);
%     strcInfo = AviFileInterfaceMex('Info',hHandle);
%     AviFileInterfaceMex('Close',hHandle);
%     strctVideoInfo.m_strFileName = strFileName;
%     strctVideoInfo.m_iNumFrames = strcInfo.NumFrames;
%     strctVideoInfo.m_iHeight = strcInfo.Height;
%     strctVideoInfo.m_iWidth = strcInfo.Width;
%     strctVideoInfo.m_fFPS = 0;
%   else
%     % use VideoIO
%     vr = videoReader(strFileName);
%     info = getinfo(vr);
%     strctVideoInfo.m_strFileName = strFileName;
%     strctVideoInfo.m_iNumFrames = info.numFrames;
%     strctVideoInfo.m_iHeight = info.height;
%     strctVideoInfo.m_iWidth = info.width;
%     strctVideoInfo.m_fFPS = info.fps;
%     close(vr);
%   end;
% catch
%   msgbox('Video reading failed!');
%   strctVideoInfo = [];
%   return;
% end;
% 
% if ~isfield(strctVideoInfo, 'm_afTimestamp')
%   strctVideoInfo.m_afTimestamp = (0:(strctVideoInfo.m_iNumFrames-1))/strctVideoInfo.m_fFPS;
% end
