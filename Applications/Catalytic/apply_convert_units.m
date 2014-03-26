function [trx, didsomething] = apply_convert_units(trx,pxpermm,fps,alreadyconverted)
% split from convert_units_f 9/10/11 JAB

% Determine whether pxpermm and/or fps have been provided as inputs.  If
% so, use those values.  If not, use the values already in trx
pxpermminput = exist('pxpermm','var');
fpsinput = exist('fps','var');
if ~pxpermminput
  pxpermm = trx(1).pxpermm;
end
if ~fpsinput
  fps = trx(1).fps;
end

% Determine whether the "main" field names (the fieldNamesThatKeepTheSameName below) have already
% been converted from pels to mm
if ~exist( 'alreadyconverted', 'var' )
   alreadyconverted = false;
end

%
%% actually do the conversion now
%

fieldNamesThatKeepTheSameName = {'xpred','ypred','dx','dy','v'};  % field names to be converted from pels to mm, keeping the same field name
% these are used for plotting, so we want to keep them in pixels
fieldNamesThatGetMMAppended = {'x','y','a','b'};  % field names to be converted from pels to mm, but the new field has "_mm" appended to it (and the original field is kept)
okfns = {'x','y','theta','a','b','id','moviename','firstframe','arena',...
  'f2i','nframes','endframe','xpred','ypred','thetapred','dx','dy','v',...
  'a_mm','b_mm','x_mm','y_mm','matname','sex','type','timestamps'};  % list of field names we know how to deal with? (ALT, 2014-03-26)
unknownfns = setdiff(getperframepropnames(trx),okfns);  % if this is non-empty, could be problematic

% If needed, convert the fields that keep the same field name
if ~alreadyconverted
   if ~isempty(unknownfns),
     b = questdlg({'Do not know how to convert the following variables: ',...
       sprintf('%s, ',unknownfns{:}),'Ignore these variables and continue?'},...
       'Unknown Variables','Continue','Abort','Abort');
     if strcmpi(b,'abort'),
       return;
     end
   end

   for i = 1:length(fieldNamesThatKeepTheSameName),
     fn = fieldNamesThatKeepTheSameName{i};
     if isfield(trx,fn),
       for iFly = 1:length(trx),
         trx(iFly).(fn) = trx(iFly).(fn) / pxpermm;
       end
     end
   end
end

% Convert the fields that get "_mm" appended to the field name, keeping the
% original field intact
didsomething = false;
for i = 1:length(fieldNamesThatGetMMAppended),
  fn = fieldNamesThatGetMMAppended{i};
  newfn = [fn,'_mm'];
  if isfield(trx,fn),
    for iFly = 1:length(trx),
      trx(iFly).(newfn) = trx(iFly).(fn) / pxpermm;
      didsomething = true;
    end
  end
end

% If the user has supplied pxpermm or fpsinput, the output trx file should
% have those values in it
for iFly = 1:length(trx),
  if pxpermminput && ~alreadyconverted,
    trx(iFly).pxpermm = pxpermm;
  end
  if fpsinput && ~alreadyconverted ,
      trx(iFly).fps = fps;
  end
end

% If there are no timestamps, synthesize some
if ~isfield( trx, 'timestamps' )
   if isfield( trx, 'fps' )
      fprintf( 1, 'no timestamps saved in file -- faking\n' );
      for iFly = 1:length(trx),
        trx(iFly).timestamps = (trx(iFly).firstframe:trx(iFly).endframe)/fps;
      end
      didsomething = true;
   else
      fprintf( 1, 'no timestamps saved in file and no fps number to calculate from\n' );
   end
end

% % If theta is a field name, "convert" to mm, because JAABA seems to need a
% % theta_mm field.  Of course, since theta is in radians to start with,
% % theta_mm is just a copy of theta.
% if isfield(trx,'theta') ,
%   for iFly = 1:length(trx) ,
%     trx(iFly).theta_mm=trx(iFly).theta;
%   end
%   didsomething = true;
% end

end  % function
