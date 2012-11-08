function Output = fnReadFramesFromVideo(strctVideoInfo, aiFrames)
% Wrapper to read frames from video files.
%
%
%Copyright (c) 2008 Shay Ohayon, California Institute of Technology.
% This file is a part of a free software. you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation (see GPL.txt)

%global g_strVideoWrapper
strFileName = strctVideoInfo.m_strFileName;

[dummy,dummy, strExt] = fileparts(strFileName);  %#ok
if strcmpi(strExt,'.seq')
    Output = fnReadFramesFromSeq(strctVideoInfo, aiFrames);
    return;
end;

if strcmpi(strExt,'.avi') || strcmpi(strExt,'.wmv')
   vidObj = mmreader(strFileName);
   Output = zeros(vidObj.Height,vidObj.Width,length(aiFrames),'uint8');
   for i=1:length(aiFrames)
      a3fFrameThis=vidObj.read(aiFrames(i));  % w x h x 3
      Output(:,:,i) = uint8(mean(double(a3fFrameThis),3));
   end
   return;
end;

error('fnReadFramesFromVideo:unsupportedFileType', ...
      'Unable to read %s files.', ...
      strExt);

% if isempty(g_strVideoWrapper) || strcmpi(g_strVideoWrapper,'matlab')
%     strctTmp = aviread(strFileName, aiFrames);
%     Output=reshape(cat(3,strctTmp.cdata), [size(strctTmp(1).cdata), length(strctTmp)]);
%     if bForceBW &&  size(Output,4) > 1
%         Output = squeeze(Output(:,:,1,:));
%     end;
% elseif strcmpi(g_strVideoWrapper,'directx')
%     if all(aiFrames(2:end)-aiFrames(1:end-1) == 1)
%         Handle = DirectXInterface('Open',strFileName);
%         [iNumFrames, iHeight ,iWidth] = DirectXInterface('Info',Handle);
%         DirectXInterface('Start',Handle);
%         DirectXInterface('Seek',Handle,aiFrames(1));
%         Output = zeros(iHeight,iWidth, length(aiFrames));
%         for iFrameIter=1:length(aiFrames)
%             OutputTmp = DirectXInterface('GetMovieFrame',Handle);
%             if bForceBW && size(OutputTmp,3) > 1
%                 OutputTmp = OutputTmp(:,:,1);
%             end;
%             Output(:,:,iFrameIter) = OutputTmp;
%         end;
%         DirectXInterface('Stop',Handle);
%         DirectXInterface('Close',Handle);
%     else
%         Handle = DirectXInterface('Open',strFileName);
% 
%         [iNumFrames, iHeight ,iWidth] = DirectXInterface('Info',Handle);
%         DirectXInterface('Start',Handle);
%         Output = zeros(iHeight,iWidth, length(aiFrames));
% 
%         for iFrameIter=1:length(aiFrames)
%             DirectXInterface('Seek',Handle,aiFrames(iFrameIter));
%             OutputTmp = DirectXInterface('GetMovieFrame',Handle);
%             if bForceBW && size(OutputTmp,3) > 1
%                 OutputTmp = OutputTmp(:,:,1);
%             end;
%             Output(:,:,iFrameIter) = OutputTmp;
%         end;
%     end;
% elseif strcmpi(g_strVideoWrapper,'avifile')
%     hHandle = AviFileInterfaceMex('Open',strFileName);
%     strcInfo = AviFileInterfaceMex('Info',hHandle);
%     Output = zeros(strcInfo.Height,strcInfo.Width, length(aiFrames),'uint8');
%    if all(aiFrames(2:end)-aiFrames(1:end-1) == 1)
%       AviFileInterfaceMex('Seek',hHandle,aiFrames(1));
%         for k=1:length(aiFrames)
%             img = AviFileInterfaceMex('GetFrame',hHandle);
%             Output(:,:,k) = img(:,:,1);
%          end;
%    else
%         for k=1:length(aiFrames)
%             AviFileInterfaceMex('Seek',hHandle,aiFrames(k));
%             img = AviFileInterfaceMex('GetFrame',hHandle);
%             Output(:,:,k) = img(:,:,1);
%         end;
%    end;
%    AviFileInterfaceMex('Close',hHandle);
% elseif strcmpi(g_strVideoWrapper,'videoio')
%     vr = videoReader(strFileName,'preciseFrames',-1);
%     info = getinfo(vr);
%     Output = zeros(info.height,info.width, length(aiFrames),'uint8');
%     % If frames are sequential, don't seek after each read...
%     if all(aiFrames(2:end)-aiFrames(1:end-1) == 1)
%         seek(vr,aiFrames(1));
%         for k=1:length(aiFrames)
%             img = getframe(vr);
%             Output(:,:,k) = img(:,:,1);
%             next(vr);
%         end;
%     else
%         for k=1:length(aiFrames)
%             seek(vr,aiFrames(k));
%             img = getframe(vr);
%             Output(:,:,k) = img(:,:,1);
%         end;
%     end;
%     close(vr);
% end;
