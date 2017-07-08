%=====================================================================
% File: DefaultOptions.m
%=====================================================================


function [OptionsArray]=DefaultOptions(OptionsArray)
%Function that sets the default settings for the options configuration UI

    %Objective tab settings
    OptionsArray.ProgressUpdate=1;
    OptionsArray.DisplayImage=0;

    %Correlation tab settings
    OptionsArray.PlotMOS=0;
    OptionsArray.PlotPrediction=0;
    OptionsArray.PlotOutlierBounds=0;
    OptionsArray.OutlierDisplay='normal';

    OptionsArray.SavePlots=0;
    OptionsArray.PlotPath=[];
    OptionsArray.SaveMOS=0;
    OptionsArray.MOSSaveFile=[];

    OptionsArray.LogisticChoice='default';
    OptionsArray.ModelFn=[];
    OptionsArray.ModelFnVar=[];


    %Generate test media tab settings
    OptionsArray.DisplayRefImage=0;
    OptionsArray.DisplayGenImage=0;
    OptionsArray.AutoFilename=1;
    OptionsArray.GenFilenameSuffix=[];

    %Subjective tab settings
    OptionsArray.AutoSub=1;
    OptionsArray.SubjectNum=[];

    %General tab settings
    OptionsArray.LogFilename=[];
