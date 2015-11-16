function success=testReadVideo()

thisFileNameAbs=mfilename('fullpath');  % without .m, for some reason
thisDirNameAbs=fileparts(thisFileNameAbs)  %#ok<NOPRT>
%thisFunctionName=fileNameRelFromAbs(thisFileNameAbs);
fileNamesLocal = cell(0,1) ;
d=dir(fullfile(thisDirNameAbs,'*.seq'));
fileNamesLocal=[fileNamesLocal;{d.name}'];
d=dir(fullfile(thisDirNameAbs,'*.mj2'));
fileNamesLocal=[fileNamesLocal;{d.name}'];
d=dir(fullfile(thisDirNameAbs,'*.avi'));
fileNamesLocal=[fileNamesLocal;{d.name}'];
d=dir(fullfile(thisDirNameAbs,'*.ufmf'));
fileNamesLocal=[fileNamesLocal;{d.name}'];
fileNamesLocal %#ok<NOPRT>
fileNamesAbs=cellfun(@(fileNameLocal)(fullfile(thisDirNameAbs,fileNameLocal)), ...
                     fileNamesLocal, ...
                     'UniformOutput',false)               %#ok<NOPRT>

nFiles=length(fileNamesAbs);
for i=1:nFiles ,
  fileName=fileNamesAbs{i};
  vidInfo=fnReadVideoInfo(fileName)  %#ok<NOPRT>
  nFrames=vidInfo.m_iNumFrames;
  nFramesToRead=min(nFrames,100);
  % Read all frames at once, to test fnReadFramesFromVideo()
  vid=fnReadFramesFromVideo(vidInfo,1:nFramesToRead);
  fig=showFrames(vid);
  delete(fig);
  % Read one frame at a time, to test fnReadFrameFromVideo()
  vid2=zeros(vidInfo.m_iHeight,vidInfo.m_iWidth,nFramesToRead,'uint8');
  for iFrame=1:nFramesToRead
    thisFrame=fnReadFrameFromVideo(vidInfo,iFrame);
    vid2(:,:,iFrame)=thisFrame;
  end
  fig=showFrames(vid2);
  delete(fig);
end

success=true;

end  % function
