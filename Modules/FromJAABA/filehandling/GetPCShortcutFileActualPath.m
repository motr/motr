function [actualfilename,didfindactualfilename,didfollowshortcut] = GetPCShortcutFileActualPath(filename)
  % Get the true file name for a given file name, dealing with Windows
  % shortcut files as needed.  Also checks for the existence of the file,
  % following the shortcut if needed.  And returns a boolean saying whether
  % or not a shortcut was followed.
    
  didfindfilename = exist(filename,'file') ;
  if didfindfilename,
    % File exists, do filename is the actual file name
    actualfilename = filename ;
    didfindactualfilename = true ;
    didfollowshortcut = false ;
  else
    % No file at filename, so...
    if ispc() ,
      % If filename is absent, and on a Windows box, check for a shortcut
      % (the lame Windows version of a Unix symlink)
      linkfilename = [filename,'.lnk'] ;
      if exist(linkfilename,'file') ,
        % A link file exists, so figure out what the actual filename is, 
        % and check if it's there
        if isabspath(linkfilename),
          abslinkfilename = linkfilename ;
        else
          abslinkfilename = fullfile(pwd(),linkfilename) ;
        end
        try
          % Do some java stuff to follow the shortcut
          javaFileObject = java.io.File(abslinkfilename);
          javaShellFolderObject = sun.awt.shell.ShellFolder.getShellFolder(javaFileObject);
          actualfilenameAsJavaObject = javaShellFolderObject.getLinkLocation();
          actualfilename = char(actualfilenameAsJavaObject) ;
        catch  %#ok<CTCH>
          % If there's a problem following the shortcut, just revert to using the
          % filename as given by the caller.
          actualfilename = filename ;
        end
        didfindactualfilename = exist(actualfilename,'file') ;
        didfollowshortcut = true ;        
      else
        % filename is missing, and there's no link file, so the file is
        % just missing...
        actualfilename = filename ;  
        didfindactualfilename = false ;
        didfollowshortcut = false ;
      end
    else      
      % If not a Windows box, nothing else to try, so
      % filename is the actual file name, but it's missing.
      actualfilename = filename ;  
      didfindactualfilename = false ;
      didfollowshortcut = false ;
    end
  end

end
