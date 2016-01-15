function [actualfilename,didfindactualfilename,actualindexfilename,didfindactualindexfilename] = ...
    getPCShortcutFileActualPathAndDittoForIndexFile(filename,indexfilename,indexfileextension)
  % Get the true file name for a given file name, dealing with Windows
  % shortcut files as needed.  Also checks for the existence of the file,
  % following the shortcut if needed.
  
  [actualfilename,didfindactualfilename,didfollowshortcut] = GetPCShortcutFileActualPath(filename) ;
  if ~isempty(indexfilename) ,
    % Caller provided an index file name, so just de-shortcut it if needed
    [actualindexfilename,didfindactualindexfilename] = GetPCShortcutFileActualPath(indexfilename) ;
  else
    % Caller did not provide an index file name, so look for one "next to"
    % the main file
    [path,name,~] = fileparts(filename) ;
    indexfilename = fullfile(path,[name indexfileextension]) ;
    [actualindexfilenameTry1,didfindactualindexfilenameTry1] = GetPCShortcutFileActualPath(indexfilename) ;
    if ~didfindactualindexfilenameTry1 && didfollowshortcut,
      % Didn't find the index file next to filename, but if we followed a
      % shortcut to get to the main file, so check next to the de-referenced
      % file name.
      [actualpath,actualname,~] = fileparts(actualfilename) ;
      indexfilename = fullfile(actualpath,[actualname indexfileextension]) ;
      [actualindexfilename,didfindactualindexfilename] = GetPCShortcutFileActualPath(indexfilename) ;
    else
      % In this case, there's nothing else to try, so the answers from try
      % 1 are the final answers
      actualindexfilename = actualindexfilenameTry1 ;
      didfindactualindexfilename = didfindactualindexfilenameTry1 ;
    end
  end
  
end
