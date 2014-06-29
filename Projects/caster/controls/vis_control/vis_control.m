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

% Last Modified by GUIDE v2.5 27-Jun-2014 15:52:20

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

programHandles = varargin{1};
% TODO: Re-Organize Programs into a logical fashion instead of a big mess.

handles.core = programHandles.core;
handles.target_plate = findobj(handles.core.settings.links,'name','Target Plate');
handles.plugin = findobj(handles.core.plugins,'name','Control Panel');
handles.target_plate_joint = findobj(handles.core.settings.joints,'name','Target Plate to Pivot Joint');
handles.robot_arm_joint = findobj(handles.core.settings.joints,'name','Arm Joint');
handles.robot_arm = handles.robot_arm_joint.childData;
handles.arm_pivot_tracking_point = findobj(handles.robot_arm.trackingPoints,'name','Arm Pivot Point');
handles.robot_plate_to_frame_joint = findobj(handles.core.settings.joints,'name','Robot Mounting Plate to Frame Joint');
handles.ball_position_joint = findobj(handles.core.settings.joints,'name','Ball Position Joint');
handles.target_pivot = findobj(handles.core.settings.links,'name','Target Plate Pivot');
handles.target = findobj(handles.target_pivot.trackingPoints,'name','Target Pivot Point');

set(handles.plugin,'update_fcn',@ViscoreUpdate);
set(handles.plugin,'shutdown_fcn',@ViscoreShutdown);    
set(handles.connection_status_display,'string','CONNECTED');

handles.world = handles.core.settings.links(1).world;
handles.display_axis = handles.world.ax;
set(handles.display_axis,'XLimMode','manual','YLimMode','manual');
handles.trajectory = plot(handles.display_axis,[0 1 2 3],[0 0 0 0],'O-');
handles.UpdateTrajectory = @UpdateTrajectory;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes vis_control wait for user response (see UIRESUME)
% uiwait(handles.vis_control);

