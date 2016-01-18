function strctMovInfo = fnReadBasicSeqInfo(strSeqFileName,forceNoMetadata)
    % Credits go for Poitr Dollar for the initial code of reading the SEQ
    % files.
    % forceNoMetaData, if true, means the resulting strctMovInfo structure says
    % that both the per-file and per-frame metadata is of length zero.  This
    % may be useful for reading Streampix 5.19+ files when the built-in
    % heuristics fail.
    %
    % Unlike fnReadBasicSeqInfo(), this doesn't try to read or create an index
    % file.  It simply reads things from the .seq file header and returns them
    % in a structure.

    % Deal with optional arguments
    if ~exist('forceNoMetadata','var') || isempty(forceNoMetadata)
      forceNoMetadata=false;
    end 

    hFileID = fopen(strSeqFileName);
    fseek(hFileID,0,'bof');
    % first 4 bytes store OxFEED, next 24 store 'Norpix seq  '
    if ~(strcmp(sprintf('%X',fread(hFileID,1,'uint32')),'FEED'))
        % Attempt to fix SEQ header.
        fclose(hFileID);
        error('Header is corrupted for file %s!\n', strSeqFileName);
    %     strResponse = input('Do you want to fix the file [Y]/[N]? : ','s');
    %     bFix = strResponse(1) == 'Y' || strResponse(1) == 'y';
    %     if bFix
    %         fnFixSeqHeader(strSeqFileName); 
    %         hFileID = fopen(strSeqFileName);
    %         fseek(hFileID,0,'bof');
    %         assert(strcmp(sprintf('%X',fread(hFileID,1,'uint32')),'FEED'));
    %     else
    %         strctMovInfo = [];
    %         return;
    %     end;
    end;
    assert(strcmp(char(fread(hFileID,10,'uint16'))','Norpix seq')); %#ok<FREAD>
    fseek(hFileID,4,'cof');
    % next 8 bytes for version and header size (1024), then 512 for descr
    iVersion=fread(hFileID,1,'int32'); 
    assert(fread(hFileID,1,'uint32')==1024);
    fseek(hFileID,512,'cof');
    % read in more strctMovInfo
    iWidth=fread(hFileID,1,'uint32'); 
    iHeight=fread(hFileID,1,'uint32'); 
    iImageBitDepth=fread(hFileID,1,'uint32'); 
    iImageBitDepthReal=fread(hFileID,1,'uint32'); 
    iImageSizeBytes=fread(hFileID,1,'uint32'); 
    iImageFormatRaw=fread(hFileID,1,'uint32'); 
    iNumFrames=fread(hFileID,1,'uint32'); 
    fread(hFileID,1,'uint32');  % skip one field
    iTrueImageSize=fread(hFileID,1,'uint32');  
      % for uncompressed frames, the number of bytes between image starts
      % ignored for compressed frames
    fps = fread(hFileID,1,'float64');

    % version 4 of the .seq format separated information about type of image
    % in the frames from information about how they're compressed.  Sort that
    % out
    if iVersion>=4
      iImageFormat=iImageFormatRaw;
        % 100 == monochrome
        % 200 == BGR compressed
      % go look at the the compression format, stored separately
      fseek(hFileID,620,'bof');
      iCompressionFormat=fread(hFileID,1,'uint32');
      % 0 == uncompressed
      % 1 == JPEG compressed
    else
      switch iImageFormatRaw
        case 100,
          % monochrome, uncompressed
          iImageFormat=100;  % monochrome
          iCompressionFormat=0;  % uncompressed
        case 102,
          % monochrome, jpeg compression
          iImageFormat=100;  % monochrome
          iCompressionFormat=1;  % jpeg compressed
        case 200,
          % BGR color, uncompressed
          iImageFormat=200;  % BGR color
          iCompressionFormat=0;  % uncompressed
        case 201,
          % BGR color, jpeg compression
          iImageFormat=200;  % BGR color
          iCompressionFormat=1;  % jpeg compressed
        otherwise
          error('Motr:unhandledImageFormat', ...
                'SEQ file is in a format that Motr can''t handle');
      end
    end

    % determine file and frame metadata size
    if forceNoMetadata
      iFrameMetadataSize=0;
      iFileMetadataSize=0;    
    else
      if iVersion>=4
        fseek(hFileID,640,'bof');
        iFrameMetadataSize=fread(hFileID,1,'uint32');
        iFileMetadataSize=fread(hFileID,1,'uint32');
        % This is a hack to deal with files produced by Streampix v5.19
        % Streampix 5.16-5.18 included metadata in the .seq file, but this was 
        % removed in 5.19.  And there's no good way to determine what kind of
        % .seq file you're dealing with (all of them say they're version 4).
        % Daniel Wang at Norpix suggested the heuristic below.
        if iFrameMetadataSize>=2^31
          % Probably a 5.19+ file
          %warning('iFrameMetadataSize is %d, which is crazy.  Assuming this is a Streampix 5.19+ .seq file.',iFrameMetadataSize);
          iFrameMetadataSize=0;
          iFileMetadataSize=0;    
        end
      else
        iFrameMetadataSize=0;
        iFileMetadataSize=0;
      end
    end

    % store strctMovInformation in strctMovInfo struct
    strctMovInfo=struct( 'm_strFileName', strSeqFileName,...
                         'm_iWidth',iWidth, ...
                         'm_iHeight',iHeight, ...
                         'm_iImageBitDepth',iImageBitDepth, ...
                         'm_iImageBitDepthReal',iImageBitDepthReal, ...
                         'm_iImageSizeBytes',iImageSizeBytes, ...
                         'm_iImageFormat',iImageFormat, ...
                         'm_iCompressionFormat',iCompressionFormat, ...
                         'm_iNumFrames',iNumFrames, ...
                         'm_iTrueImageSize', iTrueImageSize,...
                         'm_fFPS',fps, ...
                         'm_iSeqiVersion',iVersion, ...
                         'm_iFileMetadataSize',iFileMetadataSize, ...
                         'm_iFrameMetadataSize',iFrameMetadataSize);
    fclose(hFileID);

    % % Automatically generate seeking strctMovInfo if not exist
    % % [strPath, strFileName] = fileparts(strSeqFileName);
    % % if isunix || ismac
    % %     strSeekFilename = [strPath,'/',strFileName,'.mat'];
    % % else
    % %     if length(strPath) == 3 && strPath(3) == '\'
    % %         strSeekFilename = [strPath,strFileName,'.mat'];
    % %     else
    % %         strSeekFilename = [strPath,'\',strFileName,'.mat'];
    % %     end
    % % end;
    % [strPath, strBaseName] = fileparts(strSeqFileName);
    % strSeekFileName=fullfile(strPath,[strBaseName '.mat']);
    % if exist(strSeekFileName,'file')
    % %if false
    %     % load the frame index from the pre-existing file
    %     strctTmp = load(strSeekFileName);
    %     strctMovInfo.m_aiSeekPos = strctTmp.aiSeekPos;
    %     strctMovInfo.m_afTimestamp = strctTmp.afTimestamp;
    % else
    %     % generate an index, save it to file
    %     [aiSeekPos, afTimestamp] = ...
    %         fnGenerateSeqSeekInfo(strctMovInfo,strctMovInfo.m_iNumFrames);
    %     strctMovInfo.m_aiSeekPos = aiSeekPos;
    %     strctMovInfo.m_afTimestamp = afTimestamp;
    %     save(strSeekFileName,'strSeqFileName','aiSeekPos','afTimestamp');
    % end

    % hack for some .seq files that inexplicably have their FPS value set to inf
    if ~isfinite(strctMovInfo.m_fFPS) && all(isfinite(strctMovInfo.m_afTimestamp))
      strctMovInfo.m_fFPS=1/mean(diff(strctMovInfo.m_afTimestamp));
    end

end  % function



