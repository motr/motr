function strctSeq = fnOpenSeqForWriting(strFileName, fFPS, fCompressionRatio)

strctSeq.m_strFileName = strFileName;
if ~exist('fFPS','var')
    strctSeq.m_fFPS = 30;
else 
    strctSeq.m_fFPS = fFPS;
end;
if ~exist('fCompressionRatio','var')
    strctSeq.m_fCompressionRatio = 100;
else 
    strctSeq.m_fCompressionRatio = fCompressionRatio;
end;
strctSeq.m_iNumFrames = 0;

strctSeq.m_hFileID = fopen(strctSeq.m_strFileName,'wb+');
if strctSeq.m_hFileID == 0
    fprintf('Warning. Failed to open file for writing\n');
    strctSeq = [];
    return;
end;
fwrite(strctSeq.m_hFileID, zeros(1,1024), 'uchar'); % Write empty header

strctSeq.m_strTmpFile = [tempname,'.jpg'];

return;
