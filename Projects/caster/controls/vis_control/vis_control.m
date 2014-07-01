function varargout = vis_control(varargin)
% VIS_CONTROL_FIGURE MATLAB code for vis_control_figure.fig
%      VIS_CONTROL_FIGURE, by itself, creates a new VIS_CONTROL_FIGURE or raises the existing
%      singleton*.
%
%      H = VIS_CONTROL_FIGURE returns the handle to a new VIS_CONTROL_FIGURE or the handle to
%      the existing singleton*.
%
%      VIS_CONTROL_FIGURE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIS_CONTROL_FIGURE.M with the given input arguments.
%
%      VIS_CONTROL_FIGURE('Property','Value',...) creates a new VIS_CONTROL_FIGURE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before vis_control_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to vis_control_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help vis_control_figure

% Last Modified by GUIDE v2.5 01-Jul-2014 16:23:44

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


% --- Executes just before vis_control_figure is made visible.
function vis_control_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to vis_control_figure (see VARARGIN)

% Choose default command line output for vis_control_figure
handles.output = hObject;

handles.plugin = varargin{1};
% TODO: Re-Organize Programs into a logical fashion instead of a big mess.

handles.plugin.ConnectGui(gcf);

% Robot Mounting Plate.
handles.robotMountingPlateToFrameJoint = findobj(handles.plugin.core.settings.CastingRobot.joints,'name','Robot Mounting Plate to Frame Joint');
% Robot Arm
handles.armJoint = findobj(handles.plugin.core.settings.CastingRobot.joints,'name','Arm Joint');
% TODO: Redefine using findobj
handles.robot_arm = handles.armJoint.childData;
handles.armPivotPoint = findobj(handles.robot_arm.trackingPoints,'name','Arm Pivot Point');

% Target Mounting Plate
handles.targetMountingPlateToFrameJoint = findobj(handles.plugin.core.settings.CastingRobot.joints,'name','Target Mounting Plate to Frame Joint');

% Target
handles.targetPlateToPivotJoint = findobj(handles.plugin.core.settings.CastingRobot.joints,'name','Target Plate to Pivot Joint');
handles.targetPlate = findobj(handles.plugin.core.settings.CastingRobot.links,'name','Target Plate');
handles.targetPlatePivot = findobj(handles.plugin.core.settings.CastingRobot.links,'name','Target Plate Pivot');
handles.targetPivotPoint = findobj(handles.targetPlatePivot.trackingPoints,'name','Target Pivot Point');
handles.targetPlatePivotToTargetMountingPlateJoint = findobj(handles.plugin.core.settings.CastingRobot.joints,'name','Target Plate Pivot to Target Mounting Plate Joint');
handles.boxToMountingPlateJoint = findobj(handles.plugin.core.settings.CastingRobot.joints,'name','Box to Mounting Plate Joint');

% Position of ball with respect to world.

handles.spot = findobj(handles.plugin.core.settings.CastingRobot.links,'name','Ball');

handles.ballPositionJoint = findobj(handles.plugin.core.settings.CastingRobot.joints,'name','Ball Position Joint');

set(handles.plugin,'updateFcn',@ViscoreUpdate);
set(handles.plugin,'postUpdateFcn',@ViscorePostUpdate);
set(handles.plugin,'shutdownFcn',@ViscoreShutdown);

handles.world = handles.plugin.core.settings.CastingRobot.links(1).world;
handles.display_axis = handles.world.displayAxis;

handles.display_axis_parent = get(handles.display_axis,'parent');

handles.trajectory = line('parent',handles.display_axis,'xdata',[0 2 4 6],'ydata',[0 0 0 0],'color','blue','linewidth',2);

handles.UpdateTrajectory = @UpdateTrajectory;

set(handles.spot_color_select,'UserData',[...
    handles.plugin.core.settings.misc.colors.HattonRed;...
    handles.plugin.core.settings.misc.colors.OsuOrange]);

set(handles.spot_color_select,'Value',...
    handles.plugin.core.settings.misc.colors.SpotColorDefault);

% Update handles structure
guidata(hObject, handles);
notify(handles.plugin.core,'UpdateEvent');

% UIWAIT makes vis_control_figure wait for user response (see UIRESUME)
% uiwait(handles.vis_control_figure);

