function fnHourlyConfigurationEntryPoint_V3
strFolder = 'D:\Data\Janelia Farm\ResultsFromNewTrunk\';
aiCages = [16,17,18,19,20,23,24];
iNumCages = length(aiCages);

fTimeThresholdMin = 4;
fProximityThreshold = 50;
iNumMice = 4;

a2fColors = [147,240,120;
    255,0,0
    227,28,227
    0,255,255
    170,255,85
    0,0,255;
    255,255,128
    0,255,64;
    148,225,30
    255,128,0
    128,0,255
    162,94,104;
    133,240,90;
    104,153,38;
    colorcube(50)*255;
    ];
colordef black
aiPairs = nchoosek(1:4,2);
for iCageIter=1:iNumCages
    strDatfile = [strFolder,'cage',num2str(aiCages(iCageIter)),'_matrix.mat'];
    strDistfile = [strFolder,'cage',num2str(aiCages(iCageIter)),'_dist.mat'];
    strctDist = load(strDistfile);
    strctData = load(strDatfile);
    
    fVelocityThreshold = 0.2;
    fPositionThreshold = 80;
    fPositionThreshold2=1.8;
    X = [];
    Y = [];
    for iMouseIter = 1:4
        aiRelevantDist = find(aiPairs(:,1) == iMouseIter |aiPairs(:,2) == iMouseIter);
        afMinDistToOthers = min(strctDist.a2fDistance(:,aiRelevantDist),[],2);
        
       afVel = [0;sqrt( (strctData.X(2:end,iMouseIter)-strctData.X(1:end-1,iMouseIter)).^2+ (strctData.Y(2:end,iMouseIter)-strctData.Y(1:end-1,iMouseIter)).^2)];
        abNotMoving = afVel < fVelocityThreshold;
        
        
        abAlone= afMinDistToOthers > fPositionThreshold & abNotMoving;
        X = [X;strctData.X(abAlone,iMouseIter)];
        Y = [Y;strctData.Y(abAlone,iMouseIter)];
    end
    abNaN=isnan(X)|isnan(Y);
    X=X(~abNaN);
    Y=Y(~abNaN);
    
    a2fCenter=hist2(X,Y,1:1024,1:768);
    
    %a2fCenter=hist2(strctData.X(abNotMoving,iMouseIter),strctData.Y(abNotMoving,iMouseIter),1:1024,1:768);
    
    a2fCenterSmoothLog = conv2(log10(1+a2fCenter),fspecial('gaussian',[50 50],6),'same');
    
    a2fCenterSmoothLogFiltered = a2fCenterSmoothLog;
    a2fCenterSmoothLogFiltered(a2fCenterSmoothLogFiltered<fPositionThreshold2) =0;
    
    
    D=a2fCenterSmoothLogFiltered;
      
    
    D(D==0) = Inf;
    D=-D;
    Lraw=watershed(D);
    
    
    aiPlaces = interp2(double(Lraw), X,Y,'nearest');
    iNumCC = max(Lraw(:));
    aiHist=histc(aiPlaces,1:iNumCC);
    afTimeSpentMin = aiHist/30/60;
    fMinTimeSpentMin = 5;
    L = Lraw;
    iCounter = 2;
    for k=2:iNumCC
        if afTimeSpentMin(k)< fMinTimeSpentMin
            L(Lraw==k) = 1;
        else
            L(Lraw==k) = iCounter;
            iCounter=iCounter+1;
        end
    end
    
    %         aiHist = histc(L(:),1:max(L(:)));
    %         aiSmallCC = find(aiHist < 100);
    %         a2bSmall = fnSelectLabels(uint16(L),uint16(aiSmallCC))>0;
    %         L(a2bSmall) = 1;
    %         a3iDweeling(:,:,iMouseIter) = L;
    L(L==1)=0;
    
    %                figure(24);
    %         clf;
    %         subplot(1,3,1);
    %         imagesc(a2fCenterSmoothLogFiltered);impixelinfo
    %         subplot(1,3,2);
    %         imagesc(D)
    %         subplot(1,3,3);
    %         imagesc(L)
    %
    
    iNumCC=max(L(:))-1;
    acRegions = cell(1,iNumCC);
    for k=1:iNumCC
        B=bwboundaries(L == k+1);
        acRegions{k} = B{1};
    end
    
    figure(iCageIter);clf;
    
    tightsubplot(2,2,1,'Spacing',0.01);
    imagesc(log10(a2fCenter));
    axis off
    tightsubplot(2,2,2,'Spacing',0.01);
    imagesc(a2fCenterSmoothLog)
    axis off
    tightsubplot(2,2,3,'Spacing',0.01);
    imagesc(a2fCenterSmoothLog);
    hold on;
    for k=1:length(acRegions)
        plot(acRegions{k}(:,2),acRegions{k}(:,1),'w','linewidth',2);
    end
    axis off
    tightsubplot(2,2,4,'Spacing',0.01);
    imagesc(label2rgb(L-1, a2fColors/255,[0 0 0]));
    axis off
    drawnow
    
    set(gcf,'position',[884   494   942   602]);
