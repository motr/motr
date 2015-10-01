function [bReasonable] = fnIsReasonableMouseBlob2(strctEllipse)
%
%Copyright (c) 2008 Shay Ohayon, California Institute of Technology. 
% This file is a part of a free software. you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation (see GPL.txt)

% fMajorAxisMax = 55;
% fMajorAxisMin = 18;
% fMinorAxisMin = 10;
% fMinorAxisMax = 23;

% Having the values for fMajorAxisMax, fMajorAxisMin, fMinorAxisMin, and
% fMinorAxisMax be hard-coded causes problems when the size of the mouse
% (in pixels) does not match the size used in the experiments motr was
% originally designed to analyze (the ellipse sizes need to be bigger or
% smaller, in pixels). So these parameters have been added to the
% Configuration file that is loaded in as the g_strctGlobalParam global
% variable [KMS, 2015-09-09]

global g_strctGlobalParam
fMajorAxisMax = g_strctGlobalParam.m_strctDetection.m_fMajorAxisMax;
fMajorAxisMin = g_strctGlobalParam.m_strctDetection.m_fMajorAxisMin;
fMinorAxisMin = g_strctGlobalParam.m_strctDetection.m_fMinorAxisMin;
fMinorAxisMax = g_strctGlobalParam.m_strctDetection.m_fMinorAxisMax;


fMajorAxis = strctEllipse.m_fA;
fMinorAxis = strctEllipse.m_fB;
bReasonable =  ~isnan(fMajorAxis) && ~isnan(fMinorAxis) && ...
              (fMajorAxis < fMajorAxisMax && fMajorAxis > fMajorAxisMin && ...
               fMinorAxis <   fMinorAxisMax && fMinorAxis > fMinorAxisMin);
return;