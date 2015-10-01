function result = motrRootDirName()
    persistent memo
    if isempty(memo) ,
        % Determine the root Motr directory
        thisFileName=mfilename('fullpath');
        thisDirName=fileparts(thisFileName);
        thisDirParts=split_on_filesep(thisDirName);
          % a cell array with each dir an element
        motrRootParts=thisDirParts(1:end-2);
        memo = combine_with_filesep(motrRootParts) ;
    end
    result = memo ;
end
