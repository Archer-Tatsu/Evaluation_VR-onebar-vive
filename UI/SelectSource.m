%=====================================================================
% File: SelectSource.m
%=====================================================================
function varargout = SelectSource(varargin)
% SELECTSOURCE M-file for SelectSource.fig
%      SELECTSOURCE, by itself, creates a new SELECTSOURCE or raises the
%      existing
%      singleton*.
%
%      H = SELECTSOURCE returns the handle to a new SELECTSOURCE or the handle to
%      the existing singleton*.
%
%      SELECTSOURCE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SELECTSOURCE.M with the given input arguments.
%
%      SELECTSOURCE('Property','Value',...) creates a new SELECTSOURCE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SelectSource_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SelectSource_OpeningFcn via
%      varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help SelectSource

% Last Modified by GUIDE v2.5 14-Oct-2009 17:40:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SelectSource_OpeningFcn, ...
                   'gui_OutputFcn',  @SelectSource_OutputFcn, ...
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


% --- Executes just before SelectSource is made visible.
function SelectSource_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SelectSource (see VARARGIN)

%Use the input argument to determine whether it is video or image
handles.DirData.MediaType=char(varargin{1});

% Choose default command line output for SelectSource
handles.output = [];

%No file filter to be applied
handles.FileFilterToApply=1;

handles=ResetDirData(handles);

UpdateDir(handles,'.');

% Make the GUI modal
set(handles.SelectSource,'WindowStyle','modal')

% UIWAIT makes SelectSource wait for user response (see UIRESUME)
uiwait(handles.SelectSource);


% --- Outputs from this function are returned to the command line.
function varargout = SelectSource_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% if((isfield(handles.DirData,'SelectedList')) )
%     handles.output=handles.DirData.SelectedList;
% else
%     handles.output=[];
% end
varargout{1} = handles.output;
%If the filelist has to be saved it must be saved now.

% The figure can be deleted now
delete(handles.SelectSource);



