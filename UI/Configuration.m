%=====================================================================
% File: Configuration.m
%=====================================================================

function varargout = Configuration(varargin)
%Configuration M-file for Configuration.fig
%      Configuration, by itself, creates a new Configuration or raises the existing
%      singleton*.
%
%      H = Configuration returns the handle to a new Configuration or the handle to
%      the existing singleton*.
%
%      Configuration('Property','Value',...) creates a new Configuration using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to IVQUESTGUI_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      Configuration('CALLBACK') and Configuration('CALLBACK',hObject,...) call the
%      local function named CALLBACK in Configuration.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Configuration

% Last Modified by GUIDE v2.5 09-Sep-2016 11:04:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Configuration_OpeningFcn, ...
                   'gui_OutputFcn',  @Configuration_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before Configuration is made visible.
function Configuration_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for Configuration
clc
handles.output = [];
guidata(handles.Configuration,handles);

TabsInUI={'SubjectiveMetrics'};

handles.MediaType='V';
handles.MetricType='FR';

handles=ResetMetricData(handles);
guidata(handles.Configuration,handles);

[handles]=ResetCorrelationData(handles);
guidata(handles.Configuration,handles);

[handles]=ResetTestGenData(handles);
guidata(handles.Configuration,handles);

[handles]= ResetSubTestData(handles);
guidata(handles.Configuration,handles);

handles=InitializeToolOptions(handles);
guidata(handles.Configuration,handles);

handles=InitializeFilePointers(handles);
guidata(handles.Configuration,handles);


[filename, pathname] = uigetfile('*.exe','Please Choose a VR Player...');
if(filename==0)
    errordlg('Invalid player path','Invalid input','modal');
    error('Invalid player path');
    return;
else
    handles.Player.Path=pathname;
    handles.Player.Name=filename;
end


handles=TabElementsInit(handles,1);

guidata(handles.Configuration,handles);


% --- Outputs from this function are returned to the command line.
function varargout = Configuration_OutputFcn(hObject, eventdata, ~)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = [];

% --- Executes when user attempts to close Configuration.
function Configuration_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to Configuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure


delete(hObject);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tool Control callbacks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in Start.
function Start_Callback(hObject, eventdata, handles)
% hObject    handle to Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

TabsInUI={'SubjectiveMetrics'};

TabHandlers={'HandleSubjective'};

%Deactivate other tabs to prevent switching.
InactiveTabs=setdiff(TabsInUI,TabsInUI(1));

for i=1:length(InactiveTabs)
    set(getfield(handles,InactiveTabs{i}),'Enable','off');
end

%Deactivate start
set(handles.Start,'Enable','off');

%Start logging if logging is enabled.

if(...
    (isfield(handles.ToolOptions,'LogFilename')) && ...
    (~isempty(handles.ToolOptions.LogFilename))...
  )
    handles.FilePointers.LogFile=fopen(handles.ToolOptions.LogFilename,'a');
    if(-1==handles.FilePointers.LogFile)
        %Logfile could not be opened.
        warndlg('Log file could not be opened','Warning','non-modal');
        LogFn=@NoLogging;
    else
        %start logging
        LogFn=@PerformLogging;
        LogFn(handles.FilePointers.LogFile,'Logging Started...');

    end
else
    LogFn=@NoLogging;
end
guidata(handles.Configuration,handles);

%Evaluate this tab

try
    feval(TabHandlers{1},handles);
catch RetErr
    LogFn(handles.FilePointers.LogFile,RetErr.message);
    errordlg(RetErr.message,'Please fix these errors','modal');
end
%Activate start
set(handles.Start,'Enable','on');

%Activate other tabs
for i=1:length(InactiveTabs)
    set(getfield(handles,InactiveTabs{i}),'Enable','on');
end
if(-1~=handles.FilePointers.LogFile)
    fclose(handles.FilePointers.LogFile);
    handles.FilePointers.LogFile=-1;
end

% --- Executes on button press in Help.
function Help_Callback(hObject, eventdata, handles)
% hObject    handle to Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
HelpPath=which('help.html');
HelpTag=[HelpPath '#how-to-use'];
web(HelpTag,'-browser');

