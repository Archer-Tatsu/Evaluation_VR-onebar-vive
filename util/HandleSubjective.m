%=====================================================================
% File: HandleSubjective.m
%=====================================================================
function HandleSubjective(handles)
%Function that is called when the "Start" button is clicked and the 
%subjective tab is active. 

%Check if logging is to be performed

if(-1~=handles.FilePointers.LogFile)
    LogFn=@PerformLogging;
else
    LogFn=@NoLogging;
end

%Validating UI Selections
LogFn(handles.FilePointers.LogFile,'\nValidating UI selections for the Subjective Tab...');

%Validate parameters related to subjective testing
if((~isfield(handles.SubTestData,'SelSubTestMethod'))|| (isempty(handles.SubTestData.SelSubTestMethod)))
    LogFn(handles.FilePointers.LogFile,'\nNo test methodology specified.');
    error('No test methodology specified.');
end
if((~isfield(handles.SubTestData,'SessionType'))|| (isempty(handles.SubTestData.SessionType)))
    LogFn(handles.FilePointers.LogFile,'\nNo Session type specified.');
    error('No Session type specified.');
end
if((~isfield(handles.SubTestData,'TargetType'))|| (isempty(handles.SubTestData.TargetType)))
    LogFn(handles.FilePointers.LogFile,'\nNo Target type specified.');
    error('No Target type specified.');
end
if((~isfield(handles.SubTestData,'TestFiles'))|| (isempty(handles.SubTestData.TestFiles)))
  LogFn(handles.FilePointers.LogFile,'\nNo Test files found.');
  error('No Test files found');
end

if((1==strcmpi(handles.SubTestData.SessionType,'t'))&&...
   ((~isfield(handles.SubTestData,'RawSubScoreFile'))|| (isempty(handles.SubTestData.RawSubScoreFile)))...
  )
    LogFn(handles.FilePointers.LogFile,'\nNo file for raw subjective scores specified.');
    error('No file for raw subjective scores specified.');
end
if((0==handles.ToolOptions.AutoSub)&&(isempty(handles.ToolOptions.SubjectNum)))
    LogFn(handles.FilePointers.LogFile,'\nNo subject number specified.');
    error('No subject number specified.');
end

%Validate parameters related to Score calculations

if(...
        ((1==handles.SubTestData.CalcMOS)||(1==handles.SubTestData.CalcDMOS)||(1==handles.SubTestData.CalcSTD)) && ...
        ((~isfield(handles.SubTestData,'ScoresFile'))||(isempty(handles.SubTestData.ScoresFile)))...
   )
    LogFn(handles.FilePointers.LogFile,'\nNo file specified to store the calculated scores.');
    error('No file specified to store the calculated scores.');

end

if((1==handles.SubTestData.CalcDMOS)&&(isempty(handles.SubTestData.RefFiles)))
    LogFn(handles.FilePointers.LogFile,'\nNo References specified for DMOS.');
    error('No References specified for DMOS.');
end
if((1==handles.SubTestData.CalcDMOS)&&(isempty(handles.SubTestData.DMOSUseZScore)))
    LogFn(handles.FilePointers.LogFile,'\nNo method specified for DMOS calculation.');
    error('No method specified for DMOS calculation.');
end

if((1==handles.SubTestData.CalcDMOS) &&(1==handles.SubTestData.DMOSUseZScore) && (0==handles.SubTestData.CalcZScores))
    LogFn(handles.FilePointers.LogFile,'\nDMOS calculation  using Z Score has been chosen, but Z Score calculation has not been enabled.');
    error('DMOS calculation  using Z Score has been chosen, but Z Score calculation has not been enabled.');

end

if(...
        (1==handles.SubTestData.CalcZScores) && ...
        ((~isfield(handles.SubTestData,'ZScoresFile'))||(isempty(handles.SubTestData.ZScoresFile)))...
   )
    LogFn(handles.FilePointers.LogFile,'\nNo file specified to store the Z scores.');
    error('No file specified to store the Z scores.');

end

if((1==handles.SubTestData.CalcZScores)&&(isempty(handles.SubTestData.ZScoreUseRawScore)))
    LogFn(handles.FilePointers.LogFile,'\nNo method of calculating ZScores specified.');
    error('No method of calculating ZScores specified.');
end

if(...
    ((1==handles.SubTestData.SelSubTestMethodNeedsRef)||(1==handles.SubTestData.CalcDMOS)||...
    (1==handles.SubTestData.CalcZScores) &&(0==handles.SubTestData.ZScoreUseRawScore) ) &&...
    ((~isfield(handles.SubTestData,'RefFiles'))|| (isempty(handles.SubTestData.RefFiles)))...
  )
    %The testing method requires a reference but a reference was not
    %specified.
    LogFn(handles.FilePointers.LogFile,'\nSubjective Testing method requires reference files. Reference files are missing.');
    error('Subjective Testing method requires reference files. Reference files are missing.');

