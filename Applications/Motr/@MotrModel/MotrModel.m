classdef MotrModel < handle
    
%     properties (Dependent=true)
%         parameterFileNameAbs
%     end
    
    properties
        expSelected
        expDirName
        clipFNAbs
        clipSMFNAbs
        iClipCurr
        iClipSMCurr
        trainStatus
        trackStatus        
        clusterMode
    end
    
    properties  % protected, in spirit
        parameterFileNameAbs_
        userInterface_
    end
    
    methods
        function self=MotrModel()
            global g_strMouseStuffRootDirName %g_strctGlobalParam
            
            %fprintf('MotrModel::MotrModel()\n');
            self.expSelected=false;
            self.clusterMode=false;            
            
            % Determine the root Motr directory
            thisFileName=mfilename('fullpath');
            thisDirName=fileparts(thisFileName);
            thisDirParts=split_on_filesep(thisDirName);
              % a cell array with each dir an element
            mouseStuffRootParts=thisDirParts(1:end-2);
            g_strMouseStuffRootDirName=combine_with_filesep(mouseStuffRootParts);
            
%             % Load various algorithm parameters from the XML file
%             parameterFileNameAbs = fullfile(g_strMouseStuffRootDirName, ...
%                                             'Config', ...
%                                             'Algorithms.xml') ;
%             self.parameterFileNameAbs_ = parameterFileNameAbs ;
%             g_strctGlobalParam = fnLoadAlgorithmsConfigXML(parameterFileNameAbs) ;
        end
        
        function delete(self)
            %fprintf('MotrModel::delete()\n');
            self.userInterface_ = [] ;
        end
        
        function registerUserInterface(self,ui)
            self.userInterface_ = ui ;
        end
        
        function unregisterUserInterface(self)
            self.userInterface_ = [] ;
        end
        
        function changed(self)
            if ~isempty(self.userInterface_) ,
                self.userInterface_.modelChanged();
            end
        end
        
        function result = getParameterFileNameAbs(self)
            result = self.parameterFileNameAbs_ ;
        end
        
        function err=setParameterFileNameAbs(self, value)
            global g_strctGlobalParam
            %originalValue = self.parameterFileNameAbs_ ;
            %originalParams = g_strctGlobalParam ;
            try
                params = fnLoadAlgorithmsConfigXML(value) ;
            catch me
                err=MException('motr:unableToLoadParameterFile', ...
                               'Unable to load parameter file: %s', ...
                               me.message) ;
                self.changed() ;
                return
            end
            try
                MotrModel.saveClipFN(self.expDirName, self.clipFNAbs , self.clipSNFNAbs, value) ;
            catch me
                err=MException('motr:unableToSaveUpdatedExperimentInfo', ...
                               'Unable to save updated experiment info: %s', ...
                               me.message) ;
                self.changed() ;
                return
            end
            % if get here, all the "risky" operations succeeded
            g_strctGlobalParam = params ;
            self.parameterFileNameAbs_ = value ;
            % Might make sense to clear out preexisting training and
            % tracking files, update trainStatus, trackStatus here.
            % But that's a whole can of worms...
            self.changed() ;
        end  % function
    end
    
    methods (Static=true)
        function [clipFNAbs,clipSMFNAbs,parameterFileNameAbs]=loadClipFN(fileName,expDirName)
            % Loads the clip filename information from the given file.  If it's an
            % old-format file, uses expDirName to return the absolute paths.

            s=fnLoadAnonymous(fileName);
            if ~isa(s,'struct')
              % messed-up clipFN.mat file
              excp=MException('loadClipFN:wrongFormat', ...
                              ['%s doesn''t seem to be in the right format.  ' ...
                               'Maybe it''s in the old format?'], ...
                              fileName);
              throw(excp);
            end
            % If we get here, we know s is a struct array.
            varName=fieldnames(s);
            if any(strcmp('clipFNAbs',varName)) && any(strcmp('clipSMFNAbs',varName))
              % new-style clipFN.mat file
              clipFNAbs=s.clipFNAbs;
              clipSMFNAbs=s.clipSMFNAbs;
            elseif any(strcmp('clipFN',varName)) && any(strcmp('clipSMFN',varName))
              % old-style clipFN.mat file
              clipFN=s.clipFN;
              nClip=length(clipFN);
              clipFNAbs=cell(nClip,1);
              for i=1:nClip
                clipFNAbs{i}=fullfile(expDirName,clipFN{i});
              end  
              clipSMFN=s.clipSMFN;
              nClipSM=length(clipSMFN);
              clipSMFNAbs=cell(nClip,1);
              for i=1:nClipSM
                clipSMFNAbs{i}=fullfile(expDirName,clipSMFN{i});
              end
            else
              % messed-up clipFN.mat file
              excp=MException('loadClipFN:wrongFormat', ...
                              ['%s doesn''t seem to be in the right format.  ' ...
                               'Maybe it''s in the old format?'], ...
                              fileName);
              throw(excp);
            end

            % get the parameterFileName absolute path, if present
            if any(strcmp('parameterFileNameAbs',varName)) ,
                parameterFileNameAbs = s.parameterFileNameAbs ;
            else
                parameterFileNameAbs = defaultParameterFileNameAbs() ;
            end
        end  % function        
        
        function trainStatus=determineTrainStatus(expDirName,clipSMFNAbs)
            % Figures out what the training status is, by looking for files in the
            % right places.  expDirName should be an absolute path, clipSMFN should
            % contain relative paths.
            %
            % The code:
            %   1: not started
            %   2: files chosen
            %   3: in process
            %   4: done

            % Check for the final results file
            finalTrainingFN=fullfile(expDirName,'Tuning','Identities.mat');
            if exist(finalTrainingFN,'file')
              trainStatus=4;
              return;
            end

            % Check for per-animal SM ident files
            nClipSM=length(clipSMFNAbs);
            for i=1:nClipSM
              [dummy,baseNameThis]=fileparts(clipSMFNAbs{i});  %#ok
              fileName=fullfile(expDirName,'Tuning',baseNameThis,'Identities.mat');
              if exist(fileName,'file')
                trainStatus=3;
                return;
              end
            end

            % Check for background segmentation file
            fileName=fullfile(expDirName,'Tuning','Detection.mat');
            if exist(fileName,'file')
              trainStatus=3;  % is this right?  Or should it be 2?
              return;
            end

            % have the files even been chosen?
            if nClipSM>0
              trainStatus=2;
              return;
            end

            % if we get here, the files haven't even been chosen
            trainStatus=1;
        end
        
        function status=determineTrackStatus(expDirName,clipFNAbs)
            % Figures out what the tracking status of the given clip is, by looking for
            % files in the right places.  expDirName should be an absolute path, clipFN
            % should contain relative paths.
            %
            % The code:
            %   1: not started
            %   2: files chosen
            %   3: in process
            %   4: done

            % Check for the final results file
            [~,baseName]=fileparts(clipFNAbs);  % the seq file name, w/o .seq
            finalTrackingFN=fullfile(expDirName,'Results','Tracks',[baseName '_tracks.mat']);
            if exist(finalTrackingFN,'file')
                status=4;
                return
            end

            % Check for an old-style results file, rename it if present
            finalTrackingFNOldSchool=fullfile(expDirName,'Results','Tracks',[baseName '.mat']);
            if exist(finalTrackingFNOldSchool,'file')
              success=copyfile(finalTrackingFNOldSchool,finalTrackingFN);
              if success ,
                delete(finalTrackingFNOldSchool);
                status=4;
                return
              else
                % If can't copy, just continue on as if the old-school file doesn't
                % exist.  Hopefully we can just re-run Viterbi using the existing job
                % files, and all will be good.
              end
            end

            % Check for the per-job Jobargin files
            dirName=fullfile(expDirName,'Jobs',baseName);
            filter='Jobargin*.mat';
            pattern=fullfile(dirName,filter);
            d=dir(pattern);
            nJobarginFile=length(d);
            if nJobarginFile>0
                status=3;
                return;
            end

            % I think the above is actually a better test for "in process"
            % % Check for per-chunk .mat files
            % dirName=fullfile(expDirName,'Results',baseName);
            % filter='*.mat';
            % pattern=fullfile(dirName,filter);
            % d=dir(pattern);
            % nResultFile=length(d);
            % if nResultFile>0
            %     status=3;
            %     return;
            % end

            % the worst things can be is 2, since the file name is in clipFN
            status=2;
        end  % function
        
        function saveClipFN(expDirName,clipFNAbs,clipSMFNAbs,parameterFileNameAbs)
            % Stores the clip filename information in exp in the file. 

            s=struct('clipFNAbs',{clipFNAbs}, ...
                     'clipSMFNAbs',{clipSMFNAbs}, ...
                     'parameterFileNameAbs',{parameterFileNameAbs});
            fileName=fullfile(expDirName,'clipFN.mat');
            fnSaveAnonymous(fileName,s);
        end
        
        function jobFN = getJobFileNames(resultsDirName, clipFN, nJobs)
            % Generates a cell array of the file names of the job output files for
            % the jobs associated with the clip named in clipFN, assuming there are
            % nJobs such jobs.

            if isempty(nJobs)
               nJobs=0;
            end
            %strctMovieInfo = fnReadVideoInfo(clipFN);
            [~, clipBaseName] = fileparts(clipFN);
            % D = dir(fullfile(resultsDirName, clipBaseName, 'JobOut*.mat'));
            jobFN=cell(nJobs,1);
            for iJob=1:nJobs
              % jobFN{iJob} = fullfile(resultsDirName, clipBaseName, D(iJob).name);
              jobFN{iJob} = fullfile(resultsDirName, ...
                                     clipBaseName, ...
                                     ['JobOut' num2str(iJob) '.mat']);
            end
        end  % function
        
        function iMissing = findUnfinishedJobsOneClip(jobFN)
            nJobs = length(jobFN);
            iMissing = zeros(0,1);
            for i=1:nJobs
              if ~exist(jobFN{i}, 'file')
                iMissing = [iMissing;i];   %#ok<AGROW>
              end
            end
        end  % function
        
        function astrctTrackersFixed = fnHouseIdentities(astrctTrackers, ...
                                                         strctMovieInfo, ...
                                                         sClassifiersFile)
            aiBigJumps = ...
              1 + (find(strctMovieInfo.m_afTimestamp(2:end)- ...
                        strctMovieInfo.m_afTimestamp(1:end-1) > ...
                        1/strctMovieInfo.m_fFPS * 10));

            abLargeTimeGap = zeros(1,length(astrctTrackers(1).m_afX))>0;
            abLargeTimeGap(aiBigJumps) = 1;

            fSwapPenalty = -200;
            strctID = load(sClassifiersFile);
            astrctTrackersFixed = ...
              fnCorrectIdentitiesOnTheFly(astrctTrackers, ...
                                          strctID.strctIdentityClassifier, ...
                                          abLargeTimeGap, ...
                                          false, ...
                                          fSwapPenalty);
        end  % function
        
        function fnPostTracking(clipFNAbs, expDirName, iClip, aiNumJobs)
            fprintf('In fnPostTracking\n');
            tuningDirName = fullfile(expDirName, 'Tuning');
            jobsDirName = fullfile(expDirName, 'Jobs');
            resultsDirName = fullfile(expDirName, 'Results');
            tracksDirName = fullfile(resultsDirName, 'Tracks');
            fprintf('Dirs = \n  %s\n  %s\n  %s\n  %s\n', ...
                    tuningDirName, ...
                    jobsDirName, ...
                    resultsDirName, ...
                    tracksDirName);
            if ~exist(tracksDirName,'dir')
              mkdir(tracksDirName);
            end
            %startupDirName = [pwd() filesep];
            %sDetectionFile = fullfile(tuningDirName, 'Detection.mat');
            classifiersFN = fullfile(tuningDirName, 'Identities.mat');
            clipFNAbsThis=clipFNAbs{iClip};
            jobFN = MotrModel.getJobFileNames(resultsDirName, clipFNAbsThis, aiNumJobs);
            %strMovieFileName = clipFN(iClip).sName;
            fprintf('Reading video info from %s', clipFNAbsThis);
            %clipFNThisAbs=fullfile(expDirName,clipFNThis);
            clipThisInfo = fnReadVideoInfo(clipFNAbsThis);
            [dummy, sClipName] = fileparts(clipFNAbsThis); %#ok
            trackers = fnMergeJobs(clipThisInfo, jobFN, []);
            rawTrackFN = fullfile(resultsDirName, sClipName, 'SequenceRAW');
            %save(rawTrackFN, 'astrctTrackers', 'strMovieFileName');
            saveTrackFile(rawTrackFN,trackers,clipFNAbsThis);
            %astrctTrackers = fnHouseIdentities(astrctTrackers, clipThisInfo, ...
            %                                   classifiersFN);
            trackers=MotrModel.fnHouseIdentities(trackers, clipThisInfo, classifiersFN);
            trackFN = fullfile(tracksDirName, [sClipName '_tracks.mat']);
            %save(trackFN, 'astrctTrackers', 'strMovieFileName');
            saveTrackFile(trackFN,trackers,clipFNAbsThis);
            fprintf('Done. Saved track file %s\n', trackFN);
            % fnUpdateStatus(handles, 2, 4);
        end  % function
        
    end  % static methods
    
    
end
