function fnPrepareMoviesForRoian3
%fnPrepareText()
%fnPrepareSingleMovies();
%fnPrepare4MiceMovie(true);
%fnPrepare6MiceMovie(true);
fnPrepare4MiceFollowing(true);
return

function fnPrepare4MiceFollowing(bGenerate)
if bGenerate
    Mov = avifile('C:\FollowHighRes6.avi','fps',30,'compression','xvid');
end
MovieOutputSize = 2*[384 512];
X=load('follow16_dark1.mat');
f=figure(10);
clf;
set(f,'Position',[  254   50   MovieOutputSize(2)   MovieOutputSize(1)],'color',[0 0 0]);
colormap gray
% hImage=imagesc(I1*0.01,[0 255]);
% hAxes = gca;
% axis off

%%
aiLengths = X.follow16_d1.m1m2(:,2)-X.follow16_d1.m1m2(:,1)+1;
[aiLengthSorted,aiSortInd]=sort(aiLengths,'descend');

strctRes = load('D:\Data\Janelia Farm\ResultsFromNewTrunk\cage16\b6_popcage_16_110405_09.58.30.268.mat');
strctMov = fnReadSeqInfo('E:\cage16\b6_popcage_16_110405_09.58.30.268.seq');

iInterval = 1;

iBefore = 10*5;
iAfter = 20;
iSelectedInterval = aiSortInd(iInterval);
iOriginalIntervalLength = aiLengthSorted((iInterval));
aiFrames=(X.follow16_d1.m1m2(iSelectedInterval,1))-iBefore:X.follow16_d1.m1m2(iSelectedInterval,2)+iAfter;

%%
I=fnReadFrameFromSeq(strctMov, aiFrames(1));
hImage=imshow(I,[]);
hold on;
a2fColors = [255 0 0;
             0 255 0;   
             0 0 255;
             0 255 255]/255;
         fInitialAlpha=0.3;
      
for k=1:4
      ahEllipses(k) = fnPlotEllipse2(strctRes.astrctTrackers(k).m_afX(aiFrames(1)),...
        strctRes.astrctTrackers(k).m_afY(aiFrames(1)),...
        strctRes.astrctTrackers(k).m_afA(aiFrames(1)),...
        strctRes.astrctTrackers(k).m_afB(aiFrames(1)),...
        strctRes.astrctTrackers(k).m_afTheta(aiFrames(1)), a2fColors(k,:),2, gca);
      ahTrace(k) = patchline(0,0,'edgecolor',a2fColors(k,:),'linewidth',12,'edgealpha',fInitialAlpha,'facecolor','none');
end

hold on;
for k=1:length(aiFrames)
    I=fnReadFrameFromSeq(strctMov, aiFrames(k));
      for j=1:4
    fnDrawEllipseTupleNew2(ahEllipses(j),strctRes.astrctTrackers(j).m_afX(aiFrames(k)),...
                        strctRes.astrctTrackers(j).m_afY(aiFrames(k)),...
                        strctRes.astrctTrackers(j).m_afA(aiFrames(k)),...
                        strctRes.astrctTrackers(j).m_afB(aiFrames(k)),...
                    strctRes.astrctTrackers(j).m_afTheta(aiFrames(k))+pi/2,a2fColors(j,:),2);
                if j>=3 && k >= iBefore && k <= iBefore+iOriginalIntervalLength
                    set(ahTrace(j),'xdata',[strctRes.astrctTrackers(j).m_afX(aiFrames(iBefore:k)) strctRes.astrctTrackers(j).m_afX(aiFrames(k:-1:iBefore))],...
                                'ydata',[strctRes.astrctTrackers(j).m_afY(aiFrames(iBefore:k)) strctRes.astrctTrackers(j).m_afY(aiFrames(k:-1:iBefore))]);
                end
            if j>=3 && k >= iBefore+iOriginalIntervalLength && k <= iBefore+iOriginalIntervalLength+20 
                    set(ahTrace(j),'edgealpha', fInitialAlpha*(1-(k-(iBefore+iOriginalIntervalLength))/20));
                end                
                
                
    end
    set(hImage,'cdata',I);
    drawnow
    if bGenerate
 M = getframe(gcf);
 M.cdata = imresize(M.cdata, MovieOutputSize,'bilinear');
 Mov = addframe(Mov,M);
    end    
end

 
iOriginalIntervalLength = 80;

aiFrames=99095:99095+iOriginalIntervalLength+140;
iBefore=10;
set(ahTrace(3:4),'edgealpha',fInitialAlpha,'xdata',0,'ydata',0);
hold on;
for k=1:length(aiFrames)
    I=fnReadFrameFromSeq(strctMov, aiFrames(k));
      for j=1:4
    fnDrawEllipseTupleNew2(ahEllipses(j),strctRes.astrctTrackers(j).m_afX(aiFrames(k)),...
                        strctRes.astrctTrackers(j).m_afY(aiFrames(k)),...
                        strctRes.astrctTrackers(j).m_afA(aiFrames(k)),...
                        strctRes.astrctTrackers(j).m_afB(aiFrames(k)),...
                    strctRes.astrctTrackers(j).m_afTheta(aiFrames(k))+pi/2,a2fColors(j,:),2);
                if j>=3 && k >= iBefore && k <= iBefore+iOriginalIntervalLength
                    set(ahTrace(j),'xdata',[strctRes.astrctTrackers(j).m_afX(aiFrames(iBefore:k)) strctRes.astrctTrackers(j).m_afX(aiFrames(k:-1:iBefore))],...
                                'ydata',[strctRes.astrctTrackers(j).m_afY(aiFrames(iBefore:k)) strctRes.astrctTrackers(j).m_afY(aiFrames(k:-1:iBefore))]);
                end
            if j>=3 && k >= iBefore+iOriginalIntervalLength && k <= iBefore+iOriginalIntervalLength+20 
                    set(ahTrace(j),'edgealpha', fInitialAlpha*(1-(k-(iBefore+iOriginalIntervalLength))/20));
                end                
                
                
    end
    set(hImage,'cdata',I);
    drawnow
    if bGenerate
 M = getframe(gcf);
 M.cdata = imresize(M.cdata, MovieOutputSize,'bilinear');
 Mov = addframe(Mov,M);
    end    
end

 %%
 
 
 
iOriginalIntervalLength = 80;

aiFrames=99315:99315+iOriginalIntervalLength+60;
iBefore=1;
set(ahTrace(3:4),'edgealpha',fInitialAlpha,'xdata',0,'ydata',0);
hold on;
for k=1:length(aiFrames)
    I=fnReadFrameFromSeq(strctMov, aiFrames(k));
      for j=1:4
    fnDrawEllipseTupleNew2(ahEllipses(j),strctRes.astrctTrackers(j).m_afX(aiFrames(k)),...
                        strctRes.astrctTrackers(j).m_afY(aiFrames(k)),...
                        strctRes.astrctTrackers(j).m_afA(aiFrames(k)),...
                        strctRes.astrctTrackers(j).m_afB(aiFrames(k)),...
                    strctRes.astrctTrackers(j).m_afTheta(aiFrames(k))+pi/2,a2fColors(j,:),2);
                if j>=3 && k >= iBefore && k <= iBefore+iOriginalIntervalLength
                    set(ahTrace(j),'xdata',[strctRes.astrctTrackers(j).m_afX(aiFrames(iBefore:k)) strctRes.astrctTrackers(j).m_afX(aiFrames(k:-1:iBefore))],...
                                'ydata',[strctRes.astrctTrackers(j).m_afY(aiFrames(iBefore:k)) strctRes.astrctTrackers(j).m_afY(aiFrames(k:-1:iBefore))]);
                end
            if j>=3 && k >= iBefore+iOriginalIntervalLength && k <= iBefore+iOriginalIntervalLength+20 
                    set(ahTrace(j),'edgealpha', fInitialAlpha*(1-(k-(iBefore+iOriginalIntervalLength))/20));
                end                
                
                
    end
    set(hImage,'cdata',I);
    drawnow
    if bGenerate
 M = getframe(gcf);
 M.cdata = imresize(M.cdata, MovieOutputSize,'bilinear');
 Mov = addframe(Mov,M);
    end    
end
 %%
 
 
 
iOriginalIntervalLength = 60;

aiFrames=99455:99455+iOriginalIntervalLength+180;
iBefore=1;
set(ahTrace([1,3]),'edgealpha',fInitialAlpha,'xdata',0,'ydata',0);
hold on;
for k=1:length(aiFrames)
    I=fnReadFrameFromSeq(strctMov, aiFrames(k));
      for j=1:4
    fnDrawEllipseTupleNew2(ahEllipses(j),strctRes.astrctTrackers(j).m_afX(aiFrames(k)),...
                        strctRes.astrctTrackers(j).m_afY(aiFrames(k)),...
                        strctRes.astrctTrackers(j).m_afA(aiFrames(k)),...
                        strctRes.astrctTrackers(j).m_afB(aiFrames(k)),...
                    strctRes.astrctTrackers(j).m_afTheta(aiFrames(k))+pi/2,a2fColors(j,:),2);
                if (j==3 || j == 1) && k >= iBefore && k <= iBefore+iOriginalIntervalLength
                    set(ahTrace(j),'xdata',[strctRes.astrctTrackers(j).m_afX(aiFrames(iBefore:k)) strctRes.astrctTrackers(j).m_afX(aiFrames(k:-1:iBefore))],...
                                'ydata',[strctRes.astrctTrackers(j).m_afY(aiFrames(iBefore:k)) strctRes.astrctTrackers(j).m_afY(aiFrames(k:-1:iBefore))]);
                end
            if (j==3 || j == 1)&& k >= iBefore+iOriginalIntervalLength && k <= iBefore+iOriginalIntervalLength+20 
                    set(ahTrace(j),'edgealpha', fInitialAlpha*(1-(k-(iBefore+iOriginalIntervalLength))/20));
                end                
                
                
    end
    set(hImage,'cdata',I);
    drawnow
    if bGenerate
 M = getframe(gcf);
 M.cdata = imresize(M.cdata, MovieOutputSize,'bilinear');
 Mov = addframe(Mov,M);
    end    
end
set(ahTrace(1),'visible','off');
set(ahTrace(1:4),'xdata',0,'ydata',0,'edgealpha',fInitialAlpha);

% Fade to black
aiFrames=99715:99715+100-1;
iBefore = 20;
iOriginalIntervalLength= 100;
for k=1:length(aiFrames)
    I=fnReadFrameFromSeq(strctMov, aiFrames(k));
      for j=1:4
    fnDrawEllipseTupleNew2(ahEllipses(j),strctRes.astrctTrackers(j).m_afX(aiFrames(k)),...
                        strctRes.astrctTrackers(j).m_afY(aiFrames(k)),...
                        strctRes.astrctTrackers(j).m_afA(aiFrames(k)),...
                        strctRes.astrctTrackers(j).m_afB(aiFrames(k)),...
                    strctRes.astrctTrackers(j).m_afTheta(aiFrames(k))+pi/2,a2fColors(j,:)*(1-k/100),2);
                
            if (j==2 || j == 3) && k >= iBefore && k <= iBefore+iOriginalIntervalLength
                    set(ahTrace(j),'xdata',[strctRes.astrctTrackers(j).m_afX(aiFrames(iBefore:k)) strctRes.astrctTrackers(j).m_afX(aiFrames(k:-1:iBefore))],...
                                'ydata',[strctRes.astrctTrackers(j).m_afY(aiFrames(iBefore:k)) strctRes.astrctTrackers(j).m_afY(aiFrames(k:-1:iBefore))],'edgecolor',a2fColors(j,:)*(1-k/100));
                end
            if (j==2 || j == 3)&& k >= iBefore+iOriginalIntervalLength && k <= iBefore+iOriginalIntervalLength+20 
                    set(ahTrace(j),'edgealpha', fInitialAlpha*(1-(k-(iBefore+iOriginalIntervalLength))/20),'edgecolor',a2fColors(j,:)*(1-k/100));
                end                
                   
                
    end
    set(hImage,'cdata',I*(1-k/100));
    drawnow
    if bGenerate
 M = getframe(gcf);
 M.cdata = imresize(M.cdata, MovieOutputSize,'bilinear');
 Mov = addframe(Mov,M);
    end    