% --- Outputs from this function are returned to the command line.
function varargout = vis_control_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in targetPlate_visibility.
function target_plate_visibility_Callback(hObject, eventdata, handles)
% hObject    handle to targetPlate_visibility (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of targetPlate_visibility
if get(hObject,'Value') == 0
    set(handles.target_plate_angle_edit,'enable','off');
end
if get(hObject,'Value') == 1
    set(handles.target_plate_angle_edit,'enable','on');
end

handles.targetPlate.ToggleVisibility();


function robot_mounting_plate_height_edit_Callback(hObject, eventdata, handles)
% hObject    handle to robot_mounting_plate_height_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of robot_mounting_plate_height_edit as text
%        str2double(get(hObject,'String')) returns contents of robot_mounting_plate_height_edit as a double
if get(handles.eval_enable_checkbox,'Value')
newheight = eval(get(hObject,'string'));
else
newheight = str2double(get(hObject,'String'));
end
handles.plugin.core.settings.misc.robot.PlatePosition = newheight;
set(handles.robotMountingPlateToFrameJoint,'position',handles.plugin.core.settings.misc.robot.PlatePositionFcn(newheight));
notify(handles.plugin.core,'UpdateEvent');

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
newX = str2double(get(hObject,'String'));
oldY = handles.plugin.core.settings.misc.robot.pegPosition(2);
handles.plugin.core.settings.misc.robot.pegPosition = [newX, oldY];
set(handles.boxToMountingPlateJoint,'position',...
    handles.plugin.core.settings.misc.robot.PegPositionFcn(...
    handles.plugin.core.settings.misc.robot.pegPosition));

notify(handles.plugin.core,'UpdateEvent');


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

newY = str2double(get(hObject,'String'));
oldX = handles.plugin.core.settings.misc.robot.pegPosition(1);
handles.plugin.core.settings.misc.robot.pegPosition = [oldX, newY];
set(handles.boxToMountingPlateJoint,'position',...
    handles.plugin.core.settings.misc.robot.PegPositionFcn(...
    handles.plugin.core.settings.misc.robot.pegPosition));

notify(handles.plugin.core,'UpdateEvent');


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
if get(handles.eval_enable_checkbox,'Value')
    theta = eval(get(hObject,'string'));
else
theta = str2double(get(hObject,'String'));
end
handles.targetPlateToPivotJoint.Rotate(theta);
notify(handles.plugin.core,'UpdateEvent');


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

if get(handles.eval_enable_checkbox,'Value')
newheight = eval(get(hObject,'string'));
else
newheight = str2double(get(hObject,'String'));
end
handles.plugin.core.settings.misc.target.PlatePosition = newheight;
set(handles.targetMountingPlateToFrameJoint,'position',handles.plugin.core.settings.misc.target.PlatePositionFcn(newheight));
notify(handles.plugin.core,'UpdateEvent');

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
newX = str2double(get(hObject,'String'));
oldY = handles.plugin.core.settings.misc.target.pegPosition(2);
handles.plugin.core.settings.misc.target.pegPosition = [newX, oldY];
set(handles.targetPlatePivotToTargetMountingPlateJoint,'position',...
    handles.plugin.core.settings.misc.target.PegPositionFcn(...
    handles.plugin.core.settings.misc.target.pegPosition));

notify(handles.plugin.core,'UpdateEvent');


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

newY = str2double(get(hObject,'String'));
oldX = handles.plugin.core.settings.misc.target.pegPosition(1);
handles.plugin.core.settings.misc.target.pegPosition = [oldX, newY];
set(handles.targetPlatePivotToTargetMountingPlateJoint,'position',...
    handles.plugin.core.settings.misc.target.PegPositionFcn(...
    handles.plugin.core.settings.misc.target.pegPosition));

notify(handles.plugin.core,'UpdateEvent');

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

if (get(hObject,'value')==1)
end
choice = get(hObject,'Value');
colors = get(hObject,'UserData');
handles.plugin.core.settings.misc.colors.SpotColorDefault = choice;
set(handles.spot,'fillColor',colors(choice,:));

notify(handles.plugin.core,'UpdateEvent');

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
results = findall(core.guiPluginHandles,'tag','vis_control_figure');
if numel(results) == 0
    error('ViscoreUpdate in vis_control cannot find vis_control.');
end
fig = results(1);
handles = guidata(fig);
set(handles.connection_status_display,'string','UPDATE PENDING');


function ViscorePostUpdate(core, eventdata)
results = findall(core.guiPluginHandles,'tag','vis_control_figure');
if numel(results) == 0
    error('ViscorePostUpdate in vis_control cannot find vis_control.');
end
fig = results(1);
handles = guidata(fig);
set(handles.connection_status_display,'string','UPDATING GUI');
set(handles.spot_color_select,'Value',...
    handles.plugin.core.settings.misc.colors.SpotColorDefault);

set(handles.robot_peg_x_edit,'String',handles.plugin.core.settings.misc.robot.pegPosition(1));
set(handles.robot_peg_y_edit,'String',handles.plugin.core.settings.misc.robot.pegPosition(2));

set(handles.target_peg_x_edit,'String',handles.plugin.core.settings.misc.target.pegPosition(1));
set(handles.target_peg_y_edit,'String',handles.plugin.core.settings.misc.target.pegPosition(2));

set(handles.target_plate_angle_edit,'String',get(handles.targetPlateToPivotJoint,'angle'));
set(handles.robot_arm_angle_edit,'String',get(handles.armJoint,'angle'));
set(handles.robot_mounting_plate_height_edit,'String',handles.plugin.core.settings.misc.robot.PlatePosition);
set(handles.target_mounting_plate_height_edit,'String',handles.plugin.core.settings.misc.target.PlatePosition);
set(handles.robot_arm_velocity_edit,'String',num2str(handles.plugin.core.settings.misc.robot.arm.velocity));
vel = handles.plugin.core.settings.misc.robot.arm.velocity;
pos = get(handles.armJoint,'angle');
pos = pos - pi;
plate_height = get(handles.robotMountingPlateToFrameJoint,'position');
pivot_point = get(handles.armPivotPoint,'worldPosition');
handles.UpdateTrajectory(handles,vel,pos,pivot_point);
set(handles.connection_status_display,'string','UPDATED');
guidata(fig,handles);


function ViscoreShutdown(core, eventdata)

function UpdateTrajectory(handles,Vi,Ri,pivot_point)


% Plot data
t = linspace(0,0.5,10);

theta = Ri;
omega = [0 0 Vi];

L   = get(handles.robot_arm,'width')/2; % length of arm

Rx  = L*sin(theta);
Ry  = -L*cos(theta);
Ro  = [Rx Ry 0];
Vo  = cross(omega,Ro);

Yo = pivot_point(2); % This is the position of the rotating axis
Xo = pivot_point(1);
target = handles.targetPivotPoint.worldPosition; % Location of target from lower left
%[positions,velocities] = trajectory(t,Vo,Ro,Xo,Yo,target);
[positions,velocities] = old_trajectory(t,Vo,Ro,Xo,Yo);
set(handles.trajectory,'XData',positions(1,:),'YData',positions(2,:));
set(handles.display_axis,'XLim',[-0.5 3.31],'YLim',[0 2.54]);
handles.ballPositionJoint.MoveXY(positions(1,length(positions)),positions(2,length(positions)));

function robot_arm_angle_edit_Callback(hObject, eventdata, handles)
% hObject    handle to robot_arm_angle_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of robot_arm_angle_edit as text
%        str2double(get(hObject,'String')) returns contents of robot_arm_angle_edit as a double

if get(handles.eval_enable_checkbox,'Value')
    theta = eval(get(hObject,'string'));
else
theta = str2double(get(hObject,'String'));
end
handles.armJoint.Rotate(theta);
notify(handles.plugin.core,'UpdateEvent');

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
if get(handles.eval_enable_checkbox,'value')
    handles.plugin.core.settings.misc.robot.arm.velocity = eval(get(handles.robot_arm_velocity_edit,'String'));
else   
    handles.plugin.core.settings.misc.robot.arm.velocity = str2double(get(handles.robot_arm_velocity_edit,'String'));
end
notify(handles.plugin.core,'UpdateEvent');

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


% --- Executes on button press in eval_enable_checkbox.
function eval_enable_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to eval_enable_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of eval_enable_checkbox


% --- Executes on key press with focus on robot_arm_angle_edit and none of its controls.
function robot_arm_angle_edit_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to robot_arm_angle_edit (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on key press with focus on vis_control_figure and none of its controls.
function vis_control_figure_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to vis_control_figure (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

% Code if you wished to add in the 'nudge' ability to the screen.

if strcmp(eventdata.Key,'uparrow')
    handles.armJoint.Rotate(get(handles.armJoint,'angle')+.05);
elseif strcmp(eventdata.Key,'downarrow')
    handles.armJoint.Rotate(get(handles.armJoint,'angle')-.05);
elseif strcmp(eventdata.Key,'leftarrow')
    handles.plugin.core.settings.misc.robot.arm.velocity=...
        handles.plugin.core.settings.misc.robot.arm.velocity-0.5;
elseif strcmp(eventdata.Key,'rightarrow')
    handles.plugin.core.settings.misc.robot.arm.velocity=...
        handles.plugin.core.settings.misc.robot.arm.velocity+0.5;
else
    disp(eventdata.Key);
end
notify(handles.plugin.core,'UpdateEvent');