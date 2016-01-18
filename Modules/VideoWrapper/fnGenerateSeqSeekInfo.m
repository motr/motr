function [aiSeekPos, afTimestamp] = fnGenerateSeqSeekInfo(strctMovInfo, iNumFrames)
aiFrameOffset = zeros(1, iNumFrames);
  % The offset of each frame within the file.  Note that this is the offset
  % of the 4-byte frame header that gives info about how long the frame
  % is.  For JPEG-compressed files, this is _not_ the offset of the frame 
  % data itself.
afTimestamp = zeros(1, iNumFrames);

hFileID = fopen(strctMovInfo.m_strFileName);
%fseek(hFileID, aiSeekPos(1),'bof');
if iNumFrames > 1000
    fprintf('Generating seek info for %d frames, please wait...\n', iNumFrames);
end;

if ( strctMovInfo.m_iCompressionFormat == 0 && ...
     (strctMovInfo.m_iImageFormat == 100 || strctMovInfo.m_iImageFormat == 200) )
    % uncompressed, and either monochrome or BGR color
    aiFrameOffset = 1024 + strctMovInfo.m_iFileMetadataSize + ...
                (0:iNumFrames)*strctMovInfo.m_iTrueImageSize;
    % Read timestamp info...
    for iIter = 0:iNumFrames-1
        fseek(hFileID,1024+iIter*strctMovInfo.m_iTrueImageSize+strctMovInfo.m_iImageSizeBytes,'bof');
        iA = fread(hFileID,1,'uint32');
        iB = fread(hFileID,1,'uint16');
        afTimestamp(iIter+1) =  double(iA)+ double(iB)/1000;
    end
    aiSeekPos=aiFrameOffset;  % for uncompressed frames, there is no frame header
elseif  ( strctMovInfo.m_iCompressionFormat == 1 && ...
          (strctMovInfo.m_iImageFormat == 100 || strctMovInfo.m_iImageFormat == 200) )
    % jpeg compressed, and either monochrome or BGR color
    aiFrameOffset(1) = 1024 + strctMovInfo.m_iFileMetadataSize;
    iFrameFooterLength = fnJpegSeqFrameFooterSize(strctMovInfo);
    % Compressed seq
    for iIter = 0:iNumFrames-1
        if mod(iIter,10000) == 0
            fprintf('Passed frame %d\n',iIter);
        end;
        fseek(hFileID,aiFrameOffset(iIter+1),'bof');
        iCurrImageSizeBytes = fread(hFileID,1,'uint32')-4;
          % read the frame header, which contains the length of the frame
          % data.  N.B.: On disk, this includes the length of the frame header (4
          % bytes).  The JPEG frame data itself is shorter by 4 bytes, so 
          % we subtract 4.
        if isempty(iCurrImageSizeBytes)
            aiFrameOffset = aiFrameOffset(1:iIter-1);
            afTimestamp = afTimestamp(1:iIter-1);
            aiSeekPos = aiFrameOffset + 4; 
            return;
        end
        fseek(hFileID,iCurrImageSizeBytes,'cof');  % skip the image data
        iA = fread(hFileID,1,'uint32');  % seconds part of frame timestamp
        iB = fread(hFileID,1,'uint16');  % milliseonds part of frame timestamp
        if isempty(iB) || isempty(iA)
            aiFrameOffset = aiFrameOffset(1:iIter-1);
            afTimestamp = afTimestamp(1:iIter-1);
            aiSeekPos = aiFrameOffset + 4; 
            return;
        end
        afTimestamp(iIter+1) =  double(iA)+ double(iB)/1000;
        if iIter ~= iNumFrames-1
            aiFrameOffset(iIter+2) = ...
                aiFrameOffset(iIter+1) + 4 + iCurrImageSizeBytes + ...
                iFrameFooterLength + strctMovInfo.m_iFrameMetadataSize;
        end
    end
        
    aiSeekPos = aiFrameOffset + 4; 
      % We want the index to be the start of the frame data proper,
      % skipping the 4-byte frame header
else
    error('motr:cantReadThisFlavorOfSeq', ...
          sprintf('Unable to read a .seq file with this imageFormat (%d) and this compressionFormat (%d)', ...
                  strctMovInfo.m_iImageFormat,strctMovInfo.m_iCompressionFormat));  %#ok
end
fprintf('Done!\n');
fclose(hFileID);
return;



% function bNewFileType = fnNewSEQFileType(strFileName)
% % The direct method.. try to parse the JPG header.
% % if it fails, it means we jumped too much!
% hFileID = fopen(strFileName);
% fseek(hFileID,1024,'bof');
% iFirstFrameSizeInBytes = fread(hFileID,1,'uint32')-4;
% %fseek(hFileID,iFirstFrameSizeInBytes,'cof');
% %iADummy = fread(hFileID,1,'uint32'); % Read time stamp...
% %iBDummy = fread(hFileID,1,'uint16'); % Read time stamp...
% iNextPositionNewFile = 1028 + iFirstFrameSizeInBytes + 4 + 8;
% try
%     X = parsejpg8(strFileName, iNextPositionNewFile);
%     bNewFileType = true;
% catch
%     bNewFileType = false;
% end
% 
% fclose(hFileID);
% return;



function iFrameFooterSize = fnJpegSeqFrameFooterSize(strctMovInfo)
% Try to empirically determine the size of the frame footer in a JPEG .seq
% file.  Try the two likely options, and see if either hypothesis gets you 
% to a file offset where there's a readable JPEG frame.
strFileName=strctMovInfo.m_strFileName;
iFileMetadataSize=strctMovInfo.m_iFileMetadataSize;
iFrameMetadataSize=strctMovInfo.m_iFrameMetadataSize;
hFileID = fopen(strFileName);
fseek(hFileID,1024+iFileMetadataSize,'bof');
iFirstFrameSizeInBytes = fread(hFileID,1,'uint32')-4;
  % iFirstFrameSizeInBytes is the size of just the JPEG frame data,
  % not including the frame header
fclose(hFileID);
iFrameFooterSize=8;  
  % the frame footer contains an 8-byte timestamp, plus sometimes 8 bytes
  % of reserved storage.  Daniel Wang at Norpix claims that v3 .seg files
  % have no reserved storage, and v4 files have 8 bytes of reserved
  % storage.  But code to determine the frame footer size emprically was
  % already in MouseHouse/Motr before v4 came about.  So a) I'm not sure I
  % beleive Daniel, and b) I don't know whether v1 and v2 .seq have this
  % reserved storage or not.
iNextFrameJpegOffset = ...
    1024 + 4 + iFirstFrameSizeInBytes + iFrameFooterSize + ...
    iFrameMetadataSize + 4;
try
    % parsejpg8() will throw an error if there's no JPEG stream at this offset
    parsejpg8(strFileName, iNextFrameJpegOffset);
    % if we get here, iFrameFooterSize==8 works, so we return
    return;
catch excp
    iFrameFooterSize=16;
    iNextFrameJpegOffset = ...
        1024 + 4 + iFirstFrameSizeInBytes + iFrameFooterSize + ...
        iFrameMetadataSize + 4;
    try
        % parsejpg8() will throw an error if there's no JPEG stream at this offset
        parsejpg8(strFileName, iNextFrameJpegOffset);
        % if we get here, iFrameFooterSize==16 works, so we return
        return;
    catch excpTheSecond
        error('Motr:unableToDetermineJpegSeqFooterSize', ...
              'Unable to determine size of JPEG .seq footer');
    end
end

return
