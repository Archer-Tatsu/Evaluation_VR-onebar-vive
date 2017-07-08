%=====================================================================
% File: ReadSubjectNumbers.m
%=====================================================================

function [NumOfSubjects,LastSubject,SubjectColIdx]=ReadSubjectNumbers(HeaderRow)
%Function that reads the subject numbers from the column headers extracted
%from the raw subjective scores file. The number of subjects and the last
%subjects number is returned.

NumOfSubjects=0;
LastSubject=0;
SubjectColIdx=[];

PositionPattern='subject\s*';

[Positions]=regexpi(HeaderRow,PositionPattern);
SubjectColIdx=find(~cellfun('isempty',Positions));

SubNumPattern='subject\s*(\d+)';
tmp=[HeaderRow{:}];

[t]=regexpi(tmp,SubNumPattern,'tokens');
if(~isempty(t))
    NumOfSubjects=length(t);
    SubNums=zeros(NumOfSubjects,1);
    for i=1:NumOfSubjects
        SubNum(i)=str2num(cell2mat(t{i}));
    end
      LastSubject=max(SubNum);
end

