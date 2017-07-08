%=====================================================================
% File: ReturnFileFilter.m
%=====================================================================

function [Filterspec]=ReturnFileFilter(FormatFile)
%Function that returns the file filters to be applied in the file open
%dialog boxes. The list of supported file extensions is taken from the 
%supported formats file.

fid = fopen(FormatFile,'r');
Desc={};
ExtList={};
Filterspec={};
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    %Extracting extensions from the file.
    [t,r]=strtok(tline,',');

    ExtList{end+1}=r(2:end);
    Desc{end+1}=[t ' (' ExtList{end} ')'];
end
fclose(fid);
SupExtensions = regexprep(ExtList, ',', ';');

for i=1:numel(Desc)
    Filterspec{end+1,1}=SupExtensions{i};
    Filterspec{end,2}=Desc{i};
end
Filterspec{end+1,1}='*.*';
Filterspec{end,2}='All files (*.*)';
