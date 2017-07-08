%=====================================================================
% File: WriteZScores.m
%=====================================================================

function WriteZScores(filename,ZScoreArray,RejectedSub,ZScoreScaledArray,ScoreTypeString)
%Function that writes the Z-Scores into a file.

    str={['ZScores calculated using ' ScoreTypeString ' scores']};

	%Identify the extension
    [dummy1,dummy2,ext]=fileparts(filename);

    tmp=lower(ext(2:end));
      switch tmp

        case {'xls','xlsx'}
            %MATLAB warns you if you add a sheet at the end.
            warning off MATLAB:xlswrite:AddSheet
            xlswrite(filename,str,'ZScores','a1');
            xlswrite(filename,ZScoreArray,'ZScores','a3');

            if(~isempty(RejectedSub))
                xlswrite(filename,RejectedSub,'Rejected Subjects');
            end
            xlswrite(filename,ZScoreScaledArray,'Scaled ZScores');
            
        case {'csv','txt'}
            fid=fopen(filename,'w');
            if(-1==fid)
                error('Unable to open the file for writing the output.');
            else
                fprintf(fid,'\n===========================================');
                fprintf(fid,'\n');fprintf(fid,char(str));
                fprintf(fid,'\n===========================================');
                fprintf(fid,'\n');
                [Rows,Cols]=size(ZScoreArray);
                ClassMap=cellfun('isclass',ZScoreArray,'char');
                ConversionFn=cell(size(ZScoreArray));
                ConversionFn(:,:)=cellstr('num2str');
                ConversionFn(ClassMap)=cellstr('char');
                for i=1:Rows
                    for j=1:Cols
                        fprintf(fid,'%s,',feval(ConversionFn{i,j},ZScoreArray{i,j}));
                    end
                    fprintf(fid,'\n');
                end
                fprintf(fid,'\n===========================================');
                fprintf(fid,'\nRejected Subjects');
                fprintf(fid,'\n===========================================');
                fprintf(fid,'\n');
                if(~isempty(RejectedSub))
                    ClassMap=cellfun('isclass',RejectedSub,'char');
                    ConversionFn=cell(size(RejectedSub));
                    ConversionFn(:,:)=cellstr('num2str');
                    ConversionFn(ClassMap)=cellstr('char');

                    for i=1:length(RejectedSub)
                            fprintf(fid,'%s,',feval(ConversionFn{i},RejectedSub{i}));
                    end
                end

                fprintf(fid,'\n===========================================');
                fprintf(fid,'\nScaled ZScores');
                fprintf(fid,'\n===========================================');
                fprintf(fid,'\n');
                [Rows,Cols]=size(ZScoreScaledArray);
                ClassMap=cellfun('isclass',ZScoreScaledArray,'char');
                ConversionFn=cell(size(ZScoreScaledArray));
                ConversionFn(:,:)=cellstr('num2str');
                ConversionFn(ClassMap)=cellstr('char');
                for i=1:Rows
                    for j=1:Cols
                        fprintf(fid,'%s,',feval(ConversionFn{i,j},ZScoreScaledArray{i,j}));
                    end
                    fprintf(fid,'\n');

                end
                fclose(fid);
            end %fid~=-1
          case {'html'}
                fid=fopen(filename,'w');
                if(-1==fid)
                    error('Could not open output file for writing');
                else
                    %InsertinHTML searches for the tag '<body>' everytime. 
                    %Hence we have to insert in reverse order- Scaled 
                    %Z Scores followed by Rejected subjects and finally raw
                    %Z Scores.This ensures that we get the following layout:
                    %
                    % <body>
                    % Raw Z Scores
                    % Rejected subjects
                    % Scaled Z Scores
                    % </body>
                    
                    OutputBuffer=GenerateHTMLBody('Z Scores');
                    TableBuffer=GenerateHTMLTable(ZScoreScaledArray,1,0);
                    OutputBuffer=InsertinHTML(OutputBuffer,['<p>' TableBuffer '</p>'],'<body>');
                    OutputBuffer=InsertinHTML(OutputBuffer,'<h4>Scaled Z Scores</h4>','<body>');

                    TableBuffer=GenerateHTMLTable(num2cell(RejectedSub),0,0);
                    OutputBuffer=InsertinHTML(OutputBuffer,['<p>' TableBuffer '</p>'],'<body>');
                    OutputBuffer=InsertinHTML(OutputBuffer,'<h4>Rejected Subjects</h4>','<body>');

                    TableBuffer=GenerateHTMLTable(ZScoreArray,1,0);
                    OutputBuffer=InsertinHTML(OutputBuffer,['<p>' TableBuffer '</p>'],'<body>');
                    tmp=['<h4>' char(str) '</h4>'];
                    OutputBuffer=InsertinHTML(OutputBuffer,tmp,'<body>');

                    fwrite(fid,OutputBuffer,'uchar');
                    fclose(fid);
                end
          otherwise
                error('Unsupported output file format.');

      end %switch tmp
