function varargout = vis_gui(varargin)
% VIS_GUI MATLAB code for vis_gui.fig
%      VIS_GUI, by itself, creates a new VIS_GUI or raises the existing
%      singleton*.
%
%      H = VIS_GUI returns the handle to a new VIS_GUI or the handle to
%      the existing singleton*.
%
%      VIS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIS_GUI.M with the given input arguments.
%
%      VIS_GUI('Property','Value',...) creates a new VIS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before vis_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to vis_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help vis_gui

% Last Modified by GUIDE v2.5 25-Apr-2014 18:45:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @vis_gui_OpeningFcn, ...
    'gui_OutputFcn',  @vis_gui_OutputFcn, ...
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


% --- Executes just before vis_gui is made visible.
function vis_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to vis_gui (see VARARGIN)

% Choose default command line output for vis_gui
handles.output = hObject;

% This is the configuration file. An option should be added to the
% visualizer to load the file from the GUI.

handles.plate_height = 0;
handles.target_height = 0;
handles.listening = 0;


handles.trajectory = plot(handles.display_axis,1,1,'<-');
%handles.trajectory_v = quiver(handles.display_axis,1,1,1,1);
handles.doStuff = @doStuff;
handles.setSpotColor = @setSpotColor;
handles.updateTrajectory = @updateTrajectory;

set(handles.display_axis,'Visible','off');

%handles.eventlistener = add_exec_event_listener('visualizer_1/TestFunct','PostUpdate',@handles.doStuff)

% Update handles structure
handles.base = drawBase(handles);

[handles.robot_plate, handles.robot_plate_base_x, handles.robot_plate_base_y] = initRobotPlate(handles);
%[handles.target_plate, handles.target_plate_base] = initTargetPlate(handles);

handles.ball = makeCirclePatch(handles,1.5*(2.54/100),0,0);

handles.ball_x = get(handles.ball,'XData');
handles.ball_y = get(handles.ball,'YData');

r = 1.5*(2.54/100);
x = 1;
y = 1;
handles.target_bar = makeCirclePatch(handles,r,x,y);
set(handles.target_bar,'FaceColor',[1,1,1]);
handles.moveRobotPlateTo = @moveRobotPlateTo;

%Standard Visualizer Core Functions
handles.ViscoreUpdate = @ViscoreUpdate;
handles.ViscoreShutdown = @ViscoreShutdown;
handles.corelistener = -1; % Uninitialized
handles.core = -1;
guidata(hObject, handles);
handles = viscore_connect(hObject);
guidata(hObject, handles);
disp('Core handle for vis_gui');
disp(handles.core);

%updateDisplay(hObject, eventdata, handles);


% UIWAIT makes vis_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
%move_to_monitor_2(hObject,handles)


% --- Outputs from this function are returned to the command line.
function varargout = vis_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

new_fig_pos = get(handles.figure1,'Position');
new_height = new_fig_pos(4);
new_width = new_height*1.5;

set(handles.display_axis,'Position',[0,0,[new_width, new_height]]);


function move_to_monitor_2(figure, handles)
movegui(handles.figure1,'north');
% oldposition = get(handles.figure1,'Position');
% newpos = [[-1679,-281] , [oldposition(3),oldposition(4)]];
% disp('newpos=');
% disp(newpos);
% set(handles.figure1,'Position',newpos);
% disp(get(handles.figure1,'Position'));
% guidata(figure,handles)

function circle = makeCirclePatch(handles,r,xc,yc)
% Code adapted from the Matlab Cookbook
% http://www.matlab-cookbook.com/recipes/0050_Plotting/0030_Line_and_Scatter_Plots/plottingACircle.html

t = 0:.01:2*pi;
xp = r*cos(t)+xc;
yp = r*sin(t)+yc;

circle = patch('XData',xp,'YData',yp,'Parent',handles.display_axis);

function doStuff(block, eventdata)
%disp(block.Dwork(1).Data);
results = findall(0,'Name','vis_gui');
pos = block.InputPort(1).Data;
vel = block.InputPort(2).Data;



for idx = 1:numel(results)
    fig = results(idx);
    handles = guidata(fig);
    handles.updateTrajectory(handles,vel,pos,handles.plate_height);
    %set(handles.text1,'String',block.Dwork(1).Data);
end


function updateTrajectory(handles,Vo,Ro,Plate_Height)
% Plot data
t = linspace(0,0.5,10);
%theta = pi/3;                   % Release angle

theta = Ro;
omega = [0 0 Vo];
%omega = [0 0 2*pi];

L   = .432;                     % length of arm

Rx  = L*sin(theta);
Ry  = -L*cos(theta);
Ro  = [Rx Ry 0];
Vo  = cross(omega,Ro);

Yo  = 1.33;                 % This is the position of the rotating axis
Xo  = .33;
%target = [2.49 1.36];           % Location of target from lower left
target = [2.49 0];           % Location of target from lower left
%[positions,velocities] = trajectory(t,Vo,Ro,Xo,Yo,target);
[positions,velocities] = old_trajectory(t,Vo,Ro,Xo,Yo);
set(handles.trajectory,'XData',positions(1,:),'YData',positions(2,:));
set(handles.display_axis,'XLim',[-0.5 3.31],'YLim',[0 2.54]);
set(handles.ball,...
    'XData',handles.ball_x + positions(1,length(positions)),...
    'YData',handles.ball_y + positions(2,length(positions))...
    )
