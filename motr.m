function motr()

% If the GUI is running already, don't launch again, just bring to front
motrFigures = findall(0,'Tag','motr') ;
if ~isempty(motrFigures) ,
    motrFigure = motrFigures(1) ;  % there should just be the one...
    figure(motrFigure);  % bring to front
    return
end

% set up the path to find all the motr code
fnSetupFolders();

% Check that compilation has been done, do it if not
% Use parsejpg8 as the canary in the coalmine
if ~isParsejpg8MexFilePresent()
    compileMexFunctions();
end

% If linux, check for the cluster executable, build it if absent
if islinux() && ~isClusterExecutablePresent()
    buildClusterExecutable();
end

% Launch the GUI
model = MotrModel() ;
ui = MotrUserInterface() ;
ui.setModel(model);
%MouseHouse();

end