end
if(...
   (1==handles.SubTestData.CalcDMOS) &&...
   (numel(handles.SubTestData.RefFiles)~=numel(handles.SubTestData.TestFiles))...
   )
    LogFn(handles.FilePointers.LogFile,'\nNumber of reference and test files do not match, or, references not specified for DMOS calculation.');
    error('Number of reference and test files do not match, or, references not specified for DMOS calculation.');
end

mode=[];

if(2==exist(handles.SubTestData.RawSubScoreFile,'file'))
    msg=sprintf('Selected Output file already exists. Add another subject and recalculate Mean Opinion Score (MOS)?\n\n"Yes" to append,\n"No" to overwrite existing,\n"Cancel" to return to the Subjective Testing tab and select new file.\n');
    Choice=questdlg(msg);
    switch(Choice)
        case {'Yes'}
            mode='append';
     case {'No'}
            mode='overwrite';
      case {'Cancel'}
          return;
    end
end

%Check if the blind references are present in the test lists.
RefIdx=[];
if(...
    (0==handles.SubTestData.SelSubTestMethodNeedsRef) && ...The Method is normally a no reference method
    ((1==handles.SubTestData.CalcDMOS)||... DMOS Calculation requires reference for both methods (With Z and without Z)
    (1==handles.SubTestData.CalcZScores) &&(0==handles.SubTestData.ZScoreUseRawScore))...The Z Score calculation requires d score
   )
    tmp=setdiff(handles.SubTestData.RefFiles,handles.SubTestData.TestFiles);

    if(~isempty(tmp))
        LogFn(handles.FilePointers.LogFile,'\nSome of the reference files are not present in the list of test files. The reference files must be present in the test file list because they are blind references.');
        error('Some of the reference files are not present in the list of test files. The reference files must be present in the test file list because they are blind references.');
    else
        [tf, RefIdx]=ismember(handles.SubTestData.RefFiles,handles.SubTestData.TestFiles);
    end
end

%This is where references can be inserted into test lists if they are not
%present, but required (blind references)

%This is where the permutations can be calculated.

%Copying relevant parameters into variable that will be passed.

SubTestParam.SessionType=handles.SubTestData.SessionType;
SubTestParam.TargetType=handles.SubTestData.TargetType;

SubTestParam.TestFormat=handles.SubTestData.TestFormat;
SubTestParam.TestImageWidth=handles.SubTestData.TestImageWidth;
SubTestParam.TestImageHeight=handles.SubTestData.TestImageHeight;
SubTestParam.TestFiles=handles.SubTestData.TestFiles;

SubTestParam.RefFormat=handles.SubTestData.RefFormat;
SubTestParam.RefImageWidth=handles.SubTestData.RefImageWidth;
SubTestParam.RefImageHeight=handles.SubTestData.RefImageHeight;
SubTestParam.RefFiles=handles.SubTestData.RefFiles;

SubTestParam.RawSubScoreFile=handles.SubTestData.RawSubScoreFile;

SubTestParam.mode=mode;

SubTestParam.AutoGenerateSubNum=handles.ToolOptions.AutoSub;
SubTestParam.SubjectNum=handles.ToolOptions.SubjectNum;

SubTestParam.SelSubTestMethod=handles.SubTestData.SelSubTestMethod(1);
SubTestParam.Player=handles.Player;

%Perform subjective testing
bProceed=0;
try
    msg=['Calling the subjective testing code: ' char(handles.SubTestData.SelSubTestMethod)];
    LogFn(handles.FilePointers.LogFile,msg);
    bProceed=feval('SSCQS',SubTestParam);
    while(1~=bProceed)
    end
catch RetErr

    msg=['\nErrors while performing subjective testing. Error: ' RetErr.message];
    error(msg);
    LogFn(handles.FilePointers.LogFile,msg);
end

if('t'==handles.SubTestData.SessionType)
    %skip the calculations
    return;
end
%Check if any calculations are needed here. If not, we can exit here.
if((1==handles.SubTestData.CalcMOS)||(1==handles.SubTestData.CalcSTD)||(1==handles.SubTestData.CalcDMOS)||(1==handles.SubTestData.CalcZScores))
%Perform Calculations

%Read the written raw subjective scores

[num,txt]=ReadTabulatedValues(handles.SubTestData.RawSubScoreFile);

[NumOfSubjects,LastSubject,SubColIdx]=ReadSubjectNumbers(lower(txt(1,:)));
NumOfTestFiles=numel(handles.SubTestData.TestFiles);
SubjectiveScoreIndices=[];
 if(isempty(SubColIdx))
    LogFn(handles.FilePointers.LogFile,'\nNo subject columns found in raw subjective scores file.');
    error('No subject columns found in raw subjective scores file.');
 else
    SubjectiveScoreIndices=SubColIdx-1;
 end

 NumOfCols=(1==handles.SubTestData.CalcMOS)+(1==handles.SubTestData.CalcSTD)+(1==handles.SubTestData.CalcDMOS);
 NumOfRows=size(num,1);
 CalcResults=zeros(NumOfRows,NumOfCols);
 OutputArray=cell(NumOfRows+1,NumOfCols+1);
 OutputArray{1,1}='filename';
 OutputArray(2:end,1)=handles.SubTestData.TestFiles;
 StartCol=1;
 SubScores=num(:,SubjectiveScoreIndices);

 %Calculating Difference Scores that will be used for DMOS and Z Score calculation
 %later.
 RefLines=[];
 if(~isempty(RefIdx))
     dScores=zeros(NumOfTestFiles,NumOfSubjects);
     for i=1:NumOfTestFiles
            dScores(i,:)=SubScores(RefIdx(i),:)-SubScores(i,:);
     end
    %Eliminate references
    RefLines=unique(RefIdx);
    dScores(RefLines,:)=[];
 end

