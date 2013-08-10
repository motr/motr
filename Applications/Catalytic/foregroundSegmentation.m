function [isForegroundBounded, ...
          diffFromBackgroundBounded, ...
          xPredicted,yPredicted,thetaPredicted, ...
          r0,r1,c0,c1, ...
          imBounded] = ...
             foregroundSegmentation(trx,iFlies,iFrameInVideo,im,boundingBoxRadius,bg,foregroundSign,bgthresh)
  
  trx = trx(iFlies);
  nFlies = length(iFlies);
  %boxRadius = self.maxjump;

  xPredicted = zeros(1,nFlies);
  yPredicted = zeros(1,nFlies);
  thetaPredicted = zeros(1,nFlies);
  for iFly = 1:nFlies,
    iFrameInTrack = max( trx(iFly).off+(iFrameInVideo), 2 ); % first frame
    xPrevious = trx(iFly).x(iFrameInTrack-1);
    yPrevious = trx(iFly).y(iFrameInTrack-1);
    thetaPrevious = trx(iFly).theta(iFrameInTrack-1);
    if iFrameInTrack == 2,
      xPredicted(iFly) = xPrevious;
      yPredicted(iFly) = yPrevious;
      thetaPredicted(iFly) = thetaPrevious;
    else
      xTwoBack = trx(iFly).x(iFrameInTrack-2);
      yTwoBack = trx(iFly).y(iFrameInTrack-2);
      thetaTwoBack = trx(iFly).theta(iFrameInTrack-2);
      [xPredicted(iFly),yPredicted(iFly),thetaPredicted(iFly)] = ...
        cvpred(xTwoBack,yTwoBack,thetaTwoBack, ...
               xPrevious,yPrevious,thetaPrevious);
    end
  end

  [nr,nc]=size(im);
  r0 = max(floor(min(yPredicted)-boundingBoxRadius),1); r1 = min(ceil(max(yPredicted)+boundingBoxRadius),nr);
  c0 = max(floor(min(xPredicted)-boundingBoxRadius),1); c1 = min(ceil(max(xPredicted)+boundingBoxRadius),nc);
  %im = self.readframe(iFrameInVideo);
%     if self.doFlipUpDown ,
%       im=flipdim(im,1);
% %       for channel = 1:size( im, 3 )
% %         im(:,:,channel) = flipud( im(:,:,channel) );
% %       end
%     end
  im=double(im);
  %bg=double(self.backgroundImageForCurrentAutoTrack());
  diffFromBackground = im - bg;  %#ok

%     figure; imagesc(im); colormap(gray); axis image; title('im');
%     figure; imagesc(bg); colormap(gray); axis image; title('bg');
%     maxAbs=max(abs(diffFromBackground(:)));
%     figure; imagesc(diffFromBackground,[-maxAbs +maxAbs]); colormap(bipolar()); axis image; title('diffFromBackground'); colorbar();

  imBounded = im(r0:r1,c0:c1);
  bgBounded=bg(r0:r1,c0:c1);
  diffFromBackgroundBounded = imBounded - bgBounded;

%     figure; imagesc(imBounded); colormap(gray); axis image; title('imBounded');
%     figure; imagesc(bgBounded); colormap(gray); axis image; title('bgBounded');
%     maxAbs=max(abs(diffFromBackgroundBounded(:)));
%     figure; imagesc(diffFromBackgroundBounded,[-maxAbs +maxAbs]); colormap(bipolar()); axis image; title('diffFromBackgroundBounded'); colorbar();

  if foregroundSign == 1
    diffFromBackgroundBoundedRectified = max(diffFromBackgroundBounded,0);
  elseif foregroundSign == -1
    diffFromBackgroundBoundedRectified = max(-diffFromBackgroundBounded,0);
  else
    diffFromBackgroundBoundedRectified = abs(diffFromBackgroundBounded);
  end
  isForegroundBounded = (diffFromBackgroundBoundedRectified>=bgthresh);
  se = strel('disk',1);
  isForegroundBounded = imclose(isForegroundBounded,se);
  isForegroundBounded = imopen(isForegroundBounded,se);
end  % function
