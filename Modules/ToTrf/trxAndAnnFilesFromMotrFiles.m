function trxAndAnnFilesFromMotrFiles(trxFileName, ...
                                     annFileName, ...
                                     seqFileName, ...
                                     motrTrackFileName, ...
                                     pxPerMm)

if ~exist('pxPerMm','var')
  pxPerMm=[];
end

% Convert the Motr track file (whose name often ends in '_track.mat') to
% a Ctrax/Jaaba-style .trx file
%trxFileName=trxFileNameFromMotrTrackFileName(motrTrackFileName);
s=load(motrTrackFileName);
astrctTrackers=s.astrctTrackers;
clear('s');
trx=trxFromShayTrack(astrctTrackers);

% Interpolate to get rid of nan's
trx=interpolateAwayNansInTrx(trx);

% Add frames per second and time stamps, getting from .seq file
seqInfo=fnReadSeqInfo(seqFileName);
fps=seqInfo.m_fFPS;  % Hz
timeStamps=seqInfo.m_afTimestamp;  % seconds
nTracks=length(trx);
for iTrack=1:nTracks
  trx(iTrack).fps=fps;
  trx(iTrack).timestamps=timeStamps;
end

% add the trajectories in physical units, if we can
if ~isempty(pxPerMm) ,
  nTracks=length(trx);
  for iTrack=1:nTracks
    trx(iTrack).pxpermm=pxPerMm;
    trx(iTrack).x_mm=trx(iTrack).x/pxPerMm;
    trx(iTrack).y_mm=trx(iTrack).y/pxPerMm;
    trx(iTrack).a_mm=trx(iTrack).a/pxPerMm;
    trx(iTrack).b_mm=trx(iTrack).b/pxPerMm;
  end  
end

% Write out the trx file
save(trxFileName,'trx');

% Compute the background frame
backgroundFrame=seqMedianFrameFromNonRandomSample(seqFileName);

% convert to ann format, save
%annFileName=replaceExtension(seqFileName,'.ann');
saveAnnFromShayTrack(annFileName,astrctTrackers,backgroundFrame);

end
