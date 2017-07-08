%=====================================================================
% File: ReadTabulatedValues.m
%=====================================================================

function [num,txt]=ReadTabulatedValues(filename)
%Function that reads the tabulated values from the specified file.

%Identify the extension
    [pathstr,name,ext]=fileparts(filename);
    tmp=lower(ext(2:end));
      switch tmp
          case {'xls','xlsx'}
              try
                [num,txt]=xlsread(filename);
              catch RetErr                
                error(RetErr.message);
              end
          case {'csv','txt'}
                try
                    Tmp=importdata(filename);
                    if((isfield(Tmp,'data')) && (isfield(Tmp,'data')))
                        num=Tmp.data;
                        txt=Tmp.textdata;
                    else
                        error('Error reading file.');
                    end
                catch RetErr
                    error(RetErr.message);
                end
          otherwise
                error('Unsupported input file format.');

      end %switch tmp