if(1==handles.SubTestData.CalcMOS)
    CalcResults(:,StartCol)=mean(SubScores,2);
    OutputArray{1,1+StartCol}='MOS';
    StartCol=StartCol+1;
end

if(1==handles.SubTestData.CalcSTD)
    CalcResults(:,StartCol)=std(SubScores,0,2);
    OutputArray{1,1+StartCol}='STD';
    StartCol=StartCol+1;
end

if(1==handles.SubTestData.CalcZScores)

    if(1==handles.SubTestData.ZScoreUseRawScore)
        TmpScores=SubScores;
        ScoreTypeString='Raw';
    else
        TmpScores=dScores;
        ScoreTypeString='Difference';
    end

    NumOfFiles=size(TmpScores,1);
    ZScores=zeros(size(TmpScores));
    m4=zeros(NumOfFiles,1);

    MeanSubScores=mean(TmpScores,1);
    SigmaSubScores=std(TmpScores,0,1);

    for i=1:NumOfSubjects
            Divisor=SigmaSubScores(i)+(0==SigmaSubScores(i));
            Numerator=(TmpScores(:,i)-MeanSubScores(i));
            ZScores(:,i)=Numerator/Divisor;
            m4(:,1)=m4(:,1)+(Numerator.^4);
    end

    m4=m4./NumOfSubjects;
    m2=var(TmpScores,1,2);

    Beta2=m4./m2;

    TestFileMeans=mean(TmpScores,2);
    TestFileSTD=std(TmpScores,0,2);

    MFactor=zeros(NumOfFiles,1);

    for i=1:NumOfFiles
        if((Beta2(i)>=2) && (Beta2(i)<=4))
            %Normal distribution
            MFactor(i)=2;
        else
            %Non normal distribution
            MFactor(i)=sqrt(20);
        end

    end

    PCond= TestFileMeans(:,1)+(MFactor(:,1).*TestFileSTD(:,1));
    QCond= TestFileMeans(:,1)-(MFactor(:,1).*TestFileSTD(:,1));
    P=zeros(NumOfSubjects,1);
    Q=zeros(NumOfSubjects,1);

    for i=1:NumOfSubjects
       P(i,1)= sum(TmpScores(:,i)>=PCond);
       Q(i,1)=sum(TmpScores(:,i)<=QCond);
    end

   PPlusQ=P+Q;
   PMinusQ=P-Q;
   Cond1=PPlusQ./size(TmpScores,1);
   Cond2=abs(PPlusQ./PMinusQ);


   SubToReject=find((Cond1>0.05) & (Cond2<0.3));
   ZScores(:,SubToReject)=NaN;

   %Scale the Z Scores

   ZScoresScaled=((ZScores+3)*100)./6;

   %Write, ZScores, SubToReject and ZScoresScaled into a file

   ZScoreArray=txt;
   %Eliminate references if any
   ZScoreArray(RefLines+1,:)=[];
   ZScoreArray(2:end,2:end)=num2cell(ZScores);
   ZScoreScaledArray=ZScoreArray;
   ZScoreScaledArray(2:end,2:end)=num2cell(ZScoresScaled);
   WriteZScores(handles.SubTestData.ZScoresFile,ZScoreArray,SubToReject,ZScoreScaledArray,ScoreTypeString);

end

if(1==handles.SubTestData.CalcDMOS)

    if(1==handles.SubTestData.DMOSUseZScore)
        TmpScores=ZScoresScaled;
    else
        TmpScores=dScores;
    end
    DMOS=nanmean(TmpScores,2);
    Idx=1:size(CalcResults,1);
    Idx(RefLines)=[];


    CalcResults(Idx,StartCol)=deal(DMOS(:));


    OutputArray{1,1+StartCol}='DMOS';
    StartCol=StartCol+1;
end

    %Writing the scores
    try
        if(~isempty(CalcResults))
            OutputArray(2:end,2:end)=num2cell(CalcResults);
            WriteCalcSubScores(handles.SubTestData.ScoresFile,OutputArray);
        end
    catch RetErr
        msg=['\nErrors while writing subjective testing scores. Error: ' RetErr.message];
        LogFn(handles.FilePointers.LogFile,msg);
        error(msg);
    end
    
end %if((1==handles.SubTestData.CalcMOS)||(1==handles.SubTestData.CalcSTD)||(1==handles.SubTestData.CalcDMOS)||(1==handles.SubTestData.CalcZScores))
