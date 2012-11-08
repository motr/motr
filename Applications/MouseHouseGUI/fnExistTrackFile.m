function bExist = fnExistTrackFile(sExpName, sExperimentClip)
%
bExist = false;
sResultsDir = fullfile(sExpName, 'Results');
sTracksDir = fullfile(sResultsDir, 'Tracks');
[sPath, sClipName] = fileparts(sExperimentClip);
sTrackFile = fullfile(sTracksDir, [sClipName '.mat']);
bExist = exist(sTrackFile, 'file');