% --- Executes when user attempts to close SelectSource.
function SelectSource_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to SelectSource (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isequal(get(handles.SelectSource, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    handles.DirData.SelectedList=[];
    handles.output=[];
    guidata(handles.SelectSource,handles);
    uiresume(handles.SelectSource);
else
    % The GUI is no longer waiting, just close it
    delete(handles.SelectSource);
end



% --- Executes on key press over SelectSource with no controls selected.
function SelectSource_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to SelectSource (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Check for "enter" or "escape"
if isequal(get(hObject,'CurrentKey'),'escape')
    % User said no by hitting escape
    handles.DirData.SelectedList=[];
    handles.output=[];


    % Update handles structure
    guidata(handles.SelectSource,handles);

    uiresume(handles.SelectSource);
end

if isequal(get(hObject,'CurrentKey'),'return')
    try
        handles.output=CheckIfDone(handles);
    catch RetErr
          errordlg(RetErr.message);
        return;
    end
    guidata(handles.SelectSource,handles);
    uiresume(handles.SelectSource);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Path setting callbacks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function CurrPath_Callback(hObject, eventdata, handles)
% hObject    handle to CurrPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CurrPath as text
%        str2double(get(hObject,'String')) returns contents of CurrPath as a double

%Check if the string that has been entered is different from the one that
%is the currently path.
EnteredString=get(hObject,'String');
if(0==strcmpi(EnteredString,handles.DirData.CurrPath))
    %Strings are different.

    %Validate the EnteredString to see if it is a valid path
    if(exist(EnteredString,'dir'))
        %It is a valid dir.
        UpdateDir(handles,EnteredString)

    end %if(exist(EnteredString,'dir'))

end %if(0==strcmpi(EnteredString,handles.DirData.CurrPath))



% --- Executes during object creation, after setting all properties.
function CurrPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CurrPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in Browse.
function Browse_Callback(hObject, eventdata, handles)
% hObject    handle to Browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UpdateDir(handles,uigetdir());

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Directory listing callbacks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on selection change in DirList.
function DirList_Callback(hObject, eventdata, handles)
% hObject    handle to DirList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns DirList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DirList

%Set current path to selected dir

UpdateDir(handles,handles.DirData.DirList{get(hObject,'Value')})


% --- Executes during object creation, after setting all properties.
function DirList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DirList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File listing callbacks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on selection change in FileList.
function FileList_Callback(hObject, eventdata, handles)
% hObject    handle to FileList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns FileList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FileList

%TODO: Clicking selects the file
handles.DirData.FilesSelInDir=get(hObject,'Value');
guidata(handles.SelectSource,handles);



% --- Executes during object creation, after setting all properties.
function FileList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FileList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Selected files callbacks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on selection change in SelectedFiles.
function SelectedFiles_Callback(hObject, eventdata, handles)
% hObject    handle to SelectedFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns SelectedFiles contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SelectedFiles

%TODO Clicking on a choice should unselect the file

handles.DirData.UnSelected=get(hObject,'Value');
guidata(handles.SelectSource,handles);


% --- Executes during object creation, after setting all properties.
function SelectedFiles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SelectedFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File filter callbacks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on selection change in FileFilter.
function FileFilter_Callback(hObject, eventdata, handles)
% hObject    handle to FileFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns FileFilter contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FileFilter
handles.FileFilterToApply=get(hObject,'Value');
UpdateDir(handles,'.');


% --- Executes during object creation, after setting all properties.
function FileFilter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FileFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Selection manipulation callbacks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in AddTree.
function AddTree_Callback(hObject, eventdata, handles)
% hObject    handle to AddTree (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
p=genpath(handles.DirData.CurrPath);

Tok=ExtractDir_SubDir(p);

[SupportedMFormats]=ReturnSupportMediaFormats(handles);

%TODO: read this from SupTFormats.csv
AvailableTFormats={'.xls','.xlsx','.txt','.csv'};

if('I'==handles.DirData.MediaType)
    HandlerSuffix='Read_';
else
    HandlerSuffix='GetFrames_';
end

FilesInDir={};
NumOfSubDir=numel(Tok);
for i=1:NumOfSubDir
        TempDir=dir(Tok{i});
    FilesInDir=GenFileList(handles,TempDir,Tok{i});
    NumOfFiles=numel(FilesInDir);
    if(isfield(handles.DirData,'SelectedList'))
        %Some selections have already been made. Append to the list.
        SizeOfSelectedList=size(handles.DirData.SelectedList);
        LastElement=SizeOfSelectedList(1,2);
    else
    LastElement=0;
    end

    for j=1:NumOfFiles
        [dummy1,dummy2,ext]=fileparts(FilesInDir{j});
        switch(lower(ext))
            case AvailableTFormats
                handles.DirData.NumListFiles=handles.DirData.NumListFiles+1;
            case SupportedMFormats
                handles.DirData.NumMediaFiles=handles.DirData.NumMediaFiles+1;
            otherwise
                %Check if there is a handler for this extension

                    fname=[HandlerSuffix ext(2:end) '.m'];
                    if(2==exist(fname,'file'))
                        %Assume that it is an image file
                        handles.DirData.NumMediaFiles=handles.DirData.NumMediaFiles+1;
                    else
                        errordlg('Unsupported files in tree.','Unsupported files','modal');
                        return;
                    end
        end %switch(lower(ext))

        handles.DirData.SelectedList{LastElement+j}=fullfile(Tok{i},FilesInDir{j});

    end %for j=1:NumOfFiles

end %for i=1:NumOfSubDir

%Update the directory listting
set(handles.SelectedFiles,'String',handles.DirData.SelectedList);
guidata(handles.SelectSource,handles);

% --- Executes on button press in AddSel.
function AddSel_Callback(hObject, eventdata, handles)
% hObject    handle to AddSel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if(0~=isfield(handles.DirData,'FilesSelInDir') )
    %The field has been created. This means that some files were selected.
    NumOfSelFiles=length(handles.DirData.FilesSelInDir);

    if(0==NumOfSelFiles)
        %Do Nothing
    else
        if(isfield(handles.DirData,'SelectedList'))
            %Some selections have already been made. Append to the list.
            SizeOfSelectedList=size(handles.DirData.SelectedList);
            LastElement=SizeOfSelectedList(1,2);
        else
            LastElement=0;
        end

        [SupportedMFormats]=ReturnSupportMediaFormats(handles);

        %TODO: read this from SupTFormats.csv
        AvailableTFormats={'.xls','.xlsx','.txt','.csv'};

        if('I'==handles.DirData.MediaType)
            HandlerSuffix='Read_';
        else
            HandlerSuffix='GetFrames_';
        end


        for i=1:NumOfSelFiles
            [dummy1,dummy2,ext]=fileparts(handles.DirData.FileList{handles.DirData.FilesSelInDir(i)});
            switch(lower(ext))
            case AvailableTFormats
                handles.DirData.NumListFiles=handles.DirData.NumListFiles+1;
            case SupportedMFormats
                handles.DirData.NumMediaFiles=handles.DirData.NumMediaFiles+1;

            otherwise
                %Check if there is a handler for this extension

                    fname=[HandlerSuffix ext(2:end) '.m'];
                    if(2==exist(fname,'file'))
                        %Assume that it is an image file
                        handles.DirData.NumMediaFiles=handles.DirData.NumMediaFiles+1;
                    else
                        errordlg('Unsupported files in selection.','Unsupported files','modal');
                        return;
                    end
            end %switch(lower(ext))

            handles.DirData.SelectedList{LastElement+i}=fullfile(handles.DirData.CurrPath,handles.DirData.FileList{handles.DirData.FilesSelInDir(i)});

        end %for i=1:NumOfSelFiles

        %Update the directory listting
        set(handles.SelectedFiles,'String',handles.DirData.SelectedList);
        guidata(handles.SelectSource,handles);
    end

end %if(0~=isfield(handles.DirData,'FilesSelInDir') )


% --- Executes on button press in RemoveSel.
function RemoveSel_Callback(hObject, eventdata, handles)
% hObject    handle to RemoveSel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(0~=isfield(handles.DirData,'UnSelected'))
    %The field has been created. This means that some files were selected.
    NumOfUnSelFiles=length(handles.DirData.UnSelected);

    if(0~=isfield(handles.DirData,'SelectedList'))

        [SupportedMFormats]=ReturnSupportMediaFormats(handles);

        AvailableTFormats={'.xls','.xlsx','.txt','.csv'};

        if('I'==handles.DirData.MediaType)
            HandlerSuffix='Read_';
        else
            HandlerSuffix='GetFrames_';
        end

        for i=1:NumOfUnSelFiles
            [dummy1,dummy2,ext]=fileparts(char(handles.DirData.SelectedList(handles.DirData.UnSelected(i))));
            switch(lower(ext))
                case AvailableTFormats
                    handles.DirData.NumListFiles=handles.DirData.NumListFiles-1;
                case SupportedMFormats
                    handles.DirData.NumMediaFiles=handles.DirData.NumMediaFiles-1;

                otherwise
                    %Check if there is a handler for this extension

                        fname=[HandlerSuffix ext(2:end) '.m'];
                        if(2==exist(fname,'file'))
                            %Assume that it is an image file
                            handles.DirData.NumMediaFiles=handles.DirData.NumMediaFiles-1;
                        else
                            errordlg('Unsupported files in selection.','Unsupported files','modal');
                            return;
                        end
            end %switch(lower(ext))

        end %for i=1:NumOfUnSelFiles

        handles.DirData.SelectedList(handles.DirData.UnSelected)=[];

        handles.DirData.UnSelected=[];
        %Update the listting
        set(handles.SelectedFiles,'String',handles.DirData.SelectedList);
        
    end %if(0~=isfield(handles.DirData,'SelectedList'))

    set(handles.SelectedFiles,'Value',[]);

    guidata(handles.SelectSource,handles);


end %if(0~=isfield(handles.DirData,'UnSelected'))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File list saving callbacks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in SaveFileList.
function SaveFileList_Callback(hObject, eventdata, handles)
% hObject    handle to SaveFileList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SaveFileList
handles.DirData.SaveFileList=get(hObject,'Value');
if(0==handles.DirData.SaveFileList)
    set(handles.FileListOutputFile,'Enable','off');
    set(handles.FileListBrowse,'Enable','off');
else
    set(handles.FileListOutputFile,'Enable','on');
    set(handles.FileListBrowse,'Enable','on');
end
guidata(handles.SelectSource,handles);



function FileListOutputFile_Callback(hObject, eventdata, handles)
% hObject    handle to FileListOutputFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FileListOutputFile as text
%        str2double(get(hObject,'String')) returns contents of FileListOutputFile as a double
EnteredString=get(hObject,'String');

%Validate the EnteredString to see if it is a valid file

    %It is a valid file
    handles.DirData.OutputFilename=EnteredString;
    set(handles.FileListOutputFile,'String',handles.DirData.OutputFilename);
    guidata(handles.SelectSource,handles);

% --- Executes during object creation, after setting all properties.
function FileListOutputFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FileListOutputFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in FileListBrowse.
function FileListBrowse_Callback(hObject, eventdata, handles)
% hObject    handle to FileListBrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FormatFile=which('SupOutputFormats.csv');

Filterspec=ReturnFileFilter(FormatFile);

[OutputFile, OutputPath] = uiputfile(Filterspec,'Please specify an output file.');
if((isnumeric(OutputFile)) &&(0==OutputFile))
else
     handles.DirData.OutputFilename=fullfile(OutputPath,OutputFile);

     %Update display as well
     set(handles.FileListOutputFile,'String',handles.DirData.OutputFilename);
end

guidata(handles.SelectSource,handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% UI control callbacks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in Done.
function Done_Callback(hObject, eventdata, handles)
% hObject    handle to Done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


try
    handles.output=CheckIfDone(handles);
catch RetErr
      errordlg(RetErr.message);
    return;
end
guidata(handles.SelectSource,handles);
uiresume(handles.SelectSource);


% --- Executes on button press in Help.
function Help_Callback(hObject, eventdata, handles)
% hObject    handle to Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
HelpPath=which('help.html');
HelpTag=[HelpPath '#4-add-files'];
web(HelpTag,'-browser');

% --- Executes on button press in Cancel.
function Cancel_Callback(hObject, eventdata, handles)
% hObject    handle to Cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.DirData.SelectedList=[];
handles.output=[];
guidata(handles.SelectSource,handles);
uiresume(handles.SelectSource);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Non MATLAB created functions, i.e., internal functions that are used by
% the callbacks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [SupportedMFormats]=ReturnSupportMediaFormats(handles)
FormatFileName=['Sup' handles.DirData.MediaType 'Formats.csv'];
FormatFile = which(FormatFileName);

SupportedFormats=ExtractExtensions(FormatFile);
NumOfSupFormats=length(SupportedFormats);

for i=1:NumOfSupFormats
    temp=SupportedFormats{i};

    if(('*'==temp(1)) )
        %Extension already has the *.
        ext=temp(2:end);
    else
        ext=temp;
    end
        SupportedFormats{i}=ext;

end
SupportedMFormats=SupportedFormats;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [handles]=ResetDirData(handles)

handles.DirData.UnSelected=[];
handles.DirData.WorkingDir=pwd;
handles.DirData.CurrPath=pwd;
handles.DirData.ImageWidth=[];
handles.DirData.ImageHeight=[];
handles.DirData.FPS=[];
handles.DirData.YUVFormat=[];
handles.DirData.SaveFileList=0;
handles.DirData.OutputFilename=[];
handles.DirData.NumMediaFiles=0;
handles.DirData.NumListFiles=0;
handles.DirData.RawFileLocations=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function []=PopulatePwd(handles)
    set(handles.CurrPath,'String',handles.DirData.CurrPath);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function []= PopulateDir(handles)
    %Get current directory listing
    set(handles.DirList,'String',handles.DirData.DirList);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function []= PopulateFiles(handles)
    %Get current files listing
    set(handles.FileList,'String',handles.DirData.FileList);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function UpdateDir(handles,EnteredString)
    %Invalidate the current file selections
    handles.DirData.FilesSelInDir=[];
    handles.DirData.FileList=[];


    %Must update path
    TempPath=handles.DirData.CurrPath;
    cd(TempPath);
    cd(EnteredString);
    handles.DirData.CurrPath=cd;

    %Restore to working directory
    cd(handles.DirData.WorkingDir);

    TempDir=dir(handles.DirData.CurrPath);

    DirIdx=find([TempDir.isdir]);
    NumOfDir=length(DirIdx);

    handles.DirData.DirList=[];
    for i=1:NumOfDir
        handles.DirData.DirList{i}=TempDir(DirIdx(i)).name;
    end

    handles.DirData.FileList=GenFileList(handles,TempDir,handles.DirData.CurrPath);

    %Updating display elements
    PopulatePwd(handles);

    PopulateDir(handles);
    PopulateFiles(handles);
    guidata(handles.SelectSource,handles);

    %Sanity check: Matlab uses the Value to highlight the selected option. Now
    %we will have problems if the number of elements in the repopulated dir
    %listing is less than Value. Hence, force Value to 1 so that the first item
    %in the list is always selected.
    %
    %Note: Dir listing will always be atleast 2:
    %       . Current directory
    %       .. Back to parent

    set(handles.DirList,'Value',1);
    set(handles.FileList,'Value',[]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Tok]=ExtractExtensions(FormatFile)
fid = fopen(FormatFile,'r');
ExtList={};

while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    [dummy1,r]=strtok(tline,',');

    ExtList{end+1}=r(2:end);

end
fclose(fid);
SupExtensions = regexprep(ExtList, ',', ';');

%Extract the extensions

[Tok,Remainder] = strtok(SupExtensions,';');
%Since SupExtensions is a cell array, Tok and Remainder are arrays as well

%Find out the line that has more than one extension.

for i=1:numel(ExtList)
   if(isempty(Remainder{i}))
        %Single extension for this type
   else
       while(~isempty(Remainder{i}))
           [Tok{end+1},NewRem] = strtok(Remainder{i},';');
            Remainder{i}=NewRem;
       end
   end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Output]=CheckIfDone(handles)
Output=[];
if((isfield(handles.DirData,'SelectedList')))
    %Check the extensions of SelectedList
    NumOfSelections=numel(handles.DirData.SelectedList);
    if(0==NumOfSelections)
        error('Please Select a file.','No File specified','modal');
    end
    bCheckYUVOptions=0;
    bCheckYOptions=0;
    counter=0;

    if((handles.DirData.NumListFiles>0) && ...
       ((~isempty(find(handles.DirData.RawFileLocations, 1)) ) || (handles.DirData.NumMediaFiles > 0))...
      )

        error('List files (Excel, csv etc.) cannot be combined with image or raw files in the selection.','Mixed File types selected','modal');
    end

    if((1==handles.DirData.SaveFileList) && ...
       ((handles.DirData.NumListFiles > 0))...
      )
        error('File list cannot be saved into a file when the listing contains non image files.','Filelist save not possible','modal');
    end

    if((1==handles.DirData.SaveFileList) && isempty(handles.DirData.OutputFilename))
        error('Output file has not been specified','No output file specified','modal');
    end

    if((handles.DirData.NumListFiles>0) )
        TabulatedValuesFileList=handles.DirData.SelectedList;
        handles.DirData.SelectedList=[];
        %Read  each file and generate a file list from the first column.
        for i=1:handles.DirData.NumListFiles
            [num,txt]=ReadTabulatedValues(TabulatedValuesFileList{i});

            %Read first column
            %Check if first cell has a heading

            [dummy1,HeaderPresent,ib]=intersect(lower(txt(1,:)),{'filename','image name','test files','reference files','file name'});
            if(isempty(HeaderPresent))
                filelist=txt(:,1);
            else
                filelist=txt(2:end,1);
            end

            %TODO: Replace with regexpi
            [dummy1,YUVFormatColIdx,ib]=intersect(lower(txt(1,:)),{'yuv','yuv format','yuvformat'});

            [tmp]=regexpi(lower(txt(1,:)),'width');
            if(isempty(tmp))
                WidthColIdx=[];
            else
                WidthColIdx=find(~cellfun('isempty',tmp));
            end

            [tmp]=regexpi(lower(txt(1,:)),'height');
            if(isempty(tmp))
                HeightColIdx=[];
            else
                HeightColIdx=find(~cellfun('isempty',tmp));
            end

            [dummy1,FrameRateColIdx,ib]=intersect(lower(txt(1,:)),{'frame rate','fps','framerate','rate'});

            %Analyze if any numbers (width, height) were specified

            [r,c]=size(num);

            NumOfFilesInList=length(filelist);

            if(r==NumOfFilesInList)
                NumRowIdxSelect=1;
            else
                NumRowIdxSelect=2;
            end

            [SupportedMFormats]=ReturnSupportMediaFormats(handles);
            
            %TODO: Read this from SupTFormats.csv
            AvailableTFormats={'.xls','.xlsx','.txt','.csv'};

            if('I'==handles.DirData.MediaType)
                HandlerSuffix='Read_';
            else
                HandlerSuffix='GetFrames_';
            end

            %Validate
            k=1;
            NumRowIdx=zeros(2,1);
            for j=1:NumOfFilesInList

                if(2==exist(char(filelist(j)),'file'))
                    [fpath,~,~]=fileparts(char(filelist(j)));
                    if(~isempty(fpath))
                        %File listing contains full path
                        tmp=char(filelist(j));
                    else
                        %file listing does not contain path. Generate the path
                        tmp=which(char(filelist(j)));
                        if(isempty(tmp))
                            %file not found and path not specified.
                            error('Could not find files specified in the list. Please specify the path in the list or move the files into your workspace','Files not found','modal');

                        end
                    end
                    %Copy to final placeholder
                    
                   %{
                        switch (lower(ext))
                            case AvailableTFormats
                                handles.DirData.NumListFiles=handles.DirData.NumListFiles+1;
                            case SupportedMFormats
                                handles.DirData.NumMediaFiles=handles.DirData.NumMediaFiles+1;

                                if(~isempty(YUVFormatColIdx))
                                    YUVFormat=txt(j+1,YUVFormatColIdx);

                                    switch lower(char(YUVFormat))
                                        case {'yuv444planar'}
                                            handles.DirData.YUVFormat='YUV444Planar';
                                        case {'yuv422planar'}
                                            handles.DirData.YUVFormat='YUV422Planar';
                                        case {'yuv420planar'}
                                            handles.DirData.YUVFormat='YUV420Planar';
                                        case {'uyvy'}
                                            handles.DirData.YUVFormat='UYVY';
                                        case {'y'}
                                            handles.DirData.YUVFormat='Y';
                                        otherwise
                                            error('Could not identify the column with the YUV subsampling information.','Error reading YUV format info','modal');
                                            
                                    end %switch lower(char(YUVFormat))
                                    
                                else
                                    error('Could not identify the column with the YUV subsampling information.','Error reading YUV format info','modal');

                                end %if(~isempty(YUVFormatColIdx))

                                cellmap=cellfun('isempty',txt);

                                NumRowIdx(1)=j;
                                NumRowIdx(2)=k;


                                if(~isempty(WidthColIdx))

                                    Idx=find(find(cellmap(j+1,:))==WidthColIdx);

                                    try
                                        handles.DirData.ImageWidth=num(NumRowIdx(NumRowIdxSelect),Idx);
                                    catch RetErr
                                        error('Could not find the width of the YUV frame.','Width not specified','modal');
                                    end
                                else
                                    error('Could not identify the column containing the width of the YUV frame.','Width not specified','modal');
                                    
                                end %if(~isempty(WidthColIdx))

                                 if(~isempty(HeightColIdx))

                                    Idx=find(find(cellmap(j+1,:))==HeightColIdx);
                                    try
                                        handles.DirData.ImageHeight=num(NumRowIdx(NumRowIdxSelect),Idx);
                                    catch RetErr
                                        error('Could not find the height of the YUV frame.','Height not specified','modal');
                                    end
                                else
                                    error('Could not identify the column containing the height of the YUV frame.','Height not specified','modal');
                                    
                                 end %if(~isempty(HeightColIdx))


                                if((~isempty(FrameRateColIdx) ) && (1~=strcmp('I',handles.DirData.MediaType)))

                                    Idx=find(find(cellmap(j+1,:))==FrameRateColIdx);

                                    try
                                        handles.DirData.FPS=num(NumRowIdx(NumRowIdxSelect),Idx);
                                    catch RetErr
                                        error('Could not find the height of the YUV frame.','Height not specified','modal');
                                    end
                                elseif((isempty(FrameRateColIdx) ) && (1~=strcmp('I',handles.DirData.MediaType)))
                                    error('Could not identify the column containing the framerate.','Framerate not specified','modal');

                                end %if((~isempty(FrameRateColIdx) ) && (1~=strcmp('I',handles.DirData.MediaType)))
                                k=k+1;

                            otherwise
                                %Check if there is a handler for this extension

                                    fname=[HandlerSuffix ext(2:end) '.m'];
                                    if(2==exist(fname,'file'))
                                        %Assume that it is an image file
                                        handles.DirData.NumMediaFiles=handles.DirData.NumMediaFiles+1;
                                    else
                                        error('Unsupported files in tree.','Unsupported files','modal');

                                    end
                        end %switch(lower(ext))
                        %}
                    handles.DirData.SelectedList{end+1}=tmp;
                else
                    %Skip file
                end
            end %for j=1:length(filelist)

        end %for i=1:handles.DirData.NumListFiles

    end %if((handles.DirData.NumListFiles>0) )


    if(~isempty(find(handles.DirData.RawFileLocations, 1)) )
        %Check if format has been  selected.
        if((~isfield(handles.DirData,'YUVFormat')) ||(isempty(handles.DirData.YUVFormat)) )
            %Error
            error('Please select a YUV format to interpret the YUV files. Note that the format will be applied to ALL the selected YUV files.','No format specified','modal');

        end
    end

    if(~isempty(find(handles.DirData.RawFileLocations, 1)) )

        %Check if Width and height have been set
        if(  (isfield(handles.DirData,'ImageWidth')) && (~isempty(handles.DirData.ImageWidth)) && (0~=handles.DirData.ImageWidth) )
        else
            %Error
            error('Please specify the width of the raw files','No Width specified','modal');

        end
        if(  (isfield(handles.DirData,'ImageHeight')) && (~isempty(handles.DirData.ImageHeight)) && (0~=handles.DirData.ImageHeight) )
        else
            %Error
            error('Please specify the height of the raw files','No Height specified','modal');

        end
        if(  (isfield(handles.DirData,'FPS')) && (~isempty(handles.DirData.FPS)) && (0~=handles.DirData.FPS) )
        else
            if(1==strcmp('I',handles.DirData.MediaType))
            else
               error('Please specify the frame rate of the raw files','No frame rate specified','modal');
            end

        end

        % No errors.
        Output.Width=handles.DirData.ImageWidth;
        Output.Height=handles.DirData.ImageHeight;
        Output.Format=handles.DirData.YUVFormat;
        Output.FPS=handles.DirData.FPS;
    else
        Output.Width=[];
        Output.Height=[];
        Output.Format=[];
        Output.FPS=[];

    end


    Output.Files=handles.DirData.SelectedList;

    if(1==handles.DirData.SaveFileList)
        [dummy1,dummy2,ext]=fileparts(handles.DirData.OutputFilename);
        tmp=lower(ext(2:end));

        if(~isempty(find(handles.DirData.RawFileLocations, 1)) )

            CellArrayWidth=4+strcmp('V',handles.DirData.MediaType);
        else
            CellArrayWidth=1;
        end

        OutputArray=cell(length(handles.DirData.SelectedList)+1,CellArrayWidth);
        OutputArray(1,1)={'File name'};
        OutputArray(2:end,1)=handles.DirData.SelectedList;

        if(~isempty(find(handles.DirData.RawFileLocations, 1)) )

            RawLocations=find(handles.DirData.RawFileLocations);
            %TODO: We can copy individual widths and heights instead of a
            %common width and height when the interface for associating
            %individual widths and heights with YUV files becomes
            %available.
            OutputArray(1,2)={'yuv format'};
            OutputArray(RawLocations+1,2)={handles.DirData.YUVFormat};
            OutputArray(1,3)={'Width'};
            OutputArray(RawLocations+1,3)=num2cell(handles.DirData.ImageWidth);
            OutputArray(1,4)={'Height'};
            OutputArray(RawLocations+1,4)=num2cell(handles.DirData.ImageHeight);
            if(1==strcmp('V',handles.DirData.MediaType))
                OutputArray(1,5)={'Framerate'};
                OutputArray(RawLocations+1,5)=num2cell(handles.DirData.FPS);
            end
            
        end %if(~isempty(find(handles.DirData.RawFileLocations, 1)) )
        
        switch tmp

            case {'xls','xlsx'}
                xlswrite(handles.DirData.OutputFilename,OutputArray);
            case {'csv','txt'}
                  fid=fopen(handles.DirData.OutputFilename,'w');
                  if(-1==fid)
                        error('Could not open file for writing','Could not open file','modal');
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
                  end

            otherwise
                  error('Unsupported output file format.','Unsupported file format','modal');

        end %switch tmp
        
    end %if(1==handles.DirData.SaveFileList)


else
    Output=[];
    error('Please Select a file.','No File specified','modal');

end %if((isfield(handles.DirData,'SelectedList')))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [FileList]=GenFileList(handles,TempDir,CurrDir)
    FileList={};
    switch(handles.FileFilterToApply)
        case 1
            %No filter
            FilesIdx=find(~[TempDir.isdir]);
            NumOfFiles=length(FilesIdx);

            for i=1:NumOfFiles
                FileList{i}=TempDir(FilesIdx(i)).name;

            end
        case 2
            %Image files only

            FormatFile = which('SupIFormats.csv');


            SupportedFormats=ExtractExtensions(FormatFile);
            NumOfSupFormats=length(SupportedFormats);

            cd(CurrDir);

            for i=1:NumOfSupFormats
                temp=SupportedFormats{i};

                if(('*'==temp(1)) )
                    %Extension already has the *.
                    ext=temp;
                else
                    ext=['*.' temp];
                end

                tdir=dir(ext);

                if(0==isempty(tdir))
                    %This extension was found.

                    SizeOftdir=size(tdir);
                    NumOfFiles=SizeOftdir(1,1);

                    for j=1:NumOfFiles
                        FileList{end+1}=tdir(j).name;
                    end

                end %if(0==isempty(tdir))
                
            end %for i=1:NumOfSupFormats
            
            %Restore to working directory

            cd(handles.DirData.WorkingDir);

        case 3
            %txt, csv and Excel files only

            FormatFile = which('SupTFormats.csv');

            SupportedFormats=ExtractExtensions(FormatFile);
            NumOfSupFormats=length(SupportedFormats);

            cd(CurrDir);

            for i=1:NumOfSupFormats
                temp=SupportedFormats{i};

                if(('*'==temp(1)) )
                    %Extension already has the *.
                    ext=temp;
                else
                    ext=['*.' temp];
                end
                tdir=dir(ext);
                if(0==isempty(tdir))
                    %This extension was found.

                    SizeOftdir=size(tdir);
                    NumOfFiles=SizeOftdir(1,1);

                    for j=1:NumOfFiles
                       FileList{end+1}=tdir(j).name;
                    end

                end %if(0==isempty(tdir))
                
            end %for i=1:NumOfSupFormats
            
            %Restore to working directory

            cd(handles.DirData.WorkingDir);

    end %switch(handles.FileFilterToApply)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
