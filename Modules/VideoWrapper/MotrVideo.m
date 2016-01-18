classdef MotrVideo < handle
    
    properties (Dependent=true)
        m_iHeight
        m_iWidth
        m_iNumFrames
        m_strFileName
        m_fFPS  % nominal frame rate
        m_afTimestamp
    end
    
    properties  (Access=protected)
        fileName_
        readFrameFunction_
        nFrames_
        fid_
        headerInfo_
        nRows_
        nColumns_
        nominalFrameRate_  % Hz, nominal frame rate
          % Usually this is the frame rate the user requested when the
          % video was taken.  But occasionally frames are dropped.  Still,
          % most elements of diff(frameTimeStamps_) should be equal (up to
          % floating-point errors) to nominalFrameRate_.  But where frame
          % drops occurred, there will be elements of
          % diff(frameTimeStamps_) that are substantially larger than
          % nominalFrameRate_.
        frameTimeStamps_  % s, one element per frame, the time that each frame was taken
    end
    
    methods
        function self = MotrVideo(fileName)
            % Call get_readframe_fcn() to get a function for reading frames
            % from the video fileName
            [~,~,strExt] = fileparts(fileName);
            if strcmpi(strExt,'.seq') ,
                % For .seq files, need to pass get_readframe_fcn() an index
                % file name, otherwise it decides they're "Piotr-style" seq
                % files, and sadness ensues.

                % Look for the index file, creating it if it's missing
                [pathNameToContainingFolder, baseName] = fileparts(fileName) ;
                indexFileName=fullfile(pathNameToContainingFolder, [baseName '.mat']);
                if ~exist(indexFileName, 'file') ,
                    % Automatically generate the index if it doesn't exist, and save it to disk
                    strctBasicMovInfo = fnReadBasicSeqInfo(fileName) ;
                    [aiSeekPos, afTimestamp] = ...
                        fnGenerateSeqSeekInfo(strctBasicMovInfo,strctBasicMovInfo.m_iNumFrames);
                    strctMovInfo = strctBasicMovInfo ;
                    strctMovInfo.m_aiSeekPos = aiSeekPos;
                    strctMovInfo.m_afTimestamp = afTimestamp;
                    strSeqFileName = fileName ;  %#ok<NASGU>
                    save(indexFileName,'strSeqFileName','aiSeekPos','afTimestamp');
                end

                % Pass the index file name to get_readframe_fcn()
                [readFrameFunction,nFrames,fid,headerInfo] = get_readframe_fcn(fileName, ...
                                                                               'indexfilename', indexFileName, ...
                                                                               'seqtype', 'shay' ) ;
            else
                [readFrameFunction,nFrames,fid,headerInfo] = get_readframe_fcn(fileName) ;
            end
            
            self.fileName_ = fileName ;
            self.readFrameFunction_ = readFrameFunction ;
            self.nFrames_ = nFrames ;
            self.fid_ = fid ;
            self.headerInfo_ = headerInfo ;
            
            % Extract all the info we need now, so that anything missing
            % from headerinfo throws an error now, not later, maybe after
            % the user has done a lot of work.
            self.nRows_ = self.headerInfo_.nr ;
            self.nColumns_ = self.headerInfo_.nc ;
            
            % the frame rate and frame time stamps get put in different
            % parts of headerinfo depending on the file type, so have to
            % figure out the file type and then act accordingly
            [~,~,strExt] = fileparts(fileName);
            %fileType = headerInfo.type ;  % .type is not always present in headerInfo
            %if isequal(fileType,'seq') ,
            if strcmpi(strExt,'.seq') ,
                self.nominalFrameRate_ = headerInfo.m_fFps ;
                self.frameTimeStamps_ = headerInfo.m_afTimestamp ;
            %elseif isequal(fileType,'ufmf') ,
            elseif strcmpi(strExt,'.ufmf') ,
                ts = headerInfo.timestamps ;
                fps = (length(ts)-1)/(ts(end)-ts(1)) ;
                self.nominalFrameRate_ = fps ;
                self.frameTimeStamps_ = ts ;  % s
            elseif strcmpi(strExt,'.mjpg') ,
                % The headerInfo will differ depending on whether it's an
                % index .mjpg or a non-indexed one, so look at the
                % headerInfo to determine which it is...
                if isfield(headerInfo,'timestamp') ,
                  % This means an indexed .mjpg
                  ts = headerInfo.timestamp ;
                  fps = (length(ts)-1)/(ts(end)-ts(1)) ;
                  self.nominalFrameRate_ = fps ;
                  self.frameTimeStamps_ = ts ;  % s
                elseif isfield(headerInfo,'FrameRate') ,  % this will be true, for instance, if get_readframe_fcn used VideoReader() to read the object
                  % This means the .mjpg was not indexed, but was VideoReader-readable, in which
                  % case headerinfo shoulds have a FrameRate field.
                  fps = headerInfo.FrameRate ;
                  self.nominalFrameRate_ = fps ;
                  self.frameTimeStamps_ = (1/fps) * (0:(nFrames-1)) ;  % s
                else
                  error('motr:unableToDetermineFrameRate', ...
                        'Unable to determine frame rate of video file %s', fileName);                  
                end
            elseif isfield(headerInfo,'FrameRate') ,  % this will be true, for instance, if get_readframe_fcn used VideoReader() to read the object
                % Assume that the file was VideoReader-readable, in which
                % case headerinfo shoulds have a FrameRate field.
                fps = headerInfo.FrameRate ;
                self.nominalFrameRate_ = fps ;
                self.frameTimeStamps_ = (1/fps) * (0:(nFrames-1)) ;  % s
            else
                % We could make up a frame rate, but probably better to
                % error, so the user knows there's a problem sooner rather
                % than later.
                % (The .delete() method should get called automatically to
                % close any open file handles.)
                error('motr:unableToDetermineFrameRate', ...
                      'Unable to determine frame rate of video file %s', fileName);
            end
        end
        
        function delete(self)
            self.readFrameFunction_ = [] ;
            if ~isempty(self.fid_) ,
                if self.fid_>=3 ,  % low-numbered ones are reserved by fopen() for stdin, etc.  And -1 means "invalid"
                    fclose(self.fid_) ;
                end
                self.fid_ = [] ;
            end            
        end
        
        function result = get.m_iHeight(self)
            result = self.nRows_ ;
        end
        
        function result = get.m_iWidth(self)
            result = self.nColumns_ ;
        end
        
        function result = get.m_iNumFrames(self)
            result = self.nFrames_ ;
        end
        
        function result = get.m_fFPS(self)
            result = self.nominalFrameRate_ ;
        end
        
        function result = get.m_strFileName(self)
            result = self.fileName_ ;
        end
        
        function result = get.m_afTimestamp(self)
            result = self.frameTimeStamps_ ;
        end
        
        function frame = fnReadFrameFromVideo(self,indexOfFrameWithinVideo)
            fcn = self.readFrameFunction_ ;
            rawFrame = fcn(indexOfFrameWithinVideo) ;
            if size(rawFrame,3) > 1 ,
                % Want to force to be monochrome
                frame = rawFrame(:,:,1);  % w x h, uint8
            else
                frame = rawFrame ;
            end
        end
        
        function framesToReturn = fnReadFramesFromVideo(self,iFramesToReturn)
            nFramesToReturn = length(iFramesToReturn) ;
            framesToReturn = zeros(self.nRows_,self.nColumns_,nFramesToReturn,'uint8');
            for indexWithinReturnedFrames = 1:nFramesToReturn ,
                indexOfFrameWithinVideo = iFramesToReturn(indexWithinReturnedFrames) ;
                frame = self.fnReadFrameFromVideo(indexOfFrameWithinVideo) ;
                framesToReturn(:,:,indexWithinReturnedFrames) = frame ;
            end
        end
    end  % public methods
    
end
