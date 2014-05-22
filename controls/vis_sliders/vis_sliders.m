function varargout = vis_sliders(varargin)
% VIS_SLIDERS MATLAB code for vis_sliders.fig
%      VIS_SLIDERS, by itself, creates a new VIS_SLIDERS or raises the existing
%      singleton*.
%
%      H = VIS_SLIDERS returns the handle to a new VIS_SLIDERS or the handle to
%      the existing singleton*.
%
%      VIS_SLIDERS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIS_SLIDERS.M with the given input arguments.
%
%      VIS_SLIDERS('Property','Value',...) creates a new VIS_SLIDERS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before vis_sliders_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to vis_sliders_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help vis_sliders

% Last Modified by GUIDE v2.5 07-May-2014 15:16:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @vis_sliders_OpeningFcn, ...
                   'gui_OutputFcn',  @vis_sliders_OutputFcn, ...
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


% --- Executes just before vis_sliders is made visible.
function vis_sliders_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to vis_sliders (see VARARGIN)

% Choose default command line output for vis_sliders

handles.output = hObject;
handles.sliderlh = addlistener(handles.robot_plate_height_control,'ContinuousValueChange',@doStuff);

%Standard Visualizer Core Functions
handles.ViscoreUpdate = @ViscoreUpdate;
handles.ViscoreShutdown = @ViscoreShutdown;
handles.corelistener = -1; % Uninitialized
handles.core = -1;
guidata(hObject, handles);
handles = viscore_connect(hObject);

% guidata(hObject, handles);
% results = findall(0,'Name','lram viscore');
% guifig = results(1);
% if (numel(results) > 0)
%     core = get(guifig,'UserData');
%     handles.core = core;
%     handles.corelistener = addlistener(core,'Update',@handles.ViscoreUpdate);
% end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes vis_sliders wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = vis_sliders_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function robot_plate_height_control_Callback(hObject, eventdata, handles)
% hObject    handle to robot_plate_height_control (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function robot_plate_height_control_CreateFcn(hObject, eventdata, handles)
% hObject    handle to robot_plate_height_control (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over robot_plate_height_control.
function robot_plate_height_control_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to robot_plate_height_control (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on robot_plate_height_control and none of its controls.
function robot_plate_height_control_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to robot_plate_height_control (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function ViscoreUpdate(hObject, eventdata)
    results = findall(0,'Name','vis_sliders');

    if (length(results)>0)
        fig = results(1);
        handles = guidata(fig);
        core = hObject;
        config = core.settings;
        set(handles.robot_plate_height_control,'Value',-config.plate_height);
        guidata(fig, handles);
    end

function doStuff(hObject, eventdata)
        fig = get(hObject,'Parent');
        handles = guidata(fig);
        plate_height = -get(handles.robot_plate_height_control,'Value');    
        handles.core.settings.plate_height = plate_height;
        notify(handles.core,'Update');
        guidata(fig,handles);
    
function ViscoreShutdown(hObject, eventdata)
    results = findobj(0,'Name','vis_sliders');
    fig = results(1);
    delete(fig);