%set(handles.ball,'Position',[positions(1)(length(positions)) positions(2)(length(positions))],ballcurpos(3),ballcurpos(4));
drawnow
%disp('Updating Trajectory');

%plot(1,1)
%hold on
%grid on
%axis([0 3.03 0 2.18])
%plot(positions(1,:),positions(2,:),'*')
%quiver(positions(1,:),positions(2,:),velocities(1,:),velocities(2,:))
function target_plate = drawTargetPlateAt(handles,plate_position)
% yrin = -plate_position;
% 
% plate_base_x = [0 0 24 24]; % inches
% plate_base_y = [0 24 24 0]; % inches
% 
% ft_ht = 2.5;
% tpx = (plate_base_x+96)*(2.54/100);
% tpy = (plate_base_y+81-24+ft_ht)*(2.54/100);
% target_plate = patch(tpx,tpy, 'm','Parent',handles.display_axis);
yrin = -plate_position;

plate_base_x = [0 0 24 24]; % inches
plate_base_y = [0 24 24 0]; % inches

xr=[-11.625
    -11.625
    12.375
    12.375]+96;
mxr = (xr+11.625)*(2.54/100);

yr=[yrin+7.344
    yrin-15.156
    yrin-15.156
    yrin+7.344];

myr = (yr+74.652+2.5)*(2.54/100);
target_plate = patch(mxr,myr,[0.6039    0.8078    0.9216],'Parent',handles.display_axis);

function [robot_plate, robot_plate_base_x, robot_plate_base_y] = initRobotPlate(handles)

%plate_base_x = [0 0 24 24]; % inches
%plate_base_y = [0 24 24 0]; % inches

%[robot_plate_base_x, robot_plate_base_y] = (squashed_rectangle(24*2.54/100,24*2.54/100,0.9,1000));

xr=[-11.625
    -11.625
    12.375
    12.375];
mxr = (xr+11.625)*(2.54/100);

yr=[7.344
    -15.156
    -15.156
    7.344];

myr = (yr+74.652+2.5)*(2.54/100);

robot_plate = patch(mxr,myr,'k','Parent',handles.display_axis);
robot_plate_base_x = mxr;
robot_plate_base_y = myr;

function moveRobotPlateTo(handles,plate_position)
set(handles.robot_plate,'YData',handles.robot_plate_base_y-(plate_position*2.54/100));

function base = drawBase(handles)
% 
% xf=[-11.625 -11.625 12.375 83.625 106.125 ;
%     -11.625 107.625 12.375 83.625 106.125;
%     -10.125 107.625 10.875 82.125 107.625;
%     -10.125 -11.625 10.875 82.125 107.625];
% yf=[8.844 8.844 7.344 7.344 7.344;
%     -74.652 8.844 -74.652 -74.652 -74.652;
%     -74.652 7.344 -74.652 -74.652 -74.652;
%     8.844 7.344 7.334 7.334 7.334];
% 
% mxf = (xf+11.625)*(2.54/100);
% myf = (yf+74.652+2.5)*(2.54/100);
% base_color = [0.5,0.5,0.5];
% handles.base = patch(mxf,myf,base_color,'Parent',handles.display_axis);
% set(handles.base,'EdgeColor','none');
%% Axis set to zero
xf=[ 0         0   23.50000   97.5  117.7500;
     0  119.2500   23.50000   97.5  117.7500;
    1.5000  119.2500   22.0000   96  119.2500;
    1.5000         0   22.0000   96  119.2500];
yf=[   83.4960   83.4960   81.9960   81.9960   81.9960;
         0   83.4960         0         0         0;
         0   81.9960         0         0         0;
   83.4960   81.9960   81.9860   81.9860   81.9860];

mxf = (xf)*(2.54/100);
myf = (yf+2.5)*(2.54/100);
base_color = [0.5,0.5,0.5];
basepatch = patch(mxf,myf,base_color,'Parent',handles.display_axis);
set(basepatch,'EdgeColor','none');

base = basepatch;


% --- Executes during object creation, after setting all properties.
function display_axis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to display_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate display_axis


% --------------------------------------------------------------------
function connectDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to connectDisplay (see GCBO)
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

function setSpotColor(handles,newcolor)
set(handles.ball,'FaceColor',newcolor)


% The following function updates the GUI

function ViscoreUpdate(hObject, eventdata)
    results = findall(0,'Name','vis_gui');
    if (length(results)>0)
        fig = results(1);
        handles = guidata(fig);
        core = hObject;

        config = core.settings;
        handles.plate_height = -config.plate_height;
        handles.target_height = -config.target_height;

        moveRobotPlateTo(handles,-handles.plate_height);
        guidata(fig, handles);
    end
    
function ViscoreShutdown(hObject, eventdata)
    results = findobj(0,'Name','vis_gui');
    fig = results(1);
    delete(fig);
