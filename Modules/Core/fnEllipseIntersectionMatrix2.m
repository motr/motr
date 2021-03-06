function [a2bIntersect] = fnEllipseIntersectionMatrix2(astrctTrackers)
%
%Copyright (c) 2008 Shay Ohayon, California Institute of Technology.
% This file is a part of a free software. you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation (see GPL.txt)
iNumMice = length(astrctTrackers);

a2bIntersect = zeros(iNumMice,iNumMice) > 0;
for i=1:iNumMice
    for j=i+1:iNumMice
        a2bIntersect(i,j) = fnEllipseEllipseIntersection(...
            astrctTrackers(i).m_fX,...
            astrctTrackers(i).m_fY,...
            astrctTrackers(i).m_fA,...
            astrctTrackers(i).m_fB,...
            astrctTrackers(i).m_fTheta,...
            astrctTrackers(j).m_fX,...
            astrctTrackers(j).m_fY,...
            astrctTrackers(j).m_fA,...
            astrctTrackers(j).m_fB,...
            astrctTrackers(j).m_fTheta);
        a2bIntersect(j,i) = a2bIntersect(i,j);
    end;
end;

return;

