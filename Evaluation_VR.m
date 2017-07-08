%=====================================================================
% File: Evaluation_VR.m
%=====================================================================

clc
%Setting the path

p=genpath(pwd);
path(path,p);

%Extracting directories


Directories=ExtractDir_SubDir(p);

%Compiling some of the libraries for faster execution

FilesToBeCompiled={};
NumOfSubDir=numel(Directories);

for i=1:NumOfSubDir
        SearchString=fullfile(Directories{i},'compile_metrix_*.m');
        TempDir=dir(SearchString);

        if(~isempty(TempDir))
            %Some files were found
            NumOfFiles=length(TempDir);
            CurrentDir=pwd;
            cd(Directories{i});
            for j=1:NumOfFiles
                CompileString=TempDir(j).name(1:end-2);

                feval( CompileString );

            end
            cd(CurrentDir);
        end

end %for i=1:NumOfSubDir

%Running the UI.
run(which('Configuration.m'));
