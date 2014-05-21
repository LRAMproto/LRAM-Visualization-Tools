function varargout = vis_control(varargin)
% VIS_CONTROL MATLAB code for vis_control.fig
%      VIS_CONTROL, by itself, creates a new VIS_CONTROL or raises the existing
%      singleton*.
%
%      H = VIS_CONTROL returns the handle to a new VIS_CONTROL or the handle to
%      the existing singleton*.
%
%      VIS_CONTROL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIS_CONTROL.M with the given input arguments.
%
%      VIS_CONTROL('Property','Value',...) creates a new VIS_CONTROL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before vis_control_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to vis_control_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help vis_control

% Last Modified by GUIDE v2.5 23-Apr-2014 15:12:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @vis_control_OpeningFcn, ...
                   'gui_OutputFcn',  @vis_control_OutputFcn, ...
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


% --- Executes just before vis_control is made visible.
function vis_control_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to vis_control (see VARARGIN)

% Choose default command line output for vis_control
handles.output = hObject;
handles.displays = findall(0,'Name','white_background');

% This is the configuration file. An option should be added to the
% visualizer to load the file from the GUI.

handles.eventUpdate = @eventUpdate;

results = findall(0,'Name','lram viscore');
guifig = results(1);
if (numel(results) > 0)
    core = get(guifig,'UserData');
    handles.core = core;
    handles.corelistener = addlistener(core,'Update',@handles.eventUpdate);
end

% Update handles structure
guidata(hObject, handles);

notify(core,'Update');

% UIWAIT makes vis_control wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%spot_color_menu_Callback(handles.spot_color_menu, eventdata, handles);

% --- Outputs from this function are returned to the command line.
function varargout = vis_control_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in spot_color_menu.
function spot_color_menu_Callback(hObject, eventdata, handles)
% hObject    handle to spot_color_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns spot_color_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from spot_color_menu
options = containers.Map({1 2},{'Hatton Red','OSU Orange'});
color_opts = containers.Map(...
    {'Hatton Red','OSU Orange'},...
    {[234 14 30]/255,[195 69 0]/255}...
    );

opt = get(hObject, 'Value');
disp(opt);
set(handles.spot_color_display,'Color',color_opts(options(opt)));

results = findall(0,'Name','vis_gui');
if (numel(results)>0)
    % If no display window is present, nothing needs to
    % happen.
    
    guifig = results(1);
    guihandles = guidata(guifig);
    guihandles.setSpotColor(guihandles,color_opts(options(opt)));
    guidata(guifig, guihandles);
end


% --- Executes during object creation, after setting all properties.
function spot_color_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spot_color_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function robot_plate_height_edit_Callback(hObject, eventdata, handles)
% hObject    handle to robot_plate_height_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of robot_plate_height_edit as text
%        str2double(get(hObject,'String')) returns contents of robot_plate_height_edit as a double

handles.core.settings.plate_height = str2double(get(hObject,'String'));
notify(handles.core,'Update');

% --- Executes during object creation, after setting all properties.
function robot_plate_height_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to robot_plate_height_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function target_plate_height_edit_Callback(hObject, eventdata, handles)
% hObject    handle to target_plate_height_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of target_plate_height_edit as text
%        str2double(get(hObject,'String')) returns contents of target_plate_height_edit as a double


% --- Executes during object creation, after setting all properties.
function target_plate_height_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to target_plate_height_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function eventUpdate(hObject, eventdata)
    results = findall(0,'Name','vis_control');

    if (length(results)>0)
        fig = results(1);
        handles = guidata(fig);
        core = hObject;
        config = core.settings;
        set(handles.robot_plate_height_edit,'String',num2str(config.plate_height));
        set(handles.target_plate_height_edit,'String',num2str(config.target_height));
        guidata(fig, handles);
    end

function doStuff(hObject, eventdata)
        fig = get(hObject,'Parent');
        handles = guidata(fig);
        plate_height = -get(handles.robot_plate_height_control,'Value');    
        handles.core.settings.plate_height = plate_height;
        notify(handles.core,'Update');
        guidata(fig,handles);