end
% 
%     
%     % Compute onset and offset times for each dwelling place.
%     figure(100+iCageIter);clf;
%     fFPS=30;
%     iNumFramesPerMinute = fFPS * 60;
%     iTimeSmoothingKernelFrames = iNumFramesPerMinute*4;
%     iNumFrames = size(strctData.X,1);
%     afTimeHours = [0:iNumFrames-1]/fFPS/60/60;
%     afSampleTimeHours = 0:0.1/6:120;
%     iNumDwellingPlaces = double(max(L(:))-1);
%     
%     a2iDwelling = L;
%     a2iDwelling(a2iDwelling<=1) = 0;
%     a2iDwelling=a2iDwelling-1;
%     
%     figure(100+iCageIter);
%     imagesc(label2rgb(a2iDwelling, a2fColors/255,[0 0 0]));
%     axis off
%     hold on;
%     for k=1:iNumDwellingPlaces
%         [aiI,aiJ]=find(a2iDwelling==k);
%         text(mean(aiJ),mean(aiI), sprintf('%d',k-1));
%     end
%     
%     figure(200+iCageIter);
%     clf;
%     a3fTimePerc = zeros(1+iNumDwellingPlaces,length(afSampleTimeHours),iNumMice);
%     for iMouseIter = 1:4
%         
%         X=strctData.X(:,iMouseIter);
%         Y=strctData.Y(:,iMouseIter);
%         abNaN=isnan(X)|isnan(Y);
%         % Interp missing values...
%         X(abNaN) = interp1(find(~abNaN),X(~abNaN), find(abNaN));
%         Y(abNaN) = interp1(find(~abNaN),Y(~abNaN), find(abNaN));
%         
%         aiPlaces = interp2(a2iDwelling, X,Y,'nearest');
%         tightsubplot(2,2,iMouseIter,'Spacing',0.05);
%         hold on;
%         fnPlotDarkLightCycle(iNumDwellingPlaces)
%         for k=0:iNumDwellingPlaces
%             abInPlace = aiPlaces == k;
%             afTimerPercentage = conv2(double(abInPlace)', ones(1,iTimeSmoothingKernelFrames )/iTimeSmoothingKernelFrames ,'same');
%             afTimePerc = interp1(afTimeHours,afTimerPercentage,  afSampleTimeHours);
%             plot(afSampleTimeHours, double((k))+afTimePerc,'color',a2fColors(k,:)/255);
%             a3fTimePerc(1+k, :,iMouseIter) = afTimePerc;
%             drawnow
%         end
%     end
%     
%     a2fMiceColors = [1,0,0;
%         0,1,0;
%         0,0,1;
%         0,1,1];
%     
%     
%     clear a2fRGB
%     for iDwellPlace=1:iNumDwellingPlaces+1
%         X = squeeze(a3fTimePerc(iDwellPlace,:,:))';
%         for iRowIter=1:iNumMice
%             for iColor=1:3
%                 a2fRGB((iDwellPlace-1)*iNumMice+iRowIter,:,iColor) = max(0,min(1,X(iRowIter,:) * a2fMiceColors(iRowIter,iColor)));
%             end
%         end
%     end
%     figure(500+iCageIter);clf;
%     tightsubplot(1,1,1,'Spacing',0.05);hold on;
%     imagesc(afSampleTimeHours ,[0.25:0.25:double(iNumDwellingPlaces)]-1, a2fRGB   )
%     for k=0:iNumDwellingPlaces-1
%         plot([0 afSampleTimeHours(end)],0.15+[k k],'w--');
%     end
%     
%     set(gca,'ytick',[0:iNumDwellingPlaces-1],'xlim',[0 afSampleTimeHours(end)] ,'ylim',[-0.95 iNumDwellingPlaces-1]);
%     for j=0:12:120
%         plot([j j],[-1 iNumDwellingPlaces],'w');
%     end
%     
%     dbg = 1;
%     % Higher order statistics...
%     a2iPairs = nchoosek(1:4,2);
%     clear a3fCorr
%     for iDwellPlaceIter = 1:iNumDwellingPlaces
%         for iPairIter=1:size(a2iPairs,1)
%             
%             iMouseA = a2iPairs(iPairIter,1);
%             iMouseB = a2iPairs(iPairIter,2);
%             acPairIter{iPairIter} = sprintf('%d - %d',iMouseA,iMouseB);
% %             afCurve1 = conv2(a3fTimePerc(iDwellPlaceIter,:,iMouseA)', fspecial('gaussian',[50 1],4),'same');
% %             afCurve2 = conv2(a3fTimePerc(iDwellPlaceIter,:,iMouseB)', fspecial('gaussian',[50 1],4),'same');
%             afCurve1 = a3fTimePerc(iDwellPlaceIter,:,iMouseA)';
%             afCurve2 = a3fTimePerc(iDwellPlaceIter,:,iMouseB)';
%               [afCorr, afLags]=xcorr(afCurve1,afCurve2,'coeff');
%             a3fCorr(iPairIter, iDwellPlaceIter,:) = afCorr;
%         end;
%     end
%     iDwellPlaceIter = 7;
%     figure(600+iCageIter);
%     clf;
%     subplot(2,1,1);
%     plot(afLags,squeeze(a3fCorr(:,iDwellPlaceIter+1,:)));
%     hold on;
%     plot([0 0],[0 1],'w');
%     legend(acPairIter)
%     xlabel('Lag (minutes)');
%     ylabel('Correlation');
%     title(sprintf('Dwelling %d',iDwellPlaceIter));
%     subplot(2,1,2);
%       plot(afLags,squeeze(a3fCorr(:,iDwellPlaceIter+1,:)));
%     hold on;
%     plot([0 0],[0 1],'w');
%     legend(acPairIter)
%     xlabel('Lag (minutes)');
%     ylabel('Correlation');
%     axis([-400 400 0 1]);
% 
%      %%
%     % Higher order statistics...
%     a2iPairs = nchoosek(1:4,2);
%     for iPairIter = 1:size(a2iPairs,1)
%         iMouseA = a2iPairs(iPairIter,1);
%         iMouseB = a2iPairs(iPairIter,2);
%         
%         for iDwellPlaceIter1 = 1:iNumDwellingPlaces
%             for iDwellPlaceIter2= 1:iNumDwellingPlaces
%                 afCurve1 = a3fTimePerc(iDwellPlaceIter1,:,iMouseA)';
%                 afCurve2 = a3fTimePerc(iDwellPlaceIter2,:,iMouseB)';
%                 a3fCorrFixedLag(iDwellPlaceIter1,iDwellPlaceIter2,iPairIter) = corr(afCurve1,afCurve2);
%             end;
%         end
%     end
%      
%     figure(700+iCageIter);
%     clf;
%     for iPairIter=1:6
%         tightsubplot(2,3,iPairIter,'Spacing',0.1);
%         imagesc(0:iNumDwellingPlaces-1,0:iNumDwellingPlaces-1,a3fCorrFixedLag(:,:,iPairIter),[0 0.8]);
%         set(gca,'xtick',0:iNumDwellingPlaces-1,'ytick',0:iNumDwellingPlaces-1);
%         title(acPairIter{iPairIter});
%     end
%     
%     imagesc(a2fCorr)
%     
%     subplot(2,1,1);
%     plot(afLags,squeeze(a3fCorr(:,iDwellPlaceIter+1,:)));
%     hold on;
%     plot([0 0],[0 1],'w');
%     legend(acPairIter)
%     xlabel('Lag (minutes)');
%     ylabel('Correlation');
%     title(sprintf('Dwelling %d',iDwellPlaceIter));
%     subplot(2,1,2);
%       plot(afLags,squeeze(a3fCorr(:,iDwellPlaceIter+1,:)));
%     hold on;
%     plot([0 0],[0 1],'w');
%     legend(acPairIter)
%     xlabel('Lag (minutes)');
%     ylabel('Correlation');
%     axis([-400 400 0 1]);    
%     
% end
% 
% %
% %
% %              figure(12);
% %             clf;hold on;
% %             for k=1:iNumDwellingPlaces
% %                 astrctIntervals =fnMergeIntervals( fnGetIntervals(aiPlaces == k), iMergeTimeFrames);
% %                 afOnset = cat(1,astrctIntervals.m_iStart);
% %                 afOffset = cat(1,astrctIntervals.m_iEnd);
% %                 afInterVisitIntervalMin = (afOffset(2:end)-afOnset(1:end-1))/3600;
% %                 afCent = 0:0.5:180;
% %                 [aiHist]=histc(afInterVisitIntervalMin,afCent);
% %                 plot(afCent,double(k)+aiHist/max(aiHist))
% %             end
% 
% 
% %
% %         end
% %
% 
% %
% %
% % % Merge dwelling places (if possible...)
% % iPrevCC = 0;
% % clear a3iCC aiCC_To_Image
% % for k=1:4
% %     a2iFinal = a3iDweeling(:,:,k);
% %     a2iFinal(a2iFinal<=1) = 0;
% %     aiCC= setdiff(unique(a2iFinal(:)),0)-1;
% %     a3iCC(:,:,k) = a2iFinal-1+iPrevCC;
% %     aiCC_To_Image(iPrevCC+aiCC)=k;
% %     iPrevCC = iPrevCC +length(aiCC);
% % end
% % iTotalNumberCC = max(a3iCC(:));
% %
% % a2fOverlapAB = zeros(iTotalNumberCC,iTotalNumberCC);
% % for iCC1=1:iTotalNumberCC
% %     for iCC2=1:iTotalNumberCC
% %         i1=aiCC_To_Image(iCC1);
% %         i2=aiCC_To_Image(iCC2);
% %         a2iL1 = a3iCC(:,:,i1) ==iCC1 ;
% %         a2iL2 = a3iCC(:,:,i2) == iCC2;
% %         a2fOverlapAB(iCC1,iCC2) = sum(a2iL1(:) & a2iL2(:)) / sum(a2iL1(:)) * 1e2;
% %     end
% % end
% %
% % triu( a2fOverlapAB)
% % tril(a2fOverlapAB)
% %
% % figure(13);clf;
% % imagesc(1-abs(1-(a2fOverlapAB./a2fOverlapAB')),[0 0.4]);
% % colormap gray
% % impixelinfo
% 
% 
% return;
% 
% 
% function fnDisplayStatAboutFavoritePlaces(a4bFavorite)
% iNumBlocks = 120;
% iNumMice = 4;
% a2iNumCC = zeros(iNumMice,iNumBlocks);
% for iMouseIter=1:iNumMice
%     for i=1:iNumBlocks
%         [T,a2iNumCC(iMouseIter,i)]=bwlabel(a4bFavorite(:,:,iMouseIter,i)>0);
%     end
% end
% 
% figure(13);
% clf;
% for iMouseIter=1:4
%     subplot(2,2,iMouseIter);
%     T=squeeze(sum(a4bFavorite(:,:,iMouseIter,:),4));
%     imagesc(T,[0 40])
%     title(sprintf('Mouse %d',iMouseIter));
%     axis off
% end;
% 
% figure(11);
% clf;hold on;
% for k=1:iNumMice
%     subplot(iNumMice,1,k);
%     bar(a2iNumCC(k,:));
%     set(gca,'xlim',[0 120]);
% end
% return;
% 
% 
% 
% function  [a4fCumulative]=fnComputeFavoritePlaces(strctData,fTimeThresholdMin)
% % fMinX = floor(min(strctData.X(:)));
% % fMaxX = ceil(max(strctData.X(:)));
% % fMinY = floor(min(strctData.Y(:)));
% % fMaxY = ceil(max(strctData.Y(:)));
% iNumMice = size(strctData.X,2);
% iNumFrames = size(strctData.X,1);
% 
% iBlockSize = 10000;
% 
% fFPS = 30;
% iNumFramesPerMinute = fFPS * 60;
% iBlockSizeInFrames = iNumFramesPerMinute * 60;
% iNumBlocks = round(iNumFrames/iBlockSizeInFrames);
% 
% aiBlockStartFrame = 1:iBlockSizeInFrames:iNumFrames;
% a4fCumulative = zeros(768,1024,iNumMice,iNumBlocks);
% 
% 
% afProcessingTime = zeros(1,iNumBlocks);
% 
% for iBlockIter=1:iNumBlocks
%     fStartTime=cputime;
%     aiRange = aiBlockStartFrame(iBlockIter):60:min(iNumFrames,aiBlockStartFrame(iBlockIter)+iBlockSizeInFrames-1);
%     for iMouseIter=1:iNumMice
%         for iFrameIter=1:length(aiRange)
%             BW=fnEllipseToBinary(strctData.X(aiRange(iFrameIter),iMouseIter),...
%                 strctData.Y(aiRange(iFrameIter),iMouseIter),...
%                 strctData.A(aiRange(iFrameIter),iMouseIter),...
%                 strctData.B(aiRange(iFrameIter),iMouseIter),...
%                 strctData.Theta(aiRange(iFrameIter),iMouseIter),[768,1024]);
%             a4fCumulative(:,:,iMouseIter,iBlockIter)  = a4fCumulative(:,:,iMouseIter,iBlockIter)  + double(BW)/length(aiRange);
%         end;
%     end
%     
%     
%     afProcessingTime(iBlockIter) = cputime-fStartTime;
%     
%     iNumBlocksLeft =iNumBlocks - iBlockIter + 1;
%     fApproxTimetoFinish = iNumBlocksLeft*mean(afProcessingTime(1:iBlockIter)) / 60;
%     fprintf('Processing time for block %d: %.2f.  Approx time to finish job: %.2f (min) (%d blocks)\n',...
%         iBlockIter, afProcessingTime(iBlockIter),fApproxTimetoFinish,iNumBlocksLeft );
%     
% end
% return;
% %
% %
% function fnPercentTimeSpentAtFavoritePlace(strctData,a4bFavorite, fProximityThreshold)
% % Now compute time percentage spent at favorite places (as a function of time)....
% fMinX = floor(min(strctData.X(:)));
% fMaxX = ceil(max(strctData.X(:)));
% fMinY = floor(min(strctData.Y(:)));
% fMaxY = ceil(max(strctData.Y(:)));
% iNumMice = 4;
% fFPS = 30;
% iNumFramesPerMinute = fFPS * 60;
% iBlockSizeInFrames = iNumFramesPerMinute * 60;
% iNumFrames = size(strctData.X,1);
% iNumBlocks = size(a4bFavorite,4);
% 
% aiBlockStartFrame = 1:iBlockSizeInFrames:iNumFrames;
% fQuant = 100;
% 
% iTimeSmoothingKernelFrames = iNumFramesPerMinute*2;
% iNumTimePoints = 1080;
% a3fTimePercentageInHangOut = zeros(iNumBlocks,iNumMice,iNumTimePoints);
% for iBlockIter=1:iNumBlocks
%     aiRange = aiBlockStartFrame(iBlockIter):1:min(iNumFrames,aiBlockStartFrame(iBlockIter)+iBlockSizeInFrames-1);
%     
%     for iMouseIter=1:iNumMice
%         a2fDistanceToFavorite = bwdist( a4bFavorite(:,:,iMouseIter, iBlockIter));
%         afX = strctData.X(aiRange,iMouseIter)-fMinX;
%         afY = strctData.Y(aiRange,iMouseIter)-fMinY;
%         % Interpolate missing X Values....
%         afX(isnan(afX)) =  interp1(find(~isnan(afX)),afX(~isnan(afX)), find(isnan(afX)));
%         afY(isnan(afY)) =  interp1(find(~isnan(afY)),afY(~isnan(afY)), find(isnan(afY)));
%         
%         afDist =  interp2(a2fDistanceToFavorite, afX,afY);
%         abInHangOut = afDist < fProximityThreshold;
%         afTimerPercentage = conv2(double(abInHangOut)', ones(1,iTimeSmoothingKernelFrames )/iTimeSmoothingKernelFrames ,'same');
%         afTimerPercentageSmooth = conv2(afTimerPercentage, fspecial('gaussian',[1 25],3),'same');
%         %         afTime = 1:length(afTimerPercentage);
%         %         afTimeSubSampled = afTime(1:fQuant:end);
%         afTimerPercentageSmoothSubSampled = afTimerPercentageSmooth(1:fQuant:end);
%         a3fTimePercentageInHangOut(iBlockIter,iMouseIter,:) =  afTimerPercentageSmoothSubSampled;
%     end
% end
% figure(13);
% clf;
% iMouseA = 1;
% iMouseB = 2;
% for iBlockIter=1:120
%     iBlockIter = 16
%     afCorr(iBlockIter) = corr(squeeze(a3fTimePercentageInHangOut(iBlockIter,iMouseA,:)),     squeeze(a3fTimePercentageInHangOut(iBlockIter,iMouseB,:)));
% end
% plot(afCorr)
% return
% 
% 
% figure(12);
% clf;
% hold on;
% for iMouseIter=1:iNumMice
%     plot(1:length(aiRange), a2fTimePercentageInHangOut(iMouseIter,:) + iMouseIter-1)
%     plot([0 length(aiRange)],[iMouseIter-1,iMouseIter-1],'k--');
% end
% set(gca,'ytick',[0:4],'yticklabel',[],'ylim',[0 4],'xlim',[0 length(aiRange)])
% 
% %% Sensitivity to proximity threshold
% fProximityThreshold = 15;
% iTimeSmoothingKernelFrames = iNumFramesPerMinute*2;
% aiRange = aiBlockStartFrame(iBlockIter):min(iNumFrames,aiBlockStartFrame(iBlockIter)+iBlockSizeInFrames-1);
% for iMouseIter=1:iNumMice
%     afX = strctData.X(aiRange,iMouseIter)-fMinX;
%     afY = strctData.Y(aiRange,iMouseIter)-fMinY;
%     afDist =  interp2(a3fDistanceToHandOut(:,:,iHangOutOfMice), afX,afY);
%     abInHangOut = afDist < fProximityThreshold;
%     a2fTimePercentageInHangOut(iMouseIter,:) = conv2(double(abInHangOut)', ones(1,iTimeSmoothingKernelFrames )/iTimeSmoothingKernelFrames ,'same');
% end
% figure(12);
% hold on;
% for iMouseIter=1:iNumMice
%     plot(1:length(aiRange), a2fTimePercentageInHangOut(iMouseIter,:) + iMouseIter-1,'g')
% end
% 
% 
% iHangOutOfMice = 4;
% for iMouseIter=1:iNumMice
%     aiRange = aiBlockStartFrame(iBlockIter):min(iNumFrames,aiBlockStartFrame(iBlockIter)+iBlockSizeInFrames-1);
%     afX = strctData.X(aiRange,iMouseIter)-fMinX;
%     afY = strctData.Y(aiRange,iMouseIter)-fMinY;
%     subplot(4,1,iMouseIter)
%     afDist =  interp2(a3fDistanceToHandOut(:,:,iHangOutOfMice), afX,afY);
%     plot(a2fDistToHangOut(iMouseIter,:));
% end
% 
% %          [afHist,afCent] = hist(a2fDistToHangOut(:),5000);
% %          figure(11);
% %          clf;
% % %          semilogx(afCent,log10(afHist));
% %          plot(afCent,(afHist));
% %          xlabel('Distance (pixels)');
% %          ylabel('Prob');
% %          axis([0 60 0 1000]);
% %          figure;plot(a2fDistToHangOut')
% %
% %
% %
% %          fNorm=  max(a3fCumulative(:));
% %          figure(11);
% %          clf;
% %          a2iParis = nchoosek(1:4,2);
% %          a2bColors = [1,0,0;0,1,0;0,0,1;0,1,1];
% %         for j=1:4
% %             tightsubplot(1,4,j,'Spacing',0.05);
% %             X = zeros(fMaxX-fMinX,fMaxY-fMinY,3);
% %             for k=1:3
% %                 X(:,:,k) = a3fCumulative(:,:,j)*a2bColors(j,k);
% %             end
% %             X=X./fNorm;
% %             X=min(1,X*2);
% %             imagesc(X);
% %             axis off
% %         end
% %
% %
% %
% %       fNorm=  max(a3fCumulative(:));
% %          figure(11);
% %          clf;
% %          a2iParis = nchoosek(1:4,2);
% %          a2bColors = [1,0,0;0,1,0;0,0,1;0,1,1];
% %         for j=1:4
% %             tightsubplot(1,4,j,'Spacing',0.05);
% %             imagesc(a3fCumulative(:,:,j),[0 fNorm/2]);
% %             axis off
% %         end
% % %         impixelinfo
% %        colormap jet;
% % %
% %
% %       fNorm=  max(a3fCumulative(:));
% %          figure(13);
% %          clf;
% %          a2iParis = nchoosek(1:4,2);
% %          a2bColors = [1,0,0;0,1,0;0,0,1;0,1,1];
% %         for j=1:4
% %             tightsubplot(1,4,j,'Spacing',0.05);
% %             imagesc(a3bHangOutPlaces(:,:,j),[0 1]);
% %             axis off
% %         end
% % %         impixelinfo
% %        colormap gray;
% %
% %
% %
% %
% %
% %             a2fSmooth = fspecial('gaussian',[5 5]);
% %             a2fHist = conv2(hist2(strctData.X(aiRange,iMouseIter), strctData.Y(aiRange,iMouseIter), afXBins, afYBins),a2fSmooth,'same');
% %             a2fHist = a2fHist / max(a2fHist(:));
% %             [iXplc,iYplc]=ind2sub([12, 10],iBlockIter);
% %             aiXrng = 1+[(iXplc-1)*iNumXBins:(iXplc)*iNumXBins-1];
% %             aiYrng = 1+[(iYplc-1)*iNumYBins:(iYplc)*iNumYBins-1];
% %             a3fMasterPlot(aiYrng,aiXrng,iMouseIter) = a2fHist;
% %         end
% %end
% %%
% %
% %    for iMouseIter=1:4
% %         tightsubplot(iNumCages,4 ,(iCageIter-1)*iNumMice+iMouseIter,'Spacing',0.05);
% %         imagesc((a3fMasterPlot(:,:,iMouseIter).^(0.1)));
% %         colormap hot;
% %         axis off
% %    end
% %     figure(20+iCageIter);
% %    for iMouseIter=1:4
% %         subplot(2,2,iMouseIter);
% %         imagesc((a3fMasterPlot(:,:,iMouseIter).^(0.1)));
% %         colormap hot;
% %         axis off
% %    end
% %     drawnow
% 
% %%