end
Mov=close(Mov);
return;

function fnPrepare6MiceMovie(bGenerate)
if bGenerate
    Mov = avifile('C:\Multi6HighRes1.avi','fps',30,'compression','xvid');
end
MovieOutputSize = 2*[384 512];


strctMov1=fnReadSeqInfo('E:\6 Mice\b6_popcage_24_six_mice_2012_1023_1058.seq');
strctRes=load('E:\6 Mice\Results\b6_popcage_24_six_mice_2012_1023_1058.mat');

iCounter=10000;
I1=fnReadFrameFromSeq(strctMov1,iCounter);

f=figure(10);
clf;
set(f,'Position',[  31         284    MovieOutputSize(2)   MovieOutputSize(1)],'color',[0 0 0]);
colormap gray
hAxes=tightsubplot(2,2,1);
axes(hAxes);
hImage=imagesc(I1*0.01,[0 255]);


set(hAxes,'position',[0.35 0.23, 0.775*0.77, 0.815*0.77])

ahText(1)=tightsubplot(2,2,1);
set(ahText(1),'position',[0.35 0.86, 0.25 0.03])
ahTextHandle(1)=text(0,0.5,'Day I 00:00:00','parent',ahText(1));
set(ahTextHandle(1),'position',[0,0.5],'color','w','fontname','OCR A Std','fontsize',12,'visible','on')
set(ahText(1),'visible','off');


clear ahImages
aiPositions = linspace(0.02,0.82,6);
for iPanel=1:6
    ahPatches(iPanel)=tightsubplot(2,2,1);
    set(ahPatches(iPanel),'position',[0.05, aiPositions(iPanel), 0.25 0.15])
    axis(ahPatches(iPanel));
    ahImages(iPanel) = imagesc(zeros(51, 111,'uint8'),[0 255]);
   axis(ahPatches(iPanel),'off');
end

aiNumFrames=[200,200,600,10000,300,600,600];
a2fColors = [1,0,0;0,1,0;0,0,1;0,1,1;1,1,0;1,0,1];
axis(hAxes,'off');
for k=1:aiNumFrames(1)
    I1=fnReadFrameFromSeq(strctMov1,iCounter+k);
    iHour=0;iMin = floor((k+iCounter)/(30*60));iSec = mod(floor((k+iCounter)/(30)),60);    iFracSec = floor(33*mod(k+iCounter,30));
    
    if k<=100
    set(ahTextHandle(1),'string',sprintf('Day I %02d:%02d:%02d.%03d',iHour,iMin,iSec,iFracSec),'color',k/100*ones(1,3));
        
        set(hImage,'cdata',k/100*I1);
    else
        set(ahTextHandle(1),'string',sprintf('Day I %02d:%02d:%02d.%03d',iHour,iMin,iSec,iFracSec),'color','w');
        set(hImage,'cdata',I1);
    end
    drawnow
    if bGenerate
 M = getframe(gcf);
 M.cdata = imresize(M.cdata, MovieOutputSize,'bilinear');
 Mov = addframe(Mov,M);
    end
end
%%

axes(hAxes)
hold on;

