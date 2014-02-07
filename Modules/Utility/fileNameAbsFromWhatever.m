function result=fileNameAbsFromWhatever(fileName,basePath)

if isFileNameAbsolute(fileName) ,
  result=fileName;
else
  result=fullfile(basePath,fileName);
end

end
