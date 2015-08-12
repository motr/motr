classdef UfmfFileReader < handle
    % Very simple MCOS wrapper for a FID.  Provides automatic closing of
    % the FID when one of these goes out of scope.  Can be used as a
    % drop-in replacement for an FID in many usages, b/c
    % fread(oneOfThese,...) is equivalent to onOfThese.fread(...)
    
    properties (Access=protected)
        fid_
    end
    
    methods
        function self = UfmfFileReader(fileName, varargin)
            self.fid_ = fopen(fileName, varargin{:}) ;
        end   % function
        
        function delete(self)
            try
                self.fclose() ;
            catch me
                if isequal(me.identifier,'MATLAB:FileIO:InvalidFid') ,
                    % ignore --- this seems to happen sometimes, not sure
                    % what's up with that.  But should be warmless to
                    % ignore
                else
                    rethrow(me);  % this will get converted to a warning, but still...
                end
            end
        end   % function

        function [A,count] = fread(self,varargin)
            [A,count] = fread(self.fid_,varargin{:}) ;
        end   % function
        
        function status = fseek(self,varargin)
            status = fseek(self.fid_,varargin{:}) ;
        end   % function

        function position = ftell(self,varargin)
            position = ftell(self.fid_,varargin{:}) ;
        end   % function

        function fclose(self)
            if isempty(self.fid_) || self.fid_<0 ,
                % do nothing
            else                
                fclose(self.fid_) ;
            end
            self.fid_ = [] ;
        end   % function

        function result = isValid(self)
            result = ~( isempty(self.fid_) || self.fid_<0 ) ;
        end   % function
    end  % public methods
end  % classdef
