function annFileFromMotrFiles(annFileName, ...
                              seqFileName, ...
                              motrTrackFileName)

% Convert the Motr track file (whose name often ends in '_tracks.mat') to
% a Ctrax/Jaaba-style .trx file
%trxFileName=trxFileNameFromMotrTrackFileName(motrTrackFileName);
s=load(motrTrackFileName);
astrctTrackers=s.astrctTrackers;

% Compute the background frame
backgroundFrame=seqMedianFrameFromNonRandomSample(seqFileName);

% convert to ann format, save
%annFileName=replaceExtension(seqFileName,'.ann');
annFileFromShayTrack(annFileName,astrctTrackers,backgroundFrame);