% --- Outputs from this function are returned to the command line.
function varargout = vis_control_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in target_plate_visibility.
function target_plate_visibility_Callback(hObject, eventdata, handles)
% hObject    handle to target_plate_visibility (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of target_plate_visibility
if get(hObject,'Value') == 0
    set(handles.target_plate_angle_edit,'enable','off');
end
if get(hObject,'Value') == 1
    set(handles.target_plate_angle_edit,'enable','on');
end

handles.target_plate.ToggleVisibility();


function robot_mounting_plate_height_edit_Callback(hObject, eventdata, handles)
% hObject    handle to robot_mounting_plate_height_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of robot_mounting_plate_height_edit as text
%        str2double(get(hObject,'String')) returns contents of robot_mounting_plate_height_edit as a double
newheight = str2double(get(hObject,'String'));
handles.core.settings.misc.robot.PlatePosition = newheight;
set(handles.robot_plate_to_frame_joint,'position',handles.core.settings.misc.robot.PlatePositionFcn(newheight));
notify(handles.core,'UpdateEvent');

% --- Executes during object creation, after setting all properties.
function robot_mounting_plate_height_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to robot_mounting_plate_height_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function robot_peg_x_edit_Callback(hObject, eventdata, handles)
% hObject    handle to robot_peg_x_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of robot_peg_x_edit as text
%        str2double(get(hObject,'String')) returns contents of robot_peg_x_edit as a double


% --- Executes during object creation, after setting all properties.
function robot_peg_x_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to robot_peg_x_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function robot_peg_y_edit_Callback(hObject, eventdata, handles)
% hObject    handle to robot_peg_y_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of robot_peg_y_edit as text
%        str2double(get(hObject,'String')) returns contents of robot_peg_y_edit as a double


% --- Executes during object creation, after setting all properties.
function robot_peg_y_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to robot_peg_y_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function target_plate_angle_edit_Callback(hObject, eventdata, handles)
% hObject    handle to target_plate_angle_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of target_plate_angle_edit as text
%        str2double(get(hObject,'String')) returns contents of target_plate_angle_edit as a double
theta = str2double(get(hObject,'String'));
handles.target_plate_joint.Rotate(theta);
notify(handles.core,'UpdateEvent');


% --- Executes during object creation, after setting all properties.
function target_plate_angle_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to target_plate_angle_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function target_mounting_plate_height_edit_Callback(hObject, eventdata, handles)
% hObject    handle to target_mounting_plate_height_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of target_mounting_plate_height_edit as text
%        str2double(get(hObject,'String')) returns contents of target_mounting_plate_height_edit as a double


% --- Executes during object creation, after setting all properties.
function target_mounting_plate_height_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to target_mounting_plate_height_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function target_peg_x_edit_Callback(hObject, eventdata, handles)
% hObject    handle to target_peg_x_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of target_peg_x_edit as text
%        str2double(get(hObject,'String')) returns contents of target_peg_x_edit as a double


% --- Executes during object creation, after setting all properties.
function target_peg_x_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to target_peg_x_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function target_peg_y_edit_Callback(hObject, eventdata, handles)
% hObject    handle to target_peg_y_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of target_peg_y_edit as text
%        str2double(get(hObject,'String')) returns contents of target_peg_y_edit as a double


% --- Executes during object creation, after setting all properties.
function target_peg_y_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to target_peg_y_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in spot_color_select.
function spot_color_select_Callback(hObject, eventdata, handles)
% hObject    handle to spot_color_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns spot_color_select contents as cell array
%        contents{get(hObject,'Value')} returns selected item from spot_color_select
contents = cellstr(get(hObject,'String'));
disp(contents{get(hObject,'Value')});

if (get(hObject,'value')==1)
end


% --- Executes during object creation, after setting all properties.
function spot_color_select_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spot_color_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ViscoreUpdate(core, eventdata)
        results = findall(0,'tag','vis_control');
        fig = results(1);
        handles = guidata(fig);
        set(handles.robot_peg_x_edit,'String',handles.core.settings.misc.robot.PegPosition(1));
        set(handles.robot_peg_y_edit,'String',handles.core.settings.misc.robot.PegPosition(2));

        set(handles.target_peg_x_edit,'String',handles.core.settings.misc.target.PegPosition(1));
        set(handles.target_peg_y_edit,'String',handles.core.settings.misc.target.PegPosition(2));

        set(handles.target_plate_angle_edit,'String',get(handles.target_plate_joint,'angle'));
        set(handles.robot_arm_angle_edit,'String',get(handles.robot_arm_joint,'angle'));
        set(handles.robot_mounting_plate_height_edit,'String',handles.core.settings.misc.robot.PlatePosition);
        set(handles.target_mounting_plate_height_edit,'String',handles.core.settings.misc.target.PlatePosition);
        
        vel = str2double(get(handles.robot_arm_velocity_edit,'String'));
        pos = get(handles.robot_arm_joint,'angle');
        pos = pos - pi;
        plate_height = get(handles.robot_plate_to_frame_joint,'position');
        pivot_point = get(handles.arm_pivot_tracking_point,'worldPosition');
        handles.UpdateTrajectory(handles,vel,pos,pivot_point);
        
        guidata(fig,handles);

    
function ViscoreShutdown(core, eventdata)

function UpdateTrajectory(handles,Vo,Ro,pivot_point)
% Plot data
t = linspace(0,0.5,10);
%theta = pi/3;                   % Release angle

theta = Ro;
omega = [0 0 Vo];
%omega = [0 0 2*pi];

L   = get(handles.robot_arm,'width')/2; % length of arm

Rx  = L*sin(theta);
Ry  = -L*cos(theta);
Ro  = [Rx Ry 0];
Vo  = cross(omega,Ro);

Yo = pivot_point(2);
Xo = pivot_point(1);
%Yo  = 2;                 % This is the position of the rotating axis
%Xo  = .33;
%target = [2.49 1.36];           % Location of target from lower left
%target = [2.49 0];           % Location of target from lower left
target = handles.target.worldPosition;
[positions,velocities] = trajectory(t,Vo,Ro,Xo,Yo,target);
%[positions,velocities] = old_trajectory(t,Vo,Ro,Xo,Yo);
set(handles.trajectory,'XData',positions(1,:),'YData',positions(2,:));
set(handles.display_axis,'XLim',[-0.5 3.31],'YLim',[0 2.54]);
handles.ball_position_joint.MoveXY(positions(1,length(positions)),positions(2,length(positions)));

function robot_arm_angle_edit_Callback(hObject, eventdata, handles)
% hObject    handle to robot_arm_angle_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of robot_arm_angle_edit as text
%        str2double(get(hObject,'String')) returns contents of robot_arm_angle_edit as a double

theta = str2double(get(hObject,'String'));
handles.robot_arm_joint.Rotate(theta);
notify(handles.core,'UpdateEvent');

% --- Executes during object creation, after setting all properties.
function robot_arm_angle_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to robot_arm_angle_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function robot_arm_velocity_edit_Callback(hObject, eventdata, handles)
% hObject    handle to robot_arm_velocity_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of robot_arm_velocity_edit as text
%        str2double(get(hObject,'String')) returns contents of robot_arm_velocity_edit as a double
notify(handles.core,'UpdateEvent');

% --- Executes during object creation, after setting all properties.
function robot_arm_velocity_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to robot_arm_velocity_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
