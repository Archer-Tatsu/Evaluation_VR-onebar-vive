%=====================================================================
% File: Progress.m
%=====================================================================
 
function varargout = Progress(varargin)
% PROGRESS M-file for Progress.fig
%      PROGRESS, by itself, creates a new PROGRESS or raises the existing
%      singleton*.
%
%      H = PROGRESS returns the handle to a new PROGRESS or the handle to
%      the existing singleton*.
%
%      PROGRESS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROGRESS.M with the given input arguments.
%
%      PROGRESS('Property','Value',...) creates a new PROGRESS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Progress_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Progress_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help Progress

% Last Modified by GUIDE v2.5 23-Apr-2009 16:23:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Progress_OpeningFcn, ...
                   'gui_OutputFcn',  @Progress_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Progress is made visible.
function Progress_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Progress (see VARARGIN)

% Choose default command line output for Progress
handles.output = hObject;

[Args]=ParseInputs(varargin{:});
if(~isempty(Args.MetricName))
    set(handles.MetricName,'String',Args.MetricName);
end

if(~isempty(Args.TestFilename))
    set(handles.FileName,'String',Args.TestFilename);
end  

if(~isempty(Args.StatusMsg))
    set(handles.StatusMsg,'String',Args.StatusMsg);
end    

if((~isempty(Args.MetricNumber)) && (~isempty(Args.NumOfMetrics)))
    Percentage=(Args.MetricNumber*100)/Args.NumOfMetrics;
    xpatch=[0 Percentage Percentage 0];
    ypatch=[0 0 1 1];
    axes(handles.MetricsProgressBar);
    %Repaint the axes because cla doesn't seem to work.
    cla reset;
    set(handles.MetricsProgressBar,...
        'XLim',[0 100],...
        'Box','on', ...
        'XTickMode','manual',...
        'YTickMode','manual',...
        'XTick',[],...
        'YTick',[],...
        'XTickLabelMode','manual',...
        'XTickLabel',[],...
        'YTickLabelMode','manual',...
        'YTickLabel',[]...
        );
    p = patch(xpatch,ypatch,'b','EdgeColor','b','EraseMode','none');
    temp=[num2str(Args.MetricNumber) '/' num2str(Args.NumOfMetrics)];
    set(handles.MetricCount,'String',temp);
end 

if((~isempty(Args.TestFileNumber)) && (~isempty(Args.NumOfTestFiles)))
    Percentage=(Args.TestFileNumber*100)/Args.NumOfTestFiles;
    xpatch=[0 Percentage Percentage 0];
    ypatch=[0 0 1 1];
    axes(handles.FilesProgressBar);
    %Repaint the axes because cla doesn't seem to work.
    cla reset;
    set(handles.FilesProgressBar,...
        'XLim',[0 100],...
        'Box','on', ...
        'XTickMode','manual',...
        'YTickMode','manual',...
        'XTick',[],...
        'YTick',[],...
        'XTickLabelMode','manual',...
        'XTickLabel',[],...
        'YTickLabelMode','manual',...
        'YTickLabel',[]...
        );
    p = patch(xpatch,ypatch,'b','EdgeColor','b','EraseMode','none');
    temp=[num2str(Args.TestFileNumber) '/' num2str(Args.NumOfTestFiles)];
    set(handles.FileCount,'String',temp);
end 
if((~isempty(Args.MetricNumber)) && (~isempty(Args.TestFileNumber)) && (~isempty(Args.NumOfMetrics)) && (~isempty(Args.NumOfTestFiles)))
    Num=((Args.TestFileNumber-1)*Args.NumOfMetrics)+Args.MetricNumber;
    Denom=Args.NumOfMetrics*Args.NumOfTestFiles;
    PercentComplete=floor((Num*100)/Denom);
    msg=[num2str(PercentComplete) '% Complete.'];
    set(handles.ProgressWindow,'name',msg);
else
    set(handles.ProgressWindow,'name','Progress...');
end
  
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Progress wait for user response (see UIRESUME)
% uiwait(handles.ProgressWindow);


% --- Outputs from this function are returned to the command line.
function varargout = Progress_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% % --- Executes on button press in OK.
% function OK_Callback(hObject, eventdata, handles)
% % hObject    handle to OK (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% close(handles.ProgressWindow); 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Function to parse command line arguments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Args]=ParseInputs(varargin)

    Args.MetricName=[];
    Args.TestFilename=[];
    Args.StatusMsg=[];
    Args.NumOfMetrics=[];
    Args.NumOfTestFiles=[];
    Args.MetricNumber=[];
    Args.TestFileNumber=[];
    k=1;
    
    LengthArgIn=length(varargin);
    while (k <=LengthArgIn )
        arg = varargin{k};
        
         if((isfield(arg, 'MetricName')) &&(~isempty(arg.MetricName)))
            Args.MetricName=arg.MetricName;
         end
         if((isfield(arg, 'TestFilename')) &&(~isempty(arg.TestFilename)))
            Args.TestFilename=arg.TestFilename;
         end
         if((isfield(arg, 'StatusMsg')) &&(~isempty(arg.StatusMsg)))
            Args.StatusMsg=arg.StatusMsg;
         end
         if((isfield(arg, 'NumOfMetrics')) &&(~isempty(arg.NumOfMetrics)))
            Args.NumOfMetrics=arg.NumOfMetrics;
         end
         if((isfield(arg, 'NumOfTestFiles')) &&(~isempty(arg.NumOfTestFiles)))
            Args.NumOfTestFiles=arg.NumOfTestFiles;
         end
         if((isfield(arg, 'MetricNumber')) &&(~isempty(arg.MetricNumber)))
            Args.MetricNumber=arg.MetricNumber;
         end
         if((isfield(arg, 'TestFileNumber')) &&(~isempty(arg.TestFileNumber)))
            Args.TestFileNumber=arg.TestFileNumber;
        end
        k=k+1;
        
    end %while(k<=LengthArgIn)

%end %ParseInputs(varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
