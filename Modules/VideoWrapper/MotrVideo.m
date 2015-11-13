classdef MotrVideo < handle
    
    properties (Dependent=true)
        m_iHeight
        m_iWidth
        m_iNumFrames
        m_strFileName
        m_fFps  % nominal frame rate
        m_afTimestamp
    end
    
    properties  % these are protected in spirit, but actually making them protected just makes debugging annnoying
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
            [readframe_fcn,nframes,fid,headerinfo] = get_readframe_fcn(fileName) ;
            
            self.fileName_ = fileName ;
            self.readFrameFunction_ = readframe_fcn ;
            self.nFrames_ = nframes ;
            self.fid_ = fid ;
            self.headerInfo_ = headerinfo ;
            
            % Extract all the info we need now, so that anything missing
            % from headerinfo throws an error now, not later, maybe after
            % the user has done a lot of work.
            self.nRows_ = self.headerInfo_.nr ;
            self.nColumns_ = self.headerInfo_.nc ;
            self.nominalFrameRate_ = nan ;
            self.frameTimeStamps_ = nan(1,nframes) ;
        end
        
        function delete(self)
            self.readFrameFunction_ = [] ;
            if ~isempty(self.fid_) ,
                if self.fid_>=0 ,
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
        
        function result = get.m_fFps(self)
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
            frame = fcn(indexOfFrameWithinVideo) ;
        end
        
        function framesToReturn = fnReadFramesFromVideo(self,iFramesToReturn)
            nFramesToReturn = length(iFramesToReturn) ;
            framesToReturn = zeros(self.nRows_,self.nColumns_,nFramesToReturn,'uint8');
            for indexWithinReturnedFrames = 1:nFramesToReturn ,
                indexOfFrameWithinVideo = iFramesToReturn(indexWithinReturnedFrames) ;
                frame = self.fnReadFromVideo(indexOfFrameWithinVideo) ;
                framesToReturn(:,:,indexWithinReturnedFrames) = frame ;
            end
        end
    end  % public methods
    
end
