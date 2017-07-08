%=====================================================================
% File: ExtractDir_SubDir.m
%=====================================================================


function [Directories]=ExtractDir_SubDir(PathString)
%Function to extract individual directories from the path string

PathSepLoc = find(PathString == pathsep);
DirBounds=[0 PathSepLoc];
%Check if the last dir listing has been terminated with a path separator
if(PathString(end)~=pathsep)
    DirBounds(end+1)=length(PathString)+1;
end

NumDir=length(DirBounds)-1;


Directories={};
for i=1:NumDir
    Directories{end+1}=PathString(DirBounds(i)+1:DirBounds(i+1)-1);
end