for j=1:6
ahEllipses(j) = fnDrawEllipseTupleNew1(strctRes.astrctTrackers(j).m_afX(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afY(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afA(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afB(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afTheta(iCounter+k)+pi/2,[	255 165 0]/255,2);
end

iCounter=iCounter+k;
%set(ahTextHandle(1),'visible','on');
for k=1:aiNumFrames(2)
    iHour=0;iMin = floor((k+iCounter)/(30*60));iSec = mod(floor((k+iCounter)/(30)),60);    iFracSec = floor(33*mod(k+iCounter,30));
    set(ahTextHandle(1),'string',sprintf('Day I %02d:%02d:%02d.%03d',iHour,iMin,iSec,iFracSec));
    I1=fnReadFrameFromSeq(strctMov1,iCounter+k)    ;
    for j=1:6
    fnDrawEllipseTupleNew2(ahEllipses(j),strctRes.astrctTrackers(j).m_afX(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afY(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afA(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afB(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afTheta(iCounter+k)+pi/2,[	255 165 0]/255,2);
    end
    
    set(hImage,'cdata',I1);
    drawnow
     if bGenerate
 M = getframe(gcf);
 M.cdata = imresize(M.cdata, MovieOutputSize,'bilinear');
 Mov = addframe(Mov,M);
     end
end

strcol='rgbcym';
for j=1:6
axes(ahPatches(j));
hold on;
ah1(j,1)=plot([1 1],[1 51],strcol(j),'LineWidth',3);
ah1(j,2)=plot([111 111],[1 51],strcol(j),'LineWidth',3);
ah1(j,3)=plot([1 111],[1 1],strcol(j),'LineWidth',3);
ah1(j,4)=plot([1 111],[51 51],strcol(j),'LineWidth',3);
set(ahPatches(j),'xlim',[1 111],'ylim',[0.5 51])
axis off
end
%%

iCounter=iCounter+k;
%set(ahTextHandle(1),'visible','on');
for k=1:aiNumFrames(3)
    iHour=0;iMin = floor((k+iCounter)/(30*60));iSec = mod(floor((k+iCounter)/(30)),60);    iFracSec = floor(33*mod(k+iCounter,30));
    set(ahTextHandle(1),'string',sprintf('Day I %02d:%02d:%02d.%03d',iHour,iMin,iSec,iFracSec));
    I1=fnReadFrameFromSeq(strctMov1,iCounter+k)    ;
    for j=1:6
    fnDrawEllipseTupleNew2(ahEllipses(j),strctRes.astrctTrackers(j).m_afX(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afY(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afA(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afB(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afTheta(iCounter+k)+pi/2,strcol(j),2);
                a2iPatch = fnRectifyPatch(I1,strctRes.astrctTrackers(j).m_afX(iCounter+k),strctRes.astrctTrackers(j).m_afY(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afTheta(iCounter+k));
             set(ahImages(j),'cdata',a2iPatch);
               
    end
    
    set(hImage,'cdata',I1);
    drawnow
     if bGenerate
 M = getframe(gcf);
 M.cdata = imresize(M.cdata, MovieOutputSize,'bilinear');
 Mov = addframe(Mov,M);
     end
end
%%



iCounter=iCounter+k;
%set(ahTextHandle(1),'visible','on');
for k=1:10:aiNumFrames(4)
    iHour=0;iMin = floor((k+iCounter)/(30*60));iSec = mod(floor((k+iCounter)/(30)),60);    iFracSec = floor(33*mod(k+iCounter,30));
    set(ahTextHandle(1),'string',sprintf('Day I %02d:%02d:%02d.%03d',iHour,iMin,iSec,iFracSec));
    I1=fnReadFrameFromSeq(strctMov1,iCounter+k)    ;
    for j=1:6
    fnDrawEllipseTupleNew2(ahEllipses(j),strctRes.astrctTrackers(j).m_afX(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afY(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afA(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afB(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afTheta(iCounter+k)+pi/2,strcol(j),2);
                a2iPatch = fnRectifyPatch(I1,strctRes.astrctTrackers(j).m_afX(iCounter+k),strctRes.astrctTrackers(j).m_afY(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afTheta(iCounter+k));
             set(ahImages(j),'cdata',a2iPatch);
               
    end
    
    set(hImage,'cdata',I1);
    drawnow
     if bGenerate
 M = getframe(gcf);
 M.cdata = imresize(M.cdata, MovieOutputSize,'bilinear');
 Mov = addframe(Mov,M);
     end
end
%%

iCounter=iCounter+k;
%set(ahTextHandle(1),'visible','on');
for k=1:1:aiNumFrames(5)
    iHour=0;iMin = floor((k+iCounter)/(30*60));iSec = mod(floor((k+iCounter)/(30)),60);    iFracSec = floor(33*mod(k+iCounter,30));
    set(ahTextHandle(1),'string',sprintf('Day I %02d:%02d:%02d.%03d',iHour,iMin,iSec,iFracSec));
    I1=fnReadFrameFromSeq(strctMov1,iCounter+k)    ;
    for j=1:6
    fnDrawEllipseTupleNew2(ahEllipses(j),strctRes.astrctTrackers(j).m_afX(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afY(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afA(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afB(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afTheta(iCounter+k)+pi/2,strcol(j),2);
                a2iPatch = fnRectifyPatch(I1,strctRes.astrctTrackers(j).m_afX(iCounter+k),strctRes.astrctTrackers(j).m_afY(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afTheta(iCounter+k));
             set(ahImages(j),'cdata',a2iPatch);
               
    end
    
    set(hImage,'cdata',I1);
    drawnow
     if bGenerate
 M = getframe(gcf);
 M.cdata = imresize(M.cdata, MovieOutputSize,'bilinear');
 Mov = addframe(Mov,M);
     end
end
%%
iCounter=iCounter+500000;
%set(ahTextHandle(1),'visible','on');
for k=1:1:aiNumFrames(6)
    iHour=floor(floor((k+iCounter)/(30*60))/60);iMin = mod(floor((k+iCounter)/(30*60)),60);iSec = mod(floor((k+iCounter)/(30)),60);    iFracSec = floor(33*mod(k+iCounter,30));
    set(ahTextHandle(1),'string',sprintf('Day I %02d:%02d:%02d.%03d',iHour,iMin,iSec,iFracSec));
    I1=fnReadFrameFromSeq(strctMov1,iCounter+k)    ;
    for j=1:6
    fnDrawEllipseTupleNew2(ahEllipses(j),strctRes.astrctTrackers(j).m_afX(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afY(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afA(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afB(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afTheta(iCounter+k)+pi/2,strcol(j),2);
                a2iPatch = fnRectifyPatch(I1,strctRes.astrctTrackers(j).m_afX(iCounter+k),strctRes.astrctTrackers(j).m_afY(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afTheta(iCounter+k));
             set(ahImages(j),'cdata',a2iPatch);
               
    end
    
    set(hImage,'cdata',I1);
    drawnow
     if bGenerate
 M = getframe(gcf);
 M.cdata = imresize(M.cdata, MovieOutputSize,'bilinear');
 Mov = addframe(Mov,M);
     end
end
%%
iCounter=iCounter+500000;
%set(ahTextHandle(1),'visible','on');
for k=1:1:aiNumFrames(7)
    iHour=floor(floor((k+iCounter)/(30*60))/60);iMin = mod(floor((k+iCounter)/(30*60)),60);iSec = mod(floor((k+iCounter)/(30)),60);    iFracSec = floor(33*mod(k+iCounter,30));
    set(ahTextHandle(1),'string',sprintf('Day I %02d:%02d:%02d.%03d',iHour,iMin,iSec,iFracSec));
    I1=fnReadFrameFromSeq(strctMov1,iCounter+k)    ;
    for j=1:6
    fnDrawEllipseTupleNew2(ahEllipses(j),strctRes.astrctTrackers(j).m_afX(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afY(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afA(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afB(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afTheta(iCounter+k)+pi/2,strcol(j),2);
                a2iPatch = fnRectifyPatch(I1,strctRes.astrctTrackers(j).m_afX(iCounter+k),strctRes.astrctTrackers(j).m_afY(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afTheta(iCounter+k));
             set(ahImages(j),'cdata',a2iPatch);
               
    end
    
    set(hImage,'cdata',I1);
    drawnow
     if bGenerate
 M = getframe(gcf);
 M.cdata = imresize(M.cdata, MovieOutputSize,'bilinear');
 Mov = addframe(Mov,M);
     end
end
%% Fade to black

iCounter=iCounter+k;
%set(ahTextHandle(1),'visible','on');
for k=1:1:100
    iHour=floor(floor((k+iCounter)/(30*60))/60);iMin = mod(floor((k+iCounter)/(30*60)),60);iSec = mod(floor((k+iCounter)/(30)),60);    iFracSec = floor(33*mod(k+iCounter,30));
    set(ahTextHandle(1),'string',sprintf('Day I %02d:%02d:%02d.%03d',iHour,iMin,iSec,iFracSec),'color',(1-k/100)*ones(1,3));
    I1=fnReadFrameFromSeq(strctMov1,iCounter+k)    ;
    for j=1:6
    fnDrawEllipseTupleNew2(ahEllipses(j),strctRes.astrctTrackers(j).m_afX(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afY(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afA(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afB(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afTheta(iCounter+k)+pi/2,a2fColors(j,:)*(1-k/100),2);
                a2iPatch = fnRectifyPatch(I1,strctRes.astrctTrackers(j).m_afX(iCounter+k),strctRes.astrctTrackers(j).m_afY(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afTheta(iCounter+k));
             set(ahImages(j),'cdata',a2iPatch*(1-k/100));
             
             set(ah1(j,:),'color',    a2fColors(j,:)*(1-k/100));
    end
    
    set(hImage,'cdata',I1*(1-k/100));
    drawnow
     if bGenerate
 M = getframe(gcf);
 M.cdata = imresize(M.cdata, MovieOutputSize,'bilinear');
 Mov = addframe(Mov,M);
     end
end
Mov=close(Mov);
%%

return

function fnPrepare4MiceMovie(bGenerate)
if bGenerate
    Mov = avifile('C:\Multi4HighRes10.avi','fps',30,'compression','xvid');
end
MovieOutputSize = 2*[384 512];
%%
% strctMov1=fnReadSeqInfo('D:\Data\Janelia Farm\Movies\Cage16\b6_popcage_16_110405_21.58.39.222.seq');
% strctRes=load('D:\Data\Janelia Farm\ResultsFromNewTrunk\cage16\b6_popcage_16_110405_21.58.39.222.mat');


%aiNumFrames=[10,10,10,10,10,10,10];
aiNumFrames=[200,300,300,300,300,300,300];

strctMov1=fnReadSeqInfo('E:\cage16\b6_popcage_16_110405_09.58.30.268.seq');
strctRes=load('D:\Data\Janelia Farm\ResultsFromNewTrunk\cage16\b6_popcage_16_110405_09.58.30.268.mat');


strctMov2=fnReadSeqInfo('E:\cage16\b6_popcage_16_110405_09.58.36.238.seq');
strctRes2=load('D:\Data\Janelia Farm\ResultsFromNewTrunk\cage16\b6_popcage_16_110405_09.58.36.238.mat');

strctMov3=fnReadSeqInfo('E:\cage16\b6_popcage_16_110405_21.58.37.222.seq');
strctRes3=load('D:\Data\Janelia Farm\ResultsFromNewTrunk\cage16\b6_popcage_16_110405_21.58.37.222.mat');


%%
iCounter=10000;
I1=fnReadFrameFromSeq(strctMov1,iCounter);

f=figure(10);
clf;
set(f,'Position',[  31         284    MovieOutputSize(2)   MovieOutputSize(1)],'color',[0 0 0]);
colormap gray
hAxes=tightsubplot(2,2,1);
axes(hAxes);
hImage=imagesc(I1*0.01,[0 255]);

set(hAxes,'position',[0.35 0.33, 0.775*0.77, 0.815*0.77])


ahText(1)=tightsubplot(2,2,1);
set(ahText(1),'position',[0.05 0.96, 0.25 0.03])
ahTextHandle(1)=text(0,0.5,'Day I 00:00:00','parent',ahText(1));
set(ahTextHandle(1),'position',[0,0.5],'color','w','fontname','OCR A Std','fontsize',12,'visible','off')
set(ahText(1),'visible','off');




ahText(2)=tightsubplot(2,2,1);
set(ahText(2),'position',[0.37 0.96, 0.25 0.03])
ahTextHandle(2)=text(0,0.5,'Day 3 00:00:00','parent',ahText(2));
set(ahTextHandle(2),'position',[0,0.5],'color','w','fontname','OCR A Std','fontsize',12,'visible','off')
set(ahText(2),'visible','off');

ahText(3)=tightsubplot(2,2,1);
set(ahText(3),'position',[0.69 0.96, 0.25 0.03])
ahTextHandle(3)=text(0,0.5,'Day 5 00:00:00','parent',ahText(3));
set(ahTextHandle(3),'position',[0,0.5],'color','w','fontname','OCR A Std','fontsize',12,'visible','off')
set(ahText(3),'visible','off');

axes(hAxes);

for iPanel=1:3
    if iPanel==1
        iOffset = 0;
    elseif iPanel==2
        iOffset=0.32;
    else
        iOffset=0.64;
    end
    
    ahMovieAxes(iPanel)=tightsubplot(2,2,1);
    set(ahMovieAxes(iPanel),'position',[0.05+iOffset 0.04, 0.775*0.32, 0.815*0.32])
    axis(ahMovieAxes(iPanel));
    ahMovies(iPanel) = imagesc(zeros(768, 1024,'uint8'),[0 255]);
    axis(ahMovieAxes(iPanel),'off');

    
    ahPatches(1,iPanel)=tightsubplot(2,2,1);
    set(ahPatches(1,iPanel),'position',[0.05+iOffset, 0.81, 0.25 0.15])
    axis(ahPatches(1,iPanel));
    ahImages(1,iPanel) = imagesc(zeros(51, 111,'uint8'),[0 255]);
    axis(ahPatches(1,iPanel),'off');
    
    ahPatches(2,iPanel)=tightsubplot(2,2,1);
    set(ahPatches(2,iPanel),'position',[0.05+iOffset 0.65, 0.25 0.15])
    axis(ahPatches(2,iPanel));
    ahImages(2,iPanel) = imagesc(zeros(51, 111,'uint8'),[0 255]);
    axis(ahPatches(2,iPanel),'off');

    ahPatches(3,iPanel)=tightsubplot(2,2,1);
    set(ahPatches(3,iPanel),'position',[0.05+iOffset, 0.49, 0.25 0.15])
    axis(ahPatches(3,iPanel));
    ahImages(3,iPanel) = imagesc(zeros(51, 111,'uint8'),[0 255]);
    axis(ahPatches(3,iPanel),'off');
    ahPatches(4,iPanel)=tightsubplot(2,2,1);
    set(ahPatches(4,iPanel),'position',[0.05+iOffset, 0.33, 0.25 0.15])
    axis(ahPatches(4,iPanel));
    ahImages(4,iPanel) = imagesc(zeros(51, 111,'uint8'),[0 255]);
    axis(ahPatches(4,iPanel),'off');
end
set(ahImages(:,2:3),'visible','off')
set(ahMovies(:,2:3),'visible','off')

axis(hAxes,'off');
for k=1:aiNumFrames(1)
    I1=fnReadFrameFromSeq(strctMov1,iCounter+k);
    if k<=100
        set(hImage,'cdata',k/100*I1);
    else
        set(hImage,'cdata',I1);
    end
    drawnow
    if bGenerate
 M = getframe(gcf);
 M.cdata = imresize(M.cdata, MovieOutputSize,'bilinear');
 Mov = addframe(Mov,M);
    end
end

axes(hAxes)
hold on;

for j=1:4
ahEllipses(j) = fnDrawEllipseTupleNew1(strctRes.astrctTrackers(j).m_afX(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afY(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afA(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afB(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afTheta(iCounter+k)+pi/2,[	255 165 0]/255,2);
end

iCounter=iCounter+k;
set(ahTextHandle(1),'visible','on');
for k=1:aiNumFrames(2)
    iHour=0;iMin = floor((k+iCounter)/(30*60));iSec = mod(floor((k+iCounter)/(30)),60);    iFracSec = floor(33*mod(k+iCounter,30));
    set(ahTextHandle(1),'string',sprintf('Day I %02d:%02d:%02d.%03d',iHour,iMin,iSec,iFracSec));
    I1=fnReadFrameFromSeq(strctMov1,iCounter+k)    ;
    for j=1:4
    fnDrawEllipseTupleNew2(ahEllipses(j),strctRes.astrctTrackers(j).m_afX(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afY(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afA(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afB(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afTheta(iCounter+k)+pi/2,[	255 165 0]/255,2);
    end
    
    set(hImage,'cdata',I1);
    drawnow
     if bGenerate
 M = getframe(gcf);
 M.cdata = imresize(M.cdata, MovieOutputSize,'bilinear');
 Mov = addframe(Mov,M);
     end
end

strcol='rgbcym';

for j=1:4
axes(ahPatches(j));
hold on;
ah1(j,1)=plot([1 1],[1 51],strcol(j),'LineWidth',3);
ah1(j,2)=plot([111 111],[1 51],strcol(j),'LineWidth',3);
ah1(j,3)=plot([1 111],[1 1],strcol(j),'LineWidth',3);
ah1(j,4)=plot([1 111],[51 51],strcol(j),'LineWidth',3);
set(ahPatches(j),'xlim',[1 111],'ylim',[0.5 51])
axis off
end


iCounter=iCounter+k;
for k=1:aiNumFrames(3)
    iHour=0;iMin = floor((k+iCounter)/(30*60));iSec = mod(floor((k+iCounter)/(30)),60);    iFracSec = floor(33*mod(k+iCounter,30));
    set(ahTextHandle(1),'string',sprintf('Day I %02d:%02d:%02d.%03d',iHour,iMin,iSec,iFracSec));
    
    I1=fnReadFrameFromSeq(strctMov1,iCounter+k)    ;
    
    
    for j=1:4
    fnDrawEllipseTupleNew2(ahEllipses(j),strctRes.astrctTrackers(j).m_afX(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afY(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afA(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afB(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afTheta(iCounter+k)+pi/2,strcol(j),2);
                a2iPatch = fnRectifyPatch(I1,strctRes.astrctTrackers(j).m_afX(iCounter+k),strctRes.astrctTrackers(j).m_afY(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afTheta(iCounter+k));
                set(ahImages(j),'cdata',a2iPatch);
    end
    
    set(hImage,'cdata',I1);
    drawnow
        if bGenerate
 M = getframe(gcf);
 M.cdata = imresize(M.cdata, MovieOutputSize,'bilinear');
 Mov = addframe(Mov,M);
        end
end



iCounter=iCounter+k;
for k=1:aiNumFrames(4)
    I1=fnReadFrameFromSeq(strctMov1,iCounter+k)    ;
    
    iHour=0;iMin = floor((k+iCounter)/(30*60));iSec = mod(floor((k+iCounter)/(30)),60);    iFracSec = floor(33*mod(k+iCounter,30));
    set(ahTextHandle(1),'string',sprintf('Day I %02d:%02d:%02d.%03d',iHour,iMin,iSec,iFracSec));
    
    for j=1:4
    fnDrawEllipseTupleNew2(ahEllipses(j),strctRes.astrctTrackers(j).m_afX(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afY(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afA(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afB(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afTheta(iCounter+k)+pi/2,strcol(j),2);
                a2iPatch = fnRectifyPatch(I1,strctRes.astrctTrackers(j).m_afX(iCounter+k),strctRes.astrctTrackers(j).m_afY(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afTheta(iCounter+k));
                set(ahImages(j),'cdata',a2iPatch);
    end
    
    set(hImage,'cdata',I1);
    drawnow
        if bGenerate
 M = getframe(gcf);
 M.cdata = imresize(M.cdata, MovieOutputSize,'bilinear');
 Mov = addframe(Mov,M);
        end
end

    
%% Fade out large sequence
for iPanel=1:3
axes(ahMovieAxes(iPanel))
hold on;

for j=1:4
a2hEllipses(j,iPanel) = fnDrawEllipseTupleNew1(strctRes.astrctTrackers(j).m_afX(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afY(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afA(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afB(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afTheta(iCounter+k)+pi/2,[	255 165 0]/255,2);
end
end
set(a2hEllipses(:,2:3),'visible','off');

a2fColor = [1,0,0;0,1,0;0,0,1;0,1,1];
iCounter=iCounter+k;
%%
for k=1:1:100
    I1=fnReadFrameFromSeq(strctMov1,iCounter+k)    ;
    iHour=0;iMin = floor((k+iCounter)/(30*60));iSec = mod(floor((k+iCounter)/(30)),60);    iFracSec = floor(33*mod(k+iCounter,30));
    set(ahTextHandle(1),'string',sprintf('Day I %02d:%02d:%02d.%03d',iHour,iMin,iSec,iFracSec));
    
    
    for j=1:4
    fnDrawEllipseTupleNew2(ahEllipses(j),strctRes.astrctTrackers(j).m_afX(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afY(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afA(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afB(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afTheta(iCounter+k)+pi/2,a2fColor(j,:)*(1-k/100),2);
                a2iPatch = fnRectifyPatch(I1,strctRes.astrctTrackers(j).m_afX(iCounter+k),strctRes.astrctTrackers(j).m_afY(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afTheta(iCounter+k));
                
                
   fnDrawEllipseTupleNew2(a2hEllipses(j,1),strctRes.astrctTrackers(j).m_afX(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afY(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afA(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afB(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afTheta(iCounter+k)+pi/2,a2fColor(j,:)*(k/100),2);
                a2iPatch = fnRectifyPatch(I1,strctRes.astrctTrackers(j).m_afX(iCounter+k),strctRes.astrctTrackers(j).m_afY(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afTheta(iCounter+k));
                
                
                set(ahImages(j),'cdata',a2iPatch);
    end
    
    set(ahMovies(1),'cdata',I1*(k/100));
    
    set(hImage,'cdata',I1*(1-k/100));
    drawnow
        if bGenerate
 M = getframe(gcf);
 M.cdata = imresize(M.cdata, MovieOutputSize,'bilinear');
 Mov = addframe(Mov,M);
        end
end

%%
iCounter=iCounter+k;
for k=1:1:aiNumFrames(5)
    iHour=0;iMin = floor((k+iCounter)/(30*60));iSec = mod(floor((k+iCounter)/(30)),60);    iFracSec = floor(33*mod(k+iCounter,30));
    set(ahTextHandle(1),'string',sprintf('Day I %02d:%02d:%02d.%03d',iHour,iMin,iSec,iFracSec));
    
    I1=fnReadFrameFromSeq(strctMov1,iCounter+k)    ;
    for j=1:4
   fnDrawEllipseTupleNew2(a2hEllipses(j,1),strctRes.astrctTrackers(j).m_afX(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afY(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afA(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afB(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afTheta(iCounter+k)+pi/2,a2fColor(j,:),2);
                a2iPatch = fnRectifyPatch(I1,strctRes.astrctTrackers(j).m_afX(iCounter+k),strctRes.astrctTrackers(j).m_afY(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afTheta(iCounter+k));
                set(ahImages(j),'cdata',a2iPatch);
    end
    
    set(ahMovies(1),'cdata',I1);
      drawnow
        if bGenerate
 M = getframe(gcf);
 M.cdata = imresize(M.cdata, MovieOutputSize,'bilinear');
 Mov = addframe(Mov,M);
        end
end
%% Fade in next four panels
iCounter=iCounter+k;
for j=1:4
axes(ahPatches(j,2));
hold on;
ah2(j,1)=plot([1 1],[1 51],strcol(j),'LineWidth',3);
ah2(j,2)=plot([111 111],[1 51],strcol(j),'LineWidth',3);
ah2(j,3)=plot([1 111],[1 1],strcol(j),'LineWidth',3);
ah2(j,4)=plot([1 111],[51 51],strcol(j),'LineWidth',3);
set(ahPatches(j,2),'xlim',[1 111],'ylim',[0.5 51])
axis off
end

set(ahImages(:,2),'visible','on')
set(ahMovies(2),'visible','on')
set(ahEllipses,'visible','off');
set(a2hEllipses(:,2),'visible','on')
set(hAxes,'visible','off')
set(hImage,'visible','off')
set(ahTextHandle(2),'visible','on');
iCounter2=30000;
for k=1:1:100
    iHour=0;iMin = floor((k+iCounter)/(30*60));iSec = mod(floor((k+iCounter)/(30)),60);    iFracSec = floor(33*mod(k+iCounter,30));
    set(ahTextHandle(1),'string',sprintf('Day I %02d:%02d:%02d.%03d',iHour,iMin,iSec,iFracSec));

    iHour=0;iMin = floor((k+iCounter2)/(30*60));iSec = mod(floor((k+iCounter2)/(30)),60);    iFracSec = floor(33*mod(k+iCounter2,30));
    set(ahTextHandle(2),'string',sprintf('Day 3 %02d:%02d:%02d.%03d',iHour,iMin,iSec,iFracSec),'color',k/100*ones(1,3));
    
    I1=fnReadFrameFromSeq(strctMov1,iCounter+k)    ;
    I2=fnReadFrameFromSeq(strctMov2,iCounter2+k)    ;
    for j=1:4
   fnDrawEllipseTupleNew2(a2hEllipses(j,1),strctRes.astrctTrackers(j).m_afX(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afY(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afA(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afB(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afTheta(iCounter+k)+pi/2,a2fColor(j,:),2);
                a2iPatch = fnRectifyPatch(I1,strctRes.astrctTrackers(j).m_afX(iCounter+k),strctRes.astrctTrackers(j).m_afY(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afTheta(iCounter+k));
                set(ahImages(j,1),'cdata',a2iPatch);
    end
    
    
for j=1:4
   fnDrawEllipseTupleNew2(a2hEllipses(j,2),strctRes2.astrctTrackers(j).m_afX(iCounter2+k),...
                        strctRes2.astrctTrackers(j).m_afY(iCounter2+k),...
                        strctRes2.astrctTrackers(j).m_afA(iCounter2+k),...
                        strctRes2.astrctTrackers(j).m_afB(iCounter2+k),...
                    strctRes2.astrctTrackers(j).m_afTheta(iCounter2+k)+pi/2,a2fColor(j,:)*(k/100),2);
                a2iPatch = fnRectifyPatch(I2,strctRes2.astrctTrackers(j).m_afX(iCounter2+k),strctRes2.astrctTrackers(j).m_afY(iCounter2+k),...
                    strctRes2.astrctTrackers(j).m_afTheta(iCounter2+k));
                set(ahImages(j,2),'cdata',a2iPatch*(k/100));
    end
        
    
    set(ahMovies(1),'cdata',I1);
    set(ahMovies(2),'cdata',I2*(k/100));
      drawnow
        if bGenerate
 M = getframe(gcf);
 M.cdata = imresize(M.cdata, MovieOutputSize,'bilinear');
 Mov = addframe(Mov,M);
        end
end
%% Play some more...

iCounter=iCounter+k;
iCounter2=iCounter2+k;


for k=1:1:aiNumFrames(6)
    iHour=0;iMin = floor((k+iCounter)/(30*60));iSec = mod(floor((k+iCounter)/(30)),60);    iFracSec = floor(33*mod(k+iCounter,30));
    set(ahTextHandle(1),'string',sprintf('Day I %02d:%02d:%02d.%03d',iHour,iMin,iSec,iFracSec));

    iHour=0;iMin = floor((k+iCounter2)/(30*60));iSec = mod(floor((k+iCounter2)/(30)),60);    iFracSec = floor(33*mod(k+iCounter2,30));
    set(ahTextHandle(2),'string',sprintf('Day 3 %02d:%02d:%02d.%03d',iHour,iMin,iSec,iFracSec),'color','w');
    
    
    I1=fnReadFrameFromSeq(strctMov1,iCounter+k)    ;
    I2=fnReadFrameFromSeq(strctMov2,iCounter2+k)    ;
    for j=1:4
   fnDrawEllipseTupleNew2(a2hEllipses(j,1),strctRes.astrctTrackers(j).m_afX(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afY(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afA(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afB(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afTheta(iCounter+k)+pi/2,a2fColor(j,:),2);
                a2iPatch = fnRectifyPatch(I1,strctRes.astrctTrackers(j).m_afX(iCounter+k),strctRes.astrctTrackers(j).m_afY(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afTheta(iCounter+k));
                set(ahImages(j,1),'cdata',a2iPatch);
    end
    
    
for j=1:4
   fnDrawEllipseTupleNew2(a2hEllipses(j,2),strctRes2.astrctTrackers(j).m_afX(iCounter2+k),...
                        strctRes2.astrctTrackers(j).m_afY(iCounter2+k),...
                        strctRes2.astrctTrackers(j).m_afA(iCounter2+k),...
                        strctRes2.astrctTrackers(j).m_afB(iCounter2+k),...
                    strctRes2.astrctTrackers(j).m_afTheta(iCounter2+k)+pi/2,a2fColor(j,:),2);
                a2iPatch = fnRectifyPatch(I2,strctRes2.astrctTrackers(j).m_afX(iCounter2+k),strctRes2.astrctTrackers(j).m_afY(iCounter2+k),...
                    strctRes2.astrctTrackers(j).m_afTheta(iCounter2+k));
                set(ahImages(j,2),'cdata',a2iPatch);
    end
        
    
    set(ahMovies(1),'cdata',I1);
    set(ahMovies(2),'cdata',I2);
      drawnow
        if bGenerate
 M = getframe(gcf);
 M.cdata = imresize(M.cdata, MovieOutputSize,'bilinear');
 Mov = addframe(Mov,M);
        end
end
%% Start day 5

for j=1:4
axes(ahPatches(j,3));
hold on;
ah3(j,1)=plot([1 1],[1 51],strcol(j),'LineWidth',3);
ah3(j,2)=plot([111 111],[1 51],strcol(j),'LineWidth',3);
ah3(j,3)=plot([1 111],[1 1],strcol(j),'LineWidth',3);
ah3(j,4)=plot([1 111],[51 51],strcol(j),'LineWidth',3);
set(ahPatches(j,3),'xlim',[1 111],'ylim',[0.5 51])
axis off
end

set(ahImages(:,3),'visible','on')
set(ahMovies(3),'visible','on')
set(a2hEllipses(:,3),'visible','on')
set(ahTextHandle(3),'visible','on');

iCounter=iCounter+k;
iCounter2=iCounter2+k;
iCounter3=5000;

for k=1:1:100
    iHour=0;iMin = floor((k+iCounter)/(30*60));iSec = mod(floor((k+iCounter)/(30)),60);    iFracSec = floor(33*mod(k+iCounter,30));
    set(ahTextHandle(1),'string',sprintf('Day I %02d:%02d:%02d.%03d',iHour,iMin,iSec,iFracSec));

    iHour=0;iMin = floor((k+iCounter2)/(30*60));iSec = mod(floor((k+iCounter2)/(30)),60);    iFracSec = floor(33*mod(k+iCounter2,30));
    set(ahTextHandle(2),'string',sprintf('Day 3 %02d:%02d:%02d.%03d',iHour,iMin,iSec,iFracSec),'color','w');
  
    iHour=0;iMin = floor((k+iCounter3)/(30*60));iSec = mod(floor((k+iCounter3)/(30)),60);    iFracSec = floor(33*mod(k+iCounter3,30));
    set(ahTextHandle(3),'string',sprintf('Day 5 %02d:%02d:%02d.%03d',iHour,iMin,iSec,iFracSec),'color',k/100*ones(1,3));
    
    I1=fnReadFrameFromSeq(strctMov1,iCounter+k)    ;
    I2=fnReadFrameFromSeq(strctMov2,iCounter2+k)    ;
    I3=fnReadFrameFromSeq(strctMov3,iCounter3+k)    ;
    
    for j=1:4
   fnDrawEllipseTupleNew2(a2hEllipses(j,1),strctRes.astrctTrackers(j).m_afX(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afY(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afA(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afB(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afTheta(iCounter+k)+pi/2,a2fColor(j,:),2);
                a2iPatch = fnRectifyPatch(I1,strctRes.astrctTrackers(j).m_afX(iCounter+k),strctRes.astrctTrackers(j).m_afY(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afTheta(iCounter+k));
                set(ahImages(j,1),'cdata',a2iPatch);
    end
    
    
for j=1:4
   fnDrawEllipseTupleNew2(a2hEllipses(j,2),strctRes2.astrctTrackers(j).m_afX(iCounter2+k),...
                        strctRes2.astrctTrackers(j).m_afY(iCounter2+k),...
                        strctRes2.astrctTrackers(j).m_afA(iCounter2+k),...
                        strctRes2.astrctTrackers(j).m_afB(iCounter2+k),...
                    strctRes2.astrctTrackers(j).m_afTheta(iCounter2+k)+pi/2,a2fColor(j,:),2);
                a2iPatch = fnRectifyPatch(I2,strctRes2.astrctTrackers(j).m_afX(iCounter2+k),strctRes2.astrctTrackers(j).m_afY(iCounter2+k),...
                    strctRes2.astrctTrackers(j).m_afTheta(iCounter2+k));
                set(ahImages(j,2),'cdata',a2iPatch);
end
        
    
  
for j=1:4
   fnDrawEllipseTupleNew2(a2hEllipses(j,3),strctRes3.astrctTrackers(j).m_afX(iCounter3+k),...
                        strctRes3.astrctTrackers(j).m_afY(iCounter3+k),...
                        strctRes3.astrctTrackers(j).m_afA(iCounter3+k),...
                        strctRes3.astrctTrackers(j).m_afB(iCounter3+k),...
                    strctRes3.astrctTrackers(j).m_afTheta(iCounter3+k)+pi/2,a2fColor(j,:)*k/100,2);
                a2iPatch = fnRectifyPatch(I3,strctRes3.astrctTrackers(j).m_afX(iCounter3+k),strctRes3.astrctTrackers(j).m_afY(iCounter3+k),...
                    strctRes3.astrctTrackers(j).m_afTheta(iCounter3+k));
                set(ahImages(j,3),'cdata',a2iPatch*k/100);
    end

    
    set(ahMovies(1),'cdata',I1);
    set(ahMovies(2),'cdata',I2);
    set(ahMovies(3),'cdata',I3*(k/100));
      drawnow
        if bGenerate
 M = getframe(gcf);
 M.cdata = imresize(M.cdata, MovieOutputSize,'bilinear');
 Mov = addframe(Mov,M);
        end
end
%% Play all three

iCounter=iCounter+k;
iCounter2=iCounter2+k;
iCounter3=iCounter3+k;

for k=1:1:aiNumFrames(7)
    iHour=0;iMin = floor((k+iCounter)/(30*60));iSec = mod(floor((k+iCounter)/(30)),60);    iFracSec = floor(33*mod(k+iCounter,30));
    set(ahTextHandle(1),'string',sprintf('Day I %02d:%02d:%02d.%03d',iHour,iMin,iSec,iFracSec));

    iHour=0;iMin = floor((k+iCounter2)/(30*60));iSec = mod(floor((k+iCounter2)/(30)),60);    iFracSec = floor(33*mod(k+iCounter2,30));
    set(ahTextHandle(2),'string',sprintf('Day 3 %02d:%02d:%02d.%03d',iHour,iMin,iSec,iFracSec),'color','w');
  
    iHour=0;iMin = floor((k+iCounter3)/(30*60));iSec = mod(floor((k+iCounter3)/(30)),60);    iFracSec = floor(33*mod(k+iCounter3,30));
    set(ahTextHandle(3),'string',sprintf('Day 5 %02d:%02d:%02d.%03d',iHour,iMin,iSec,iFracSec),'color','w');
    
    I1=fnReadFrameFromSeq(strctMov1,iCounter+k)    ;
    I2=fnReadFrameFromSeq(strctMov2,iCounter2+k)    ;
    I3=fnReadFrameFromSeq(strctMov3,iCounter3+k)    ;
    
    for j=1:4
   fnDrawEllipseTupleNew2(a2hEllipses(j,1),strctRes.astrctTrackers(j).m_afX(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afY(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afA(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afB(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afTheta(iCounter+k)+pi/2,a2fColor(j,:),2);
                a2iPatch = fnRectifyPatch(I1,strctRes.astrctTrackers(j).m_afX(iCounter+k),strctRes.astrctTrackers(j).m_afY(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afTheta(iCounter+k));
                set(ahImages(j,1),'cdata',a2iPatch);
    end
    
    
for j=1:4
   fnDrawEllipseTupleNew2(a2hEllipses(j,2),strctRes2.astrctTrackers(j).m_afX(iCounter2+k),...
                        strctRes2.astrctTrackers(j).m_afY(iCounter2+k),...
                        strctRes2.astrctTrackers(j).m_afA(iCounter2+k),...
                        strctRes2.astrctTrackers(j).m_afB(iCounter2+k),...
                    strctRes2.astrctTrackers(j).m_afTheta(iCounter2+k)+pi/2,a2fColor(j,:),2);
                a2iPatch = fnRectifyPatch(I2,strctRes2.astrctTrackers(j).m_afX(iCounter2+k),strctRes2.astrctTrackers(j).m_afY(iCounter2+k),...
                    strctRes2.astrctTrackers(j).m_afTheta(iCounter2+k));
                set(ahImages(j,2),'cdata',a2iPatch);
end
        
    
  
for j=1:4
   fnDrawEllipseTupleNew2(a2hEllipses(j,3),strctRes3.astrctTrackers(j).m_afX(iCounter3+k),...
                        strctRes3.astrctTrackers(j).m_afY(iCounter3+k),...
                        strctRes3.astrctTrackers(j).m_afA(iCounter3+k),...
                        strctRes3.astrctTrackers(j).m_afB(iCounter3+k),...
                    strctRes3.astrctTrackers(j).m_afTheta(iCounter3+k)+pi/2,a2fColor(j,:),2);
                a2iPatch = fnRectifyPatch(I3,strctRes3.astrctTrackers(j).m_afX(iCounter3+k),strctRes3.astrctTrackers(j).m_afY(iCounter3+k),...
                    strctRes3.astrctTrackers(j).m_afTheta(iCounter3+k));
                set(ahImages(j,3),'cdata',a2iPatch);
    end

    
    set(ahMovies(1),'cdata',I1);
    set(ahMovies(2),'cdata',I2);
    set(ahMovies(3),'cdata',I3);
      drawnow
        if bGenerate
 M = getframe(gcf);
 M.cdata = imresize(M.cdata, MovieOutputSize,'bilinear');
 Mov = addframe(Mov,M);
        end
end
%% Fade to black...
set(ah1,'visible','off')
set(ah2,'visible','off')
set(ah3,'visible','off')

iCounter=iCounter+k;
iCounter2=iCounter2+k;
iCounter3=iCounter3+k;

for k=1:1:100
    iHour=0;iMin = floor((k+iCounter)/(30*60));iSec = mod(floor((k+iCounter)/(30)),60);    iFracSec = floor(33*mod(k+iCounter,30));
    set(ahTextHandle(1),'string',sprintf('Day I %02d:%02d:%02d.%03d',iHour,iMin,iSec,iFracSec),'color',1-k/100*ones(1,3));

    iHour=0;iMin = floor((k+iCounter2)/(30*60));iSec = mod(floor((k+iCounter2)/(30)),60);    iFracSec = floor(33*mod(k+iCounter2,30));
    set(ahTextHandle(2),'string',sprintf('Day 3 %02d:%02d:%02d.%03d',iHour,iMin,iSec,iFracSec),'color',1-k/100*ones(1,3));
  
    iHour=0;iMin = floor((k+iCounter3)/(30*60));iSec = mod(floor((k+iCounter3)/(30)),60);    iFracSec = floor(33*mod(k+iCounter3,30));
    set(ahTextHandle(3),'string',sprintf('Day 5 %02d:%02d:%02d.%03d',iHour,iMin,iSec,iFracSec),'color',1-k/100*ones(1,3));
    
    I1=fnReadFrameFromSeq(strctMov1,iCounter+k)    ;
    I2=fnReadFrameFromSeq(strctMov2,iCounter2+k)    ;
    I3=fnReadFrameFromSeq(strctMov3,iCounter3+k)    ;
    
    for j=1:4
   fnDrawEllipseTupleNew2(a2hEllipses(j,1),strctRes.astrctTrackers(j).m_afX(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afY(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afA(iCounter+k),...
                        strctRes.astrctTrackers(j).m_afB(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afTheta(iCounter+k)+pi/2,a2fColor(j,:)*(1-k/100),2);
                a2iPatch = fnRectifyPatch(I1,strctRes.astrctTrackers(j).m_afX(iCounter+k),strctRes.astrctTrackers(j).m_afY(iCounter+k),...
                    strctRes.astrctTrackers(j).m_afTheta(iCounter+k));
                set(ahImages(j,1),'cdata',a2iPatch*(1-k/100));
    end
    
    
for j=1:4
   fnDrawEllipseTupleNew2(a2hEllipses(j,2),strctRes2.astrctTrackers(j).m_afX(iCounter2+k),...
                        strctRes2.astrctTrackers(j).m_afY(iCounter2+k),...
                        strctRes2.astrctTrackers(j).m_afA(iCounter2+k),...
                        strctRes2.astrctTrackers(j).m_afB(iCounter2+k),...
                    strctRes2.astrctTrackers(j).m_afTheta(iCounter2+k)+pi/2,a2fColor(j,:)*(1-k/100),2);
                a2iPatch = fnRectifyPatch(I2,strctRes2.astrctTrackers(j).m_afX(iCounter2+k),strctRes2.astrctTrackers(j).m_afY(iCounter2+k),...
                    strctRes2.astrctTrackers(j).m_afTheta(iCounter2+k));
                set(ahImages(j,2),'cdata',a2iPatch*(1-k/100));
end
        
    
  
for j=1:4
   fnDrawEllipseTupleNew2(a2hEllipses(j,3),strctRes3.astrctTrackers(j).m_afX(iCounter3+k),...
                        strctRes3.astrctTrackers(j).m_afY(iCounter3+k),...
                        strctRes3.astrctTrackers(j).m_afA(iCounter3+k),...
                        strctRes3.astrctTrackers(j).m_afB(iCounter3+k),...
                    strctRes3.astrctTrackers(j).m_afTheta(iCounter3+k)+pi/2,a2fColor(j,:)*(1-k/100),2);
                a2iPatch = fnRectifyPatch(I3,strctRes3.astrctTrackers(j).m_afX(iCounter3+k),strctRes3.astrctTrackers(j).m_afY(iCounter3+k),...
                    strctRes3.astrctTrackers(j).m_afTheta(iCounter3+k));
                set(ahImages(j,3),'cdata',a2iPatch*(1-k/100));
    end

    
    set(ahMovies(1),'cdata',I1*(1-k/100));
    set(ahMovies(2),'cdata',I2*(1-k/100));
    set(ahMovies(3),'cdata',I3*(1-k/100));
      drawnow
        if bGenerate
 M = getframe(gcf);
 M.cdata = imresize(M.cdata, MovieOutputSize,'bilinear');
 Mov = addframe(Mov,M);
        end
end
%%
    if bGenerate
Mov=close(Mov);
    end
    
    
return


function fnPrepareSingleMovies()
Mov = avifile('C:\SinglesHighRes2.avi','fps',30,'compression','xvid');

strctMov1 = fnReadSeqInfo('D:\Data\Janelia Farm\Movies\Cage16\b6_popcage_16_singles_dg.seq');
strctMov2 = fnReadSeqInfo('D:\Data\Janelia Farm\Movies\Cage16\b6_popcage_16_singles_hs.seq');
strctMov3 = fnReadSeqInfo('D:\Data\Janelia Farm\Movies\Cage16\b6_popcage_16_singles_sp.seq');
strctMov4 = fnReadSeqInfo('D:\Data\Janelia Farm\Movies\Cage16\b6_popcage_16_singles_vs.seq');

strctRes1 = load('D:\Data\Janelia Farm\Movies\Cage16\b6_popcage_16_singles_dg\Identities.mat');
strctRes2 = load('D:\Data\Janelia Farm\Movies\Cage16\b6_popcage_16_singles_hs\Identities.mat');
strctRes3 = load('D:\Data\Janelia Farm\Movies\Cage16\b6_popcage_16_singles_sp\Identities.mat');
strctRes4 = load('D:\Data\Janelia Farm\Movies\Cage16\b6_popcage_16_singles_vs\Identities.mat');

MovieOutputSize = 2*[384 512];
%%
    I1=fnReadFrameFromSeq(strctMov1,1);

f=figure(10);
clf;
set(f,'Position',[  254   50   MovieOutputSize(2)   MovieOutputSize(1)],'color',[0 0 0]);
colormap gray
hImage=imagesc(I1*0.01,[0 255]);
hAxes = gca;
axis off
for k=1:100
set(hImage,'cdata',k/100*I1);
drawnow

M = getframe(gcf);
M.cdata = imresize(M.cdata, MovieOutputSize,'bilinear');
Mov = addframe(Mov,M);

end


for k=1:200
    I=fnReadFrameFromSeq(strctMov1,k);
    set(hImage,'cdata',I);

    drawnow
M = getframe(gcf);
M.cdata = imresize(M.cdata, MovieOutputSize,'bilinear');
Mov = addframe(Mov,M);

end
hold on;
k=200;
hEllipse = fnDrawEllipseTupleNew1(strctRes1.strctIdentity.m_afX(k),...
                    strctRes1.strctIdentity.m_afY(k),...
                    strctRes1.strctIdentity.m_afA(k),...
                    strctRes1.strctIdentity.m_afB(k),...
                    strctRes1.strctIdentity.m_afTheta(k)+pi/2,'r',2);
hTrace = plot(strctRes1.strctIdentity.m_afX(k),strctRes1.strctIdentity.m_afY(k),'r');

for k=200:600
    I=fnReadFrameFromSeq(strctMov1,k);
    set(hImage,'cdata',I);
    fnDrawEllipseTupleNew2(hEllipse ,strctRes1.strctIdentity.m_afX(k),...
                    strctRes1.strctIdentity.m_afY(k),...
                    strctRes1.strctIdentity.m_afA(k),...
                    strctRes1.strctIdentity.m_afB(k),...
                    strctRes1.strctIdentity.m_afTheta(k)+pi/2,'r',2);
    set(hTrace,'xdata',strctRes1.strctIdentity.m_afX(k-40:k),'ydata',strctRes1.strctIdentity.m_afY(k-40:k));

    drawnow
M = getframe(gcf);
M.cdata = imresize(M.cdata, MovieOutputSize,'bilinear');
Mov = addframe(Mov,M);

end

set(gca,'position',[0.13 0.11 0.775 0.815])
Nsteps= 100;
afRange = linspace(1,0.5, Nsteps);
iCounter=1;
for k=600:600+Nsteps-1
    I=fnReadFrameFromSeq(strctMov1,k);
    set(hImage,'cdata',I);
    fnDrawEllipseTupleNew2(hEllipse ,strctRes1.strctIdentity.m_afX(k),...
                    strctRes1.strctIdentity.m_afY(k),...
                    strctRes1.strctIdentity.m_afA(k),...
                    strctRes1.strctIdentity.m_afB(k),...
                    strctRes1.strctIdentity.m_afTheta(k)+pi/2,'r',2);
    set(hTrace,'xdata',strctRes1.strctIdentity.m_afX(k-40:k),'ydata',strctRes1.strctIdentity.m_afY(k-40:k));
    set(gca,'position',[0.13 0.11 0.775*afRange(iCounter) 0.815*afRange(iCounter)])    
    iCounter=iCounter+1;
    drawnow
M = getframe(gcf);
M.cdata = imresize(M.cdata, MovieOutputSize,'bilinear');
Mov = addframe(Mov,M);

end

iCounter = 1;
iCounter2 = 350;
iCounter3 = 1000;
iCounter4 = 1300;

% Fade in other movies...
I2 = fnReadFrameFromSeq(strctMov2,iCounter2);
I3 = fnReadFrameFromSeq(strctMov3,iCounter3);
I4 = fnReadFrameFromSeq(strctMov4,iCounter4);
hAxes2 = tightsubplot(2,2,1);
set(hAxes2,'Position',[0.13 0.55 0.775*0.5, 0.815*0.5]);
hAxes3 = tightsubplot(2,2,1);
set(hAxes3,'Position',[0.53 0.55 0.775*0.5, 0.815*0.5]);
hAxes4 = tightsubplot(2,2,1);
set(hAxes4,'Position',[0.53 0.11 0.775*0.5, 0.815*0.5]);
axes(hAxes2);
hImage2 = imagesc(I2*0,[0 255]);
axes(hAxes3);
hImage3 = imagesc(I3*0,[0 255]);
axes(hAxes4);
hImage4 = imagesc(I4*0, [0 255]);
axis(hAxes2,'off');
axis(hAxes3,'off');
axis(hAxes4,'off');


for k=1000:1200
    I=fnReadFrameFromSeq(strctMov1,k);
    set(hImage,'cdata',I);
    fnDrawEllipseTupleNew2(hEllipse ,strctRes1.strctIdentity.m_afX(k),...
                    strctRes1.strctIdentity.m_afY(k),...
                    strctRes1.strctIdentity.m_afA(k),...
                    strctRes1.strctIdentity.m_afB(k),...
                    strctRes1.strctIdentity.m_afTheta(k)+pi/2,'r',2);
    set(hTrace,'xdata',strctRes1.strctIdentity.m_afX(k-40:k),'ydata',strctRes1.strctIdentity.m_afY(k-40:k));

set(hImage2,'cdata',iCounter/200*I2);
set(hImage3,'cdata',iCounter/200*I3);
set(hImage4,'cdata',iCounter/200*I4);
iCounter=iCounter+1;
    drawnow
M = getframe(gcf);
M.cdata = imresize(M.cdata, MovieOutputSize,'bilinear');
Mov = addframe(Mov,M);

end

axes(hAxes2);
hold on;
hEllipse2 = fnDrawEllipseTupleNew1(strctRes2.strctIdentity.m_afX(iCounter2),...
                    strctRes2.strctIdentity.m_afY(iCounter2),...
                    strctRes2.strctIdentity.m_afA(iCounter2),...
                    strctRes2.strctIdentity.m_afB(iCounter2),...
                    strctRes2.strctIdentity.m_afTheta(iCounter2)+pi/2,'g',2);
hTrace2 = plot(strctRes2.strctIdentity.m_afX(iCounter2),strctRes2.strctIdentity.m_afY(iCounter2),'g');
axes(hAxes3);
hold on;
hEllipse3 = fnDrawEllipseTupleNew1(strctRes3.strctIdentity.m_afX(iCounter3),...
                    strctRes3.strctIdentity.m_afY(iCounter3),...
                    strctRes3.strctIdentity.m_afA(iCounter3),...
                    strctRes3.strctIdentity.m_afB(iCounter3),...
                    strctRes3.strctIdentity.m_afTheta(iCounter3)+pi/2,'b',2);
hTrace3 = plot(strctRes3.strctIdentity.m_afX(iCounter3),strctRes3.strctIdentity.m_afY(iCounter3),'b');
axes(hAxes4);
hold on;
hEllipse4 = fnDrawEllipseTupleNew1(strctRes4.strctIdentity.m_afX(iCounter4),...
                    strctRes4.strctIdentity.m_afY(iCounter4),...
                    strctRes4.strctIdentity.m_afA(iCounter4),...
                    strctRes4.strctIdentity.m_afB(iCounter4),...
                    strctRes4.strctIdentity.m_afTheta(iCounter4)+pi/2,'c',2);
hTrace4 = plot(strctRes4.strctIdentity.m_afX(iCounter4),strctRes4.strctIdentity.m_afY(iCounter4),'c');




for k=1200:1600
    I1=fnReadFrameFromSeq(strctMov1,k);
    set(hImage,'cdata',I1);
    fnDrawEllipseTupleNew2(hEllipse ,strctRes1.strctIdentity.m_afX(k),...
                    strctRes1.strctIdentity.m_afY(k),...
                    strctRes1.strctIdentity.m_afA(k),...
                    strctRes1.strctIdentity.m_afB(k),...
                    strctRes1.strctIdentity.m_afTheta(k)+pi/2,'r',2);
    set(hTrace,'xdata',strctRes1.strctIdentity.m_afX(k-40:k),'ydata',strctRes1.strctIdentity.m_afY(k-40:k));

    I2=fnReadFrameFromSeq(strctMov2,iCounter2);
    set(hImage2,'cdata',I2);
    fnDrawEllipseTupleNew2(hEllipse2 ,strctRes2.strctIdentity.m_afX(iCounter2 ),...
                    strctRes2.strctIdentity.m_afY(iCounter2 ),...
                    strctRes2.strctIdentity.m_afA(iCounter2 ),...
                    strctRes2.strctIdentity.m_afB(iCounter2 ),...
                    strctRes2.strctIdentity.m_afTheta(iCounter2 )+pi/2,'g',2);
                if iCounter2  > 41
            set(hTrace2,'xdata',strctRes2.strctIdentity.m_afX(iCounter2 -40:iCounter2 ),'ydata',strctRes2.strctIdentity.m_afY(iCounter2 -40:iCounter2 ));
                end

    I3=fnReadFrameFromSeq(strctMov3,iCounter3);
    set(hImage3,'cdata',I3);
    fnDrawEllipseTupleNew2(hEllipse3 ,strctRes3.strctIdentity.m_afX(iCounter3 ),...
                    strctRes3.strctIdentity.m_afY(iCounter3 ),...
                    strctRes3.strctIdentity.m_afA(iCounter3 ),...
                    strctRes3.strctIdentity.m_afB(iCounter3),...
                    strctRes3.strctIdentity.m_afTheta(iCounter3 )+pi/2,'b',2);
                if iCounter3  > 41
            set(hTrace3,'xdata',strctRes3.strctIdentity.m_afX(iCounter3 -40:iCounter3 ),'ydata',strctRes3.strctIdentity.m_afY(iCounter3 -40:iCounter3 ));
                end
                
    I4=fnReadFrameFromSeq(strctMov4,iCounter4);
    set(hImage4,'cdata',I4);
    fnDrawEllipseTupleNew2(hEllipse4 ,strctRes4.strctIdentity.m_afX(iCounter4 ),...
                    strctRes4.strctIdentity.m_afY(iCounter4 ),...
                    strctRes4.strctIdentity.m_afA(iCounter4 ),...
                    strctRes4.strctIdentity.m_afB(iCounter4 ),...
                    strctRes4.strctIdentity.m_afTheta(iCounter4 )+pi/2,'c',2);
                if iCounter4  > 41
            set(hTrace4,'xdata',strctRes4.strctIdentity.m_afX(iCounter4 -40:iCounter4 ),'ydata',strctRes4.strctIdentity.m_afY(iCounter4 -40:iCounter4 ));
                end
                
    iCounter2=iCounter2+1;
    iCounter3=iCounter3+1;
    iCounter4=iCounter4+1;
    drawnow
M = getframe(gcf);
M.cdata = imresize(M.cdata, MovieOutputSize,'bilinear');
Mov = addframe(Mov,M);

end




%
for k=1600:1800
    I1=fnReadFrameFromSeq(strctMov1,k);
    set(hImage,'cdata',I1);
    
    fnDrawRotatedRect(hEllipse,strctRes1.strctIdentity.m_afX(k),...
                    strctRes1.strctIdentity.m_afY(k),...
                    strctRes1.strctIdentity.m_afTheta(k),'r',2);
    set(hTrace,'xdata',strctRes1.strctIdentity.m_afX(k-40:k),'ydata',strctRes1.strctIdentity.m_afY(k-40:k));

    I2=fnReadFrameFromSeq(strctMov2,iCounter2);
    set(hImage2,'cdata',I2);
    fnDrawRotatedRect(hEllipse2,strctRes2.strctIdentity.m_afX(iCounter2),...
                    strctRes2.strctIdentity.m_afY(iCounter2),...
                    strctRes2.strctIdentity.m_afTheta(iCounter2),'g',2);

    if iCounter2  > 41
            set(hTrace2,'xdata',strctRes2.strctIdentity.m_afX(iCounter2 -40:iCounter2 ),'ydata',strctRes2.strctIdentity.m_afY(iCounter2 -40:iCounter2 ));
                end

    I3=fnReadFrameFromSeq(strctMov3,iCounter3);
    set(hImage3,'cdata',I3);
    fnDrawRotatedRect(hEllipse3,strctRes3.strctIdentity.m_afX(iCounter3),...
                    strctRes3.strctIdentity.m_afY(iCounter3),...
                    strctRes3.strctIdentity.m_afTheta(iCounter3),'b',2);

    
    if iCounter3  > 41
            set(hTrace3,'xdata',strctRes3.strctIdentity.m_afX(iCounter3 -40:iCounter3 ),'ydata',strctRes3.strctIdentity.m_afY(iCounter3 -40:iCounter3 ));
                end
                
    I4=fnReadFrameFromSeq(strctMov4,iCounter4);
    set(hImage4,'cdata',I4);

        fnDrawRotatedRect(hEllipse4,strctRes4.strctIdentity.m_afX(iCounter4),...
                    strctRes4.strctIdentity.m_afY(iCounter4),...
                    strctRes4.strctIdentity.m_afTheta(iCounter4),'c',2);

    if iCounter4  > 41
            set(hTrace4,'xdata',strctRes4.strctIdentity.m_afX(iCounter4 -40:iCounter4 ),'ydata',strctRes4.strctIdentity.m_afY(iCounter4 -40:iCounter4 ));
                end
                
    iCounter2=iCounter2+1;
    iCounter3=iCounter3+1;
    iCounter4=iCounter4+1;
    drawnow
M = getframe(gcf);
M.cdata = imresize(M.cdata, MovieOutputSize,'bilinear');
Mov = addframe(Mov,M);

end









set(hTrace,'visible','off')
set(hTrace2,'visible','off')
set(hTrace3,'visible','off')
set(hTrace4,'visible','off')

set(hEllipse,'visible','off')
set(hEllipse2,'visible','off')
set(hEllipse3,'visible','off')
set(hEllipse4,'visible','off')

iCounter1 = 4000+Nsteps;
set(hImage,'cdata',strctRes1.strctIdentity.m_a3iPatches(:,:,iCounter1))
set(hImage2,'cdata',strctRes2.strctIdentity.m_a3iPatches(:,:,iCounter2))
set(hImage3,'cdata',strctRes3.strctIdentity.m_a3iPatches(:,:,iCounter3))
set(hImage4,'cdata',strctRes4.strctIdentity.m_a3iPatches(:,:,iCounter4))

set(hAxes,'xlim',[1 111],'ylim',[1 51]);
set(hAxes2,'xlim',[1 111],'ylim',[1 51]);
set(hAxes3,'xlim',[1 111],'ylim',[1 51]);
set(hAxes4,'xlim',[1 111],'ylim',[1 51]);
%%

axis(hAxes,'equal')
axis(hAxes2,'equal')
axis(hAxes3,'equal')
axis(hAxes4,'equal')

axes(hAxes)
ah1(1)=plot([1 1],[1 51],'r','LineWidth',3);
ah1(2)=plot([111 111],[1 51],'r','LineWidth',3);
ah1(3)=plot([1 111],[1 1],'r','LineWidth',3);
ah1(4)=plot([1 111],[51 51],'r','LineWidth',3);
set(gca,'xlim',[1 111],'ylim',[1 51])

axes(hAxes2)
ah2(1)=plot([1 1],[1 51],'g','LineWidth',3);
ah2(2)=plot([111 111],[1 51],'g','LineWidth',3);
ah2(3)=plot([1 111],[1 1],'g','LineWidth',3);
ah2(4)=plot([1 111],[51 51],'g','LineWidth',3);
set(gca,'xlim',[1 111],'ylim',[1 51])

axes(hAxes3)
ah3(1)=plot([1 1],[1 51],'b','LineWidth',3);
ah3(2)=plot([111 111],[1 51],'b','LineWidth',3);
ah3(3)=plot([1 111],[1 1],'b','LineWidth',3);
ah3(4)=plot([1 111],[51 51],'b','LineWidth',3);
set(gca,'xlim',[1 111],'ylim',[1 51])

axes(hAxes4)
ah4(1)=plot([1 1],[1 51],'c','LineWidth',3);
ah4(2)=plot([111 111],[1 51],'c','LineWidth',3);
ah4(3)=plot([1 111],[1 1],'c','LineWidth',3);
ah4(4)=plot([1 111],[51 51],'c','LineWidth',3);
set(gca,'xlim',[1 111],'ylim',[1 51])

iCounter3 = 3000;
for iIter=1:600
    set(hImage,'cdata',strctRes1.strctIdentity.m_a3iPatches(:,:,iCounter1))
    set(hImage2,'cdata',strctRes2.strctIdentity.m_a3iPatches(:,:,iCounter2))
    set(hImage3,'cdata',strctRes3.strctIdentity.m_a3iPatches(:,:,iCounter3))
    set(hImage4,'cdata',strctRes4.strctIdentity.m_a3iPatches(:,:,iCounter4))
    iCounter1=iCounter1+1;
    iCounter2=iCounter2+1;
    iCounter3=iCounter3+1;
    iCounter4=iCounter4+1;
    drawnow
M = getframe(gcf);
M.cdata = imresize(M.cdata, MovieOutputSize,'bilinear');
Mov = addframe(Mov,M);

end

delete(ah1);
delete(ah2);
delete(ah3);
delete(ah4);

for k=100:-1:1
    set(hImage,'cdata',k/100*strctRes1.strctIdentity.m_a3iPatches(:,:,iCounter1))
    set(hImage2,'cdata',k/100*strctRes2.strctIdentity.m_a3iPatches(:,:,iCounter2))
    set(hImage3,'cdata',k/100*strctRes3.strctIdentity.m_a3iPatches(:,:,iCounter3))
    set(hImage4,'cdata',k/100*strctRes4.strctIdentity.m_a3iPatches(:,:,iCounter4))
    drawnow
M = getframe(gcf);
M.cdata = imresize(M.cdata, MovieOutputSize,'bilinear');
Mov = addframe(Mov,M);

end

Mov=close(Mov);
return

function fnPrepareText()
Mov = avifile('C:\IntroTextHighRes.avi','fps',30,'compression','xvid');
    
MovieOutputSize = 2*[384 512];
%%
f=figure(10);
clf;
 set(f,'Position',[  254   50   MovieOutputSize(2)   MovieOutputSize(1)],'color',[0 0 0]);
% 
 
% cla;
acText = {0.05-0.02, 0.7, 35, 'Automated multi-day tracking of mice';
          0.1-0.02  0.5, 35, 'for the analysis of social behavior';
          -0.05-0.02  0.25, 20, 'Shay Ohayon, Ofer Avni, Adam L. Taylor, Roian Egnor and Pietro Perona';          
          };
%     k=1
%     axis off
%   for j=1:size(acText,1)
%         text(acText{j,1}, acText{j,2}, acText{j,4},'Color',[k k k],'FontSize',acText{j,3})
%     end;
         
Mov = fnMovieText(acText, 1, 3,1,Mov,MovieOutputSize);
Mov = close(Mov);

return


%% 



load('D:\Data\Janelia Farm\Results\10.04.19.390\SequenceViterbi_26-Aug-2009.mat');
strMovie = 'M:\Data\Movies\Experiment1\10.04.19.390.seq';
strctMovInfo = fnReadVideoInfo(strMovie);


a2fX = cat(1,astrctTrackers.m_afX);
a2fY = cat(1,astrctTrackers.m_afY);
a2fA = cat(1,astrctTrackers.m_afA);
a2fB = cat(1,astrctTrackers.m_afB);
a2fTheta = cat(1,astrctTrackers.m_afTheta);

%% Detect approaching

% strctApproachParams.m_fVelocityStationaryThresholdPix = 5;
% strctApproachParams.m_iMaxLength = 50;
% strctApproachParams.m_iMergeIntervals = 10;
% 
% % B approach A
% iMouseA = 2;
% iMouseB = 3;
% abMouseAStationary = [0,sqrt((a2fX(iMouseA,2:end)-a2fX(iMouseA,1:end-1)).^2 + (a2fY(iMouseA,2:end)-a2fY(iMouseA,1:end-1)).^2) < strctApproachParams.m_fVelocityStationaryThresholdPix];
% abMouseBStationary = [0,sqrt((a2fX(iMouseB,2:end)-a2fX(iMouseB,1:end-1)).^2 + (a2fY(iMouseB,2:end)-a2fY(iMouseB,1:end-1)).^2) < strctApproachParams.m_fVelocityStationaryThresholdPix];
% aiStatSumA = cumsum(abMouseAStationary);
% aiStatSumB = cumsum(abMouseBStationary);
% afDistAB = sqrt((a2fX(iMouseA,:)-a2fX(iMouseB,:)).^2+(a2fY(iMouseA,:)-a2fY(iMouseB,:)).^2);
% 
% abFarAway = afDistAB > 200;
% abNearBy = afDistAB <= 20;
% astrctFarAway = fnGetIntervals(abFarAway);
% astrctNearby = fnGetIntervals(abNearBy);
% 
% for i=1:length(astrctFarAway)
%     for j=1:length(astrctNearby)
%         fEndToStart = astrctNearby(j).m_iStart - astrctFarAway(i).m_iEnd;
%         if fEndToStart > 0  && fEndToStart < strctApproachParams.m_iMaxLength
%             aiInterval = [astrctFarAway(i).m_iEnd:astrctNearby(j).m_iStart];
%             fPercMoving = (aiStatSumA(astrctNearby(j).m_iStart) - aiStatSumA(astrctFarAway(i).m_iEnd) ) / length(aiInterval) * 100;
%             if fPercMoving < 20
%                 [aiInterval(1),aiInterval(end)]
%             end
%         end;
%     end;
% end;
% 

%%

% Thresholds
strctParams.m_fVelocityThresholdPix = 10;
strctParams.m_fSameOrientationAngleThresDeg = 90;
strctParams.m_fDistanceThresholdPix = 250;
strctParams.m_iMergeIntervalsFrames = 30;


iMouseA = 1;
iMouseB = 2;
abDetected = fndllDetectBehavior('Following',a2fX,a2fY,a2fA,a2fB,a2fTheta, iMouseB,iMouseA, strctParams);
astrctIntervalsFollowing = fnMergeIntervals(fnGetIntervals(abDetected),strctParams.m_iMergeIntervalsFrames);
aiLength = cat(1,astrctIntervalsFollowing.m_iLength);
[aiSortedLength, aiSortIndex] = sort(aiLength,'descend');
astrctIntervalsFollowing=astrctIntervalsFollowing(aiSortIndex);



iMouseA = 3;
iMouseB = 1;
abDetected = fndllDetectBehavior('Following',a2fX,a2fY,a2fA,a2fB,a2fTheta, iMouseB,iMouseA, strctParams);
astrctIntervalsFollowing2 = fnMergeIntervals(fnGetIntervals(abDetected),strctParams.m_iMergeIntervalsFrames);
aiLength = cat(1,astrctIntervalsFollowing2.m_iLength);
[aiSortedLength, aiSortIndex] = sort(aiLength,'descend');
astrctIntervalsFollowing2=astrctIntervalsFollowing2(aiSortIndex);


iMouseA = 1;
iMouseB = 4;
strctSniffParam.m_fVelocityThresholdPix = 5;
strctSniffParam.m_fHeadToButtDistPix = 20;
strctSniffParam.m_fBodiesAwayMult = 2;   
strctSniffParam.m_iMergeIntervalsFrames = 30;

abDetected = fndllDetectBehavior('SniffButt',a2fX,a2fY,a2fA,a2fB,a2fTheta, iMouseB,iMouseA, strctSniffParam);
astrctIntervalsSniffButt1 = fnMergeIntervals(fnGetIntervals(abDetected),strctSniffParam.m_iMergeIntervalsFrames);
aiLength = cat(1,astrctIntervalsSniffButt1.m_iLength);
[aiSortedLength, aiSortIndex] = sort(aiLength,'descend');
astrctIntervalsSniffButt1=astrctIntervalsSniffButt1(aiSortIndex);


iMouseA = 1;
iMouseB = 4;
strctKissParam.m_fVelocityThresholdPix = 5;
strctKissParam.m_fHeadToHeadDistPix = 15;
strctKissParam.m_fBodiesAwayMult = 2;   
strctKissParam.m_iMergeIntervalsFrames = 30;


abDetected = fndllDetectBehavior('Kiss',a2fX,a2fY,a2fA,a2fB,a2fTheta, iMouseB,iMouseA, strctKissParam);
strctIntervalsKiss1 = fnMergeIntervals(fnGetIntervals(abDetected),strctKissParam.m_iMergeIntervalsFrames);
aiLength = cat(1,strctIntervalsKiss1.m_iLength);
[aiSortedLength, aiSortIndex] = sort(aiLength,'descend');
strctIntervalsKiss1=strctIntervalsKiss1(aiSortIndex);




aiInterval = 102000:5:103000;
Mov = fnMovieFadeInOut(strctMovInfo, astrctTrackers, aiInterval,2, 2,Mov,MovieOutputSize);

acText = {0.3, 0.5, 40, '7 Hours Later...';
          0.33 0.37 20, 'Identities are still correct'};
Mov = fnMovieText(acText, 3, 3,3,Mov,MovieOutputSize);

aiInterval = 1158777:5:1160000;
Mov = fnMovieFadeInOut(strctMovInfo, astrctTrackers, aiInterval,2, 2,Mov,MovieOutputSize);


acText = {0.13, 0.5, 30, 'Correct identities in complex interactions'};
Mov = fnMovieText(acText, 3, 3,3,Mov,MovieOutputSize);

aiInterval = round(397700:1:397795);
Mov = fnMovieFadeInOut(strctMovInfo, astrctTrackers, aiInterval,0.5, 0.2,Mov,MovieOutputSize);

acText = {0.13, 0.5, 30, 'Correct identities in complex interactions';
          0.35, 0.4, 20, 'Slow motion version'};

Mov = fnMovieText(acText, 3, 3,3,Mov,MovieOutputSize);

aiInterval = round(397747:0.3:397792);
Mov = fnMovieFadeInOut(strctMovInfo, astrctTrackers, aiInterval,0.2, 0.2,Mov,MovieOutputSize);


acText = {0.1, 0.5, 40, 'Automatic Behavior Detection';
          0.33 0.37 20, 'Red Following Green'};
Mov = fnMovieText(acText, 3, 3,3,Mov,MovieOutputSize);


aiInterval = astrctIntervalsFollowing(1).m_iStart:1:astrctIntervalsFollowing(1).m_iEnd+60;
Mov = fnMovieFadeInOut(strctMovInfo, astrctTrackers, aiInterval,0.3, 0.3,Mov,MovieOutputSize);

aiInterval = astrctIntervalsFollowing(2).m_iStart:1:astrctIntervalsFollowing(2).m_iEnd+60;
Mov = fnMovieFadeInOut(strctMovInfo, astrctTrackers, aiInterval,0.3, 0.3,Mov,MovieOutputSize);

aiInterval = astrctIntervalsFollowing(3).m_iStart:1:astrctIntervalsFollowing(3).m_iEnd+60;
Mov = fnMovieFadeInOut(strctMovInfo, astrctTrackers, aiInterval,0.3, 0.3,Mov,MovieOutputSize);

acText = {0.1, 0.5, 40, 'Automatic Behavior Detection';
          0.33 0.37 20, 'Blue Following Red'};
Mov = fnMovieText(acText, 3, 3,3,Mov,MovieOutputSize);

aiInterval = astrctIntervalsFollowing2(1).m_iStart:1:astrctIntervalsFollowing2(1).m_iEnd+60;
Mov = fnMovieFadeInOut(strctMovInfo, astrctTrackers, aiInterval,0.3, 0.3,Mov,MovieOutputSize);

aiInterval = astrctIntervalsFollowing2(2).m_iStart:1:astrctIntervalsFollowing2(2).m_iEnd+60;
Mov = fnMovieFadeInOut(strctMovInfo, astrctTrackers, aiInterval,0.3, 0.3,Mov,MovieOutputSize);

acText = {0.1, 0.5, 40, 'Automatic Behavior Detection';
          0.33 0.37 20, 'Red Sniff Cyan''s butt'};
Mov = fnMovieText(acText, 3, 3,3,Mov,MovieOutputSize);

aiInterval = astrctIntervalsSniffButt1(1).m_iStart-30:1:astrctIntervalsSniffButt1(1).m_iEnd+30;
Mov = fnMovieFadeInOut(strctMovInfo, astrctTrackers, aiInterval,0.3, 0.3,Mov,MovieOutputSize);


aiInterval = astrctIntervalsSniffButt1(3).m_iStart-30:1:astrctIntervalsSniffButt1(3).m_iEnd+30;
Mov = fnMovieFadeInOut(strctMovInfo, astrctTrackers, aiInterval,0.3, 0.3,Mov,MovieOutputSize);

acText = {0.1, 0.5, 40, 'Automatic Behavior Detection';
          0.33 0.37 20, 'Blue Sniff Red''s butt'};
Mov = fnMovieText(acText, 3, 3,3,Mov,MovieOutputSize);

aiInterval = astrctIntervalsSniffButt1(5).m_iStart-30:1:astrctIntervalsSniffButt1(5).m_iEnd+30;
Mov = fnMovieFadeInOut(strctMovInfo, astrctTrackers, aiInterval,0.3, 0.3,Mov,MovieOutputSize);


acText = {0.1, 0.5, 40, 'Automatic Behavior Detection';
          0.33 0.37 20, 'Red Sniff Cyan''s head'};
Mov = fnMovieText(acText, 3, 4,3,Mov,MovieOutputSize);

aiInterval = strctIntervalsKiss1(5).m_iStart-30:1:strctIntervalsKiss1(5).m_iEnd+30;
Mov = fnMovieFadeInOut(strctMovInfo, astrctTrackers, aiInterval,0.3, 0.3,Mov,MovieOutputSize);

aiInterval = strctIntervalsKiss1(1).m_iStart-30:1:strctIntervalsKiss1(1).m_iEnd+30;
Mov = fnMovieFadeInOut(strctMovInfo, astrctTrackers, aiInterval,0.3, 0.3,Mov,MovieOutputSize);


aiInterval = strctIntervalsKiss1(2).m_iStart-30:1:strctIntervalsKiss1(2).m_iEnd+20;
Mov = fnMovieFadeInOut(strctMovInfo, astrctTrackers, aiInterval,0.3, 0.3,Mov,MovieOutputSize);


Mov = close(Mov);
 