% --- Executes on button press in Close.
function Close_Callback(hObject, eventdata, handles)
% hObject    handle to Close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.Configuration);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tab callbacks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in SubjectiveMetrics.
function SubjectiveMetrics_Callback(hObject, eventdata, handles)
% hObject    handle to SubjectiveMetrics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=ActivateTab(handles,'SubjectiveMetrics');
guidata(handles.Configuration,handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File IO callbacks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in TestFile.
function TestFiles_Callback(hObject, eventdata, handles)
% hObject    handle to TestFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FileDetails=SelectSource(handles.MediaType);
if((isfield(FileDetails,'Format')) && (~isempty(FileDetails.Format)))
    handles.MetricData.TestFormat=FileDetails.Format;
end
if((isfield(FileDetails,'Width')) && (~isempty(FileDetails.Width)))
    handles.MetricData.TestImageWidth=FileDetails.Width;
end
if((isfield(FileDetails,'Height')) && (~isempty(FileDetails.Height)))
    handles.MetricData.TestImageHeight=FileDetails.Height;
end
if((isfield(FileDetails,'FPS')) && (~isempty(FileDetails.FPS)))
    handles.MetricData.TestFPS=FileDetails.FPS;
end
if((isfield(FileDetails,'Files')) && (~isempty(FileDetails.Files)))
    handles.MetricData.TestFiles=FileDetails.Files;
end
guidata(handles.Configuration,handles);

% --- Executes on button press in RefFiles.
function RefFiles_Callback(hObject, eventdata, handles)
% hObject    handle to RefFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FileDetails=SelectSource(handles.MediaType);
if((isfield(FileDetails,'Format')) && (~isempty(FileDetails.Format)))
    handles.MetricData.RefFormat=FileDetails.Format;
end
if((isfield(FileDetails,'Width')) && (~isempty(FileDetails.Width)))
    handles.MetricData.RefImageWidth=FileDetails.Width;
end
if((isfield(FileDetails,'Height')) && (~isempty(FileDetails.Height)))
    handles.MetricData.RefImageHeight=FileDetails.Height;
end
if((isfield(FileDetails,'FPS')) && (~isempty(FileDetails.FPS)))
    handles.MetricData.RefFPS=FileDetails.FPS;
end
if((isfield(FileDetails,'Files')) && (~isempty(FileDetails.Files)))
    handles.MetricData.RefFiles=FileDetails.Files;
end
guidata(handles.Configuration,handles);



% --- Executes on button press in OutputFile.
function OutputFile_Callback(hObject, eventdata, handles)
% hObject    handle to OutputFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FormatFile=which('SupOutputFormats.csv');

Filterspec=ReturnFileFilter(FormatFile);

[OutputFile, OutputPath] = uiputfile(Filterspec,'Please specify an output file.');
if((isnumeric(OutputFile)) &&(0==OutputFile))
else
     handles.MetricData.OutputFilename=fullfile(OutputPath,OutputFile);
end

guidata(handles.Configuration,handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Subjective Testing Tab UI elements callbacks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on selection change in SessionType.
function SessionType_Callback(hObject, eventdata, handles)
% hObject    handle to SessionType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SessionType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SessionType
tmp=get(hObject,'Value');
switch (tmp)
    case 2
            handles.SubTestData.SessionType='t';
    case 3
            handles.SubTestData.SessionType='a';
    otherwise
        %Nothing has been selected.

end %switch (tmp)
guidata(handles.Configuration,handles);


% --- Executes during object creation, after setting all properties.
function SessionType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SessionType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in Methodology.
function Methodology_Callback(hObject, eventdata, handles)
% hObject    handle to Methodology (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Methodology contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Methodology

tmp=get(hObject,'Value');
if(1~=tmp)
    handles.SubTestData.SelSubTestMethod=handles.SubTestData.AvailableSubTestMethods(tmp);
    handles.SubTestData.SelSubTestMethodNeedsRef=handles.SubTestData.SubTestMethodTypes(tmp-1);
else
    %Nothing has been selected.
    handles.SubTestData.SelSubTestMethod=[];
    handles.SubTestData.SelSubTestMethodNeedsRef=[];
end

guidata(handles.Configuration,handles);

% --- Executes during object creation, after setting all properties.
function Methodology_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Methodology (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in TargetType.
function TargetType_Callback(hObject, eventdata, handles)
% hObject    handle to TargetType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns TargetType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from TargetType
tmp=get(hObject,'Value');
switch (tmp)
    case 2
            handles.SubTestData.TargetType='q';
    case 3
            handles.SubTestData.TargetType='u';
    otherwise
        %Nothing has been selected.
end %switch (tmp)
guidata(handles.Configuration,handles);

% --- Executes during object creation, after setting all properties.
function TargetType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TargetType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in SubRefFiles.
function SubRefFiles_Callback(hObject, eventdata, handles)
% hObject    handle to SubRefFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in RawSubScoreBrowse.
FileDetails=SelectSource(handles.MediaType);
if((isfield(FileDetails,'Format')) && (~isempty(FileDetails.Format)))
    handles.SubTestData.RefFormat=FileDetails.Format;
end
if((isfield(FileDetails,'Width')) && (~isempty(FileDetails.Width)))
    handles.SubTestData.RefImageWidth=FileDetails.Width;
end
if((isfield(FileDetails,'Height')) && (~isempty(FileDetails.Height)))
    handles.SubTestData.RefImageHeight=FileDetails.Height;
end
if((isfield(FileDetails,'FPS')) && (~isempty(FileDetails.FPS)))
    handles.SubTestData.RefFPS=FileDetails.FPS;
end
if((isfield(FileDetails,'Files')) && (~isempty(FileDetails.Files)))
    handles.SubTestData.RefFiles=FileDetails.Files;
end
guidata(handles.Configuration,handles);


% --- Executes on button press in SubTestFiles.
function SubTestFiles_Callback(hObject, eventdata, handles)
% hObject    handle to SubTestFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FileDetails=SelectSource(handles.MediaType);
if((isfield(FileDetails,'Format')) && (~isempty(FileDetails.Format)))
    handles.SubTestData.TestFormat=FileDetails.Format;
end
if((isfield(FileDetails,'Width')) && (~isempty(FileDetails.Width)))
    handles.SubTestData.TestImageWidth=FileDetails.Width;
end
if((isfield(FileDetails,'Height')) && (~isempty(FileDetails.Height)))
    handles.SubTestData.TestImageHeight=FileDetails.Height;
end
if((isfield(FileDetails,'FPS')) && (~isempty(FileDetails.FPS)))
    handles.SubTestData.TestFPS=FileDetails.FPS;
end
if((isfield(FileDetails,'Files')) && (~isempty(FileDetails.Files)))
    handles.SubTestData.TestFiles=FileDetails.Files;
end
guidata(handles.Configuration,handles);


function RawSubScoreBrowse_Callback(hObject, eventdata, handles)
% hObject    handle to RawSubScoreBrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FormatFile=which('SupOutputFormats.csv');

Filterspec=ReturnFileFilter(FormatFile);

[OutputFile, OutputPath] = uiputfile(Filterspec,'Please specify an output file for the raw subjective scores.');
if((isnumeric(OutputFile)) &&(0==OutputFile))
else
    handles.SubTestData.RawSubScoreFile=fullfile(OutputPath,OutputFile);
end

guidata(handles.Configuration,handles);


% --- Executes on button press in CalcMOS.
function CalcMOS_Callback(hObject, eventdata, handles)
% hObject    handle to CalcMOS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CalcMOS
handles.SubTestData.CalcMOS=get(hObject,'Value');

if((0==handles.SubTestData.CalcMOS) && (0==handles.SubTestData.CalcDMOS) && (0==handles.SubTestData.CalcSTD))
        set(handles.ScoresFileBrowse,'enable','off');
else
        set(handles.ScoresFileBrowse,'enable','on');
end
guidata(handles.Configuration,handles);


% --- Executes on button press in CalcSTD.
function CalcSTD_Callback(hObject, eventdata, handles)
% hObject    handle to CalcSTD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CalcSTD
handles.SubTestData.CalcSTD=get(hObject,'Value');

if((0==handles.SubTestData.CalcMOS) && (0==handles.SubTestData.CalcDMOS) && (0==handles.SubTestData.CalcSTD))
        set(handles.ScoresFileBrowse,'enable','off');
else
        set(handles.ScoresFileBrowse,'enable','on');
end
guidata(handles.Configuration,handles);


% --- Executes on button press in CalcDMOS.
function CalcDMOS_Callback(hObject, eventdata, handles)
% hObject    handle to CalcDMOS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CalcDMOS
handles.SubTestData.CalcDMOS=get(hObject,'Value');

if((0==handles.SubTestData.CalcMOS) && (0==handles.SubTestData.CalcDMOS) && (0==handles.SubTestData.CalcSTD))
        set(handles.ScoresFileBrowse,'enable','off');
else
        set(handles.ScoresFileBrowse,'enable','on');
end
if(1==handles.SubTestData.CalcDMOS)
    set(handles.DMOSText,'enable','on');
    set(handles.DMOSCalcMethod,'enable','on');
else
    set(handles.DMOSText,'enable','off');
    set(handles.DMOSCalcMethod,'enable','off');

end
guidata(handles.Configuration,handles);

% --- Executes on selection change in DMOSCalcMethod.
function DMOSCalcMethod_Callback(hObject, eventdata, handles)
% hObject    handle to DMOSCalcMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns DMOSCalcMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DMOSCalcMethod
tmp=get(hObject,'Value');
switch(tmp)
    case 2
        handles.SubTestData.DMOSUseZScore=0;
    case 3
        handles.SubTestData.DMOSUseZScore=1;

end %switch(tmp)


guidata(handles.Configuration,handles);


% --- Executes during object creation, after setting all properties.
function DMOSCalcMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DMOSCalcMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in CalcZScores.
function CalcZScores_Callback(hObject, eventdata, handles)
% hObject    handle to CalcZScores (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CalcZScores
handles.SubTestData.CalcZScores=get(hObject,'Value');
if(1==handles.SubTestData.CalcZScores)
    set(handles.ZScoresFileBrowse,'enable','on');
    set(handles.ZScoreText,'enable','on');
    set(handles.ZScoreCalcMethod,'enable','on');

else
    set(handles.ZScoresFileBrowse,'enable','off');
    set(handles.ZScoreText,'enable','off');
    set(handles.ZScoreCalcMethod,'enable','off');
end

guidata(handles.Configuration,handles);

% --- Executes on button press in ZScoresFileBrowse.
function ZScoresFileBrowse_Callback(hObject, eventdata, handles)
% hObject    handle to ZScoresFileBrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FormatFile=which('SupOutputFormats.csv');

Filterspec=ReturnFileFilter(FormatFile);

[OutputFile, OutputPath] = uiputfile(Filterspec,'Please specify an output file for the Z Scores.');
if((isnumeric(OutputFile)) &&(0==OutputFile))
else
    handles.SubTestData.ZScoresFile=fullfile(OutputPath,OutputFile);
end

guidata(handles.Configuration,handles);


% --- Executes on selection change in ZScoreCalcMethod.
function ZScoreCalcMethod_Callback(hObject, eventdata, handles)
% hObject    handle to ZScoreCalcMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ZScoreCalcMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ZScoreCalcMethod
tmp=get(hObject,'Value');
switch(tmp)
    case 2
        handles.SubTestData.ZScoreUseRawScore=1;
    case 3
        handles.SubTestData.ZScoreUseRawScore=0;

end %switch(tmp)
guidata(handles.Configuration,handles);


% --- Executes during object creation, after setting all properties.
function ZScoreCalcMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ZScoreCalcMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in ScoresFileBrowse.
function ScoresFileBrowse_Callback(hObject, eventdata, handles)
% hObject    handle to ScoresFileBrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FormatFile=which('SupOutputFormats.csv');

Filterspec=ReturnFileFilter(FormatFile);

[OutputFile, OutputPath] = uiputfile(Filterspec,'Please specify an output file.');
if((isnumeric(OutputFile)) &&(0==OutputFile))
else
    handles.SubTestData.ScoresFile=fullfile(OutputPath,OutputFile);
end

guidata(handles.Configuration,handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Internal functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [handles]=FetchSubTests(handles)

    choice=[handles.MediaType 'SubTests.csv'];
    filename=which(choice);

    fid=fopen(filename);
    temp = textscan(fid,'%s%s%u8',-1,'delimiter',',');
    fclose(fid);

        if((isempty(temp{1})) && (isempty(temp{2}))&& (isempty(temp{3})))
            %No subjective tests found for this type. So clear the listing.
            set(handles.Methodology,'String','No Options Available');
        else
            Listing=cell(size(temp{1}));
            Listing{end+1}=[];

            Listing(1)={'Select'};
            Listing(2:end,1)=temp{1};
            set(handles.Methodology,'String',Listing);
            %Reusing the variable Listing
            Listing(2:end,1)=temp{2};
            handles.SubTestData.AvailableSubTestMethods=Listing;

            handles.SubTestData.SubTestMethodTypes=temp{3};
        end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        

function [handles]= ResetMetricData(handles)

handles.MetricData.AvailableMetrics.name=[];
handles.MetricData.AvailableMetrics.identifier=[];
handles.MetricData.AvailableMetrics.isselected=[];

handles.MetricData.MetricsInSel=[];
handles.MetricData.MetricsUnSel=[];

handles.MetricData.SelectedMetrics.name=[];
handles.MetricData.SelectedMetrics.identifier=[];

handles.MetricData.RefFiles=[];
handles.MetricData.RefImageWidth=[];
handles.MetricData.RefImageHeight=[];
handles.MetricData.RefFormat=[];
handles.MetricData.RefFPS=[];

handles.MetricData.TestFiles=[];
handles.MetricData.TestImageWidth=[];
handles.MetricData.TestImageHeight=[];
handles.MetricData.TestFormat=[];
handles.MetricData.TestFPS=[];


handles.MetricData.OutputFilename=[];

guidata(handles.Configuration,handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [handles]=ResetCorrelationData(handles)

handles.CorrData.AvailableMetrics.name=[];
handles.CorrData.AvailableMetrics.identifier=[];
handles.CorrData.AvailableMetrics.isselected=[];

handles.CorrData.MetricsInSel=[];
handles.CorrData.MetricsUnSel=[];

handles.CorrData.SelectedMetrics.name=[];
handles.CorrData.SelectedMetrics.identifier=[];

handles.CorrData.MOSFilename=[];
handles.CorrData.ObjFilename=[];
handles.CorrData.OutputFilename=[];

handles.CorrData.SelectedCorrelations=zeros(1,5);

%set(handles.PearsonCorr,'Value',0);
%set(handles.SpearmanCorr,'Value',0);
%set(handles.ORCorr,'Value',0);
%set(handles.RMSECorr,'Value',0);
%set(handles.MAECorr,'Value',0);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [handles]= ResetTestGenData(handles)

handles.TestGenData.AvailableDistortions.name=[];
handles.TestGenData.AvailableDistortions.identifier=[];

handles.TestGenData.DistortionsInSel=[];
handles.TestGenData.DistortionsUnSel=[];

handles.TestGenData.SelectedDistortions.name={};
handles.TestGenData.SelectedDistortions.identifier=[];
handles.TestGenData.SelectedDistortions.Settings=[];

handles.TestGenData.TestFiles=[];
handles.TestGenData.TestImageWidth=[];
handles.TestGenData.TestImageHeight=[];
handles.TestGenData.TestFormat=[];
handles.TestGenData.TestFPS=[];

handles.TestGenData.GenPath=[];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [handles]= ResetSubTestData(handles)

%Variables related to subjective testing
handles.SubTestData.SelSubTestMethod=[];
handles.SubTestData.SelSubTestMethodNeedsRef=[];
handles.SubTestData.SessionType=[];
handles.SubTestData.AvailableSubTestMethods=[];
handles.SubTestData.SubTestMethodTypes=[];

handles.SubTestData.RefFiles=[];
handles.SubTestData.RefImageWidth=[];
handles.SubTestData.RefImageHeight=[];
handles.SubTestData.RefFormat=[];
handles.SubTestData.RefFPS=[];

handles.SubTestData.TestFiles=[];
handles.SubTestData.TestImageWidth=[];
handles.SubTestData.TestImageHeight=[];
handles.SubTestData.TestFormat=[];
handles.SubTestData.TestFPS=[];

handles.SubTestData.RawSubScoreFile=[];


%Variables related to Score calculations

handles.SubTestData.CalcMOS=0;
handles.SubTestData.CalcSTD=0;

handles.SubTestData.CalcDMOS=0;
handles.SubTestData.DMOSUseZScore=[];

handles.SubTestData.CalcZScores=0;
handles.SubTestData.ZScoresFile=[];
handles.SubTestData.ZScoreUseRawScore=[];

handles.SubTestData.ScoresFile=[];

%Update UI

 set(handles.Methodology,'value',1);
 set(handles.SessionType,'value',1);
 set(handles.CalcMOS,'value',0);
 set(handles.CalcSTD,'value',0);
 set(handles.CalcDMOS,'value',0);
 set(handles.DMOSCalcMethod,'value',1);
 set(handles.CalcZScores,'value',0);
 set(handles.ZScoreCalcMethod,'value',1);

 handles.SubTestData.RefIdx=[];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [handles]=TabElementsInit(handles,TabArrayIdx)

TabInitFn={'FetchSubTests'};
if(~isempty(TabInitFn{TabArrayIdx}))
   handles=feval(char(TabInitFn(TabArrayIdx)),handles);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [handles]=InitializeToolOptions(handles)

handles.ToolOptions=[];
handles.ToolOptions=DefaultOptions(handles.ToolOptions);
guidata(handles.Configuration,handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [handles]=InitializeFilePointers(handles)
handles.FilePointers.LogFile=-1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [handles]=UpdateSelections(handles,mode)
if((0~=isfield(handles.TestGenData,'DistortionsInSel') ) &&(~isempty(handles.TestGenData.DistortionsInSel)))
     %Some distortions have been selected
     Idx=handles.TestGenData.DistortionsInSel;
     temp=[];

    if(1==strcmp(mode,'default'))
        fname=['Default_' char(handles.TestGenData.AvailableDistortions.identifier(Idx))];
        try
            temp=feval(fname);
        catch RetErr
            errordlg('Adding with Defaults failed.','Unable to add with defaults.','modal');
        end

    elseif(1==strcmp(mode,'configure'))
        fname=['Configure_' char(handles.TestGenData.AvailableDistortions.identifier(Idx))];
        if(0~=handles.ToolOptions.DisplayGenImage)
            %Try to generate the distortions so far
            if((~isempty(handles.TestGenData.TestFiles)))
                %Atleast a file exists and some distortions have been selected
                LoggingParam.LogFn=@NoLogging;
                LoggingParam.LogFile=-1;

                [ConfigureParam.Buffer,OutputFileName]=GenerateDistortionsInImage(handles.TestGenData,LoggingParam,1,@NoDisp,[]);

            else
                ConfigureParam.Buffer=[];
            end
        else
            ConfigureParam.Buffer=[];
            
        end %if(0~=handles.ToolOptions.DisplayGenImage)
        
        ConfigureParam.Visibility='off';
        try
           temp=feval(fname,ConfigureParam);
        catch RetErr
            errordlg('Configure and Add failed.','Unable to configure and add filter.','modal');
        end
        
    end %if(1==strcmp(mode,'default'))

    if(~isempty(temp))
        %Something was returned.
        handles.TestGenData.SelectedDistortions.name{end+1}=handles.TestGenData.AvailableDistortions.name{Idx};
        handles.TestGenData.SelectedDistortions.identifier{end+1}=handles.TestGenData.AvailableDistortions.identifier{Idx};
        handles.TestGenData.SelectedDistortions.Settings{end+1}=temp;

        handles.TestGenData.DistortionsInSel=[];

        %Populate list of selected distortions
        handles=PopulateSelectedDistortions(handles);
        set(handles.AvailableDistortions,'Value',1);

    end

end %if((0~=isfield(handles.TestGenData,'DistortionsInSel') ) &&(~isempty(handles.TestGenData.DistortionsInSel)))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [handles]=PopulateAvailableDistortions(handles)
set(handles.AvailableDistortions,'String',handles.TestGenData.AvailableDistortions.name);
set(handles.AvailableDistortions,'Value',1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [handles]=PopulateSelectedDistortions(handles)
set(handles.SelectedDistortions,'String',handles.TestGenData.SelectedDistortions.name);
set(handles.SelectedDistortions,'Value',1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
