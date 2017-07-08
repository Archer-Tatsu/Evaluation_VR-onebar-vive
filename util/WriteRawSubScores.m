%=====================================================================
% File: WriteRawSubScores.m
%=====================================================================

function WriteRawSubScores(filename,OutputArray)
%Function that writes the raw subject scores to a file.

	%Identify the extension
    [dummy1,dummy2,ext]=fileparts(filename);
    tmp=lower(ext(2:end));
      switch tmp

        case {'xls','xlsx'}
            xlswrite(filename,OutputArray);
        case {'csv','txt'}
            fid=fopen(filename,'w');
            if(-1==fid)
                error('Unable to open the file for writing the output.');
            else
                [Rows,Cols]=size(OutputArray);
                ClassMap=cellfun('isclass',OutputArray,'char');
                ConversionFn=cell(size(OutputArray));
                ConversionFn(:,:)=cellstr('num2str');
                ConversionFn(ClassMap)=cellstr('char');
                for i=1:Rows
                    for j=1:Cols
                        fprintf(fid,'%s,',feval(ConversionFn{i,j},OutputArray{i,j}));
                    end
                    fprintf(fid,'\n');
                end
                fclose(fid);
                
            end %fid~=-1
            
        case {'html'}

            WriteHtmlOutput(filename,OutputArray,'Subjective testing  Output: Raw Scores',1,0);
        otherwise
            error('Unsupported output file format.');

      end %switch tmp
