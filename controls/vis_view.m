function varargout = vis_view(varargin)
% VIS_VIEW MATLAB code for vis_view.fig
%      VIS_VIEW, by itself, creates a new VIS_VIEW or raises the existing
%      singleton*.
%
%      H = VIS_VIEW returns the handle to a new VIS_VIEW or the handle to
%      the existing singleton*.
%
%      VIS_VIEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIS_VIEW.M with the given input arguments.
%
%      VIS_VIEW('Property','Value',...) creates a new VIS_VIEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before vis_view_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to vis_view_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help vis_view

% Last Modified by GUIDE v2.5 25-Apr-2014 17:55:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @vis_view_OpeningFcn, ...
                   'gui_OutputFcn',  @vis_view_OutputFcn, ...
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


% --- Executes just before vis_view is made visible.
function vis_view_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to vis_view (see VARARGIN)

% Choose default command line output for vis_view
handles.output = hObject;
handles.listening = 0;
handles.doStuff = @doStuff;
handles.eventlistener = 0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes vis_view wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = vis_view_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function doStuff(block, eventdata)
% disp(block.Dwork(1).Data);
results = findall(0,'Name','vis_view');

for idx = 1:numel(results)
    fig = results(idx);
    pos = block.InputPort(1).Data;
    vel = block.InputPort(2).Data;
    handles = guidata(fig);
    set(handles.pos_display,'String',pos);
    set(handles.vel_display,'String',vel);    
end


% --- Executes on button press in connect_button.
function connect_button_Callback(hObject, eventdata, handles)
% hObject    handle to connect_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if (handles.listening == 0)
    disp('start listening');
    if ((strcmp(get_param('visualizer_1','SimulationStatus'),'stopped')))
        set_param('visualizer_1','SimulationCommand','start')
    end
    handles.eventlistener = add_exec_event_listener('visualizer_1/TestFunct','PostUpdate',@handles.doStuff);
    handles.listening = 1;
    guidata(handles.figure1, handles);
elseif (handles.listening == 1)
    disp('stop listening');
    handles.eventlistener = 0;
    handles.listening = 0;
    guidata(handles.figure1, handles);
end

    
        
