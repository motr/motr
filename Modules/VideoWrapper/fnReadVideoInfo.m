function strctVideoInfo = fnReadVideoInfo(strFileName)
% Wrapper to read frames from video files.
% 
%
%Copyright (c) 2008 Shay Ohayon, California Institute of Technology. 
% This file is a part of a free software. you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation (see GPL.txt)

strctVideoInfo = MotrVideo(strFileName) ;  % not really a struct anymore...

% [dummy,baseName,strExt] = fileparts(strFileName);  %#ok
% if strcmpi(strExt,'.seq') ,
%   strctVideoInfo = fnReadSeqInfo(strFileName);
%   strctVideoInfo.m_fFileTypeIndex = 0;  % magic number
% elseif strcmpi(strExt,'.ufmf') ,
%   header = ufmf_read_header(strFileName);  
%   strctVideoInfo.m_strFileName = strFileName;  
%   ts = header.timestamps ;
%   fps = (length(ts)-1)/(ts(end)-ts(1)) ;
%   strctVideoInfo.m_fFPS = fps;
%   strctVideoInfo.m_iNumFrames = header.nframes;
%   strctVideoInfo.m_iHeight = header.nr;
%   strctVideoInfo.m_iWidth = header.nc;
%   strctVideoInfo.m_afTimestamp = ts ;  % s  
%   strctVideoInfo.m_sUfmfHeader = header ;
%   strctVideoInfo.m_fFileTypeIndex = 1;  % magic number
% else
%   vidObj=VideoReader(strFileName);
%   strctVideoInfo.m_strFileName = strFileName;
%   strctVideoInfo.m_fFPS = vidObj.FrameRate;
%   strctVideoInfo.m_iNumFrames = vidObj.NumberOfFrames;
%   strctVideoInfo.m_iHeight = vidObj.Height;
%   strctVideoInfo.m_iWidth = vidObj.Width;
%   strctVideoInfo.m_afTimestamp = ...
%     (1/strctVideoInfo.m_fFPS)*(0:(strctVideoInfo.m_iNumFrames-1));  % s
%   strctVideoInfo.m_vrVideoReader = vidObj ;
%   strctVideoInfo.m_fFileTypeIndex = inf;  % magic number
% end

end
