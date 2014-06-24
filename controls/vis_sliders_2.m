function vis_sliders_2(core)
% TODO: Refactor to take advantage of plugin objects.
% FIXME: Assign shutdown function to close slider test.
fig = figure(...
    'Name','Vis Sliders 2',...
    'Position',[0 0 500 500]...
    );
handles = guidata(fig);
handles.robot_slider = uicontrol(...
    'Parent',fig,...
    'Style','slider',...
    'Units','pixels',...
    'Min',0,...
    'Max',1.25,...
    'Position',[20 0 50 500]...
    );
handles.target_slider = uicontrol(...
    'Parent',fig,...
    'Style','slider',...
    'Units','pixels',...
    'Min',0,...
    'Max',1.25,...
    'Position',[90 0 50 500]...
    );

handles.robot_peg_x_edit = uicontrol(...
    'Parent',fig,...
    'Style','edit',...
    'Units','pixels',...
    'Position',[150 450 50 25]...
    );

handles.robot_peg_y_edit = uicontrol(...
    'Parent',fig,...
    'Style','edit',...
    'Units','pixels',...
    'Position',[150 400 50 25]...
    );

handles.robotsliderlh = addlistener(handles.robot_slider,'ContinuousValueChange',@ChangeValue);
handles.targetsliderlh = addlistener(handles.target_slider,'ContinuousValueChange',@ChangeValue);

set(handles.robot_peg_x_edit,'Callback',@ChangeValue);
set(handles.robot_peg_y_edit,'Callback',@ChangeValue);

handles.core = core;

handles.robot_plate_joint = findobj(handles.core.settings.joints,'name','Robot Plate to Frame Joint');
handles.target_plate_joint = findobj(handles.core.settings.joints,'name','Target Plate to Frame Joint');
handles.box_to_plate = findobj(handles.core.settings.joints,'name','Box to Plate Joint');

handles.ViscoreUpdate = @ViscoreUpdate;
handles.ViscoreShutdown = @ViscoreShutdown;
guidata(fig, handles);
handles = viscore_connect(fig,core);


guidata(fig, handles);

end

function ChangeValue(hObject, eventdata)
        fig = get(hObject,'Parent');
        handles = guidata(fig);
        settings = handles.core.settings;
        robot_height = get(handles.robot_slider,'Value');
        curposition = get(handles.robot_plate_joint,'position');
        set(handles.robot_plate_joint,'position',[curposition(1),robot_height]);

        target_height = get(handles.target_slider,'Value');     
        curposition = get(handles.target_plate_joint,'position');
        set(handles.target_plate_joint,'position',[curposition(1),target_height]);
        
        pegx = get(handles.robot_peg_x_edit,'String');
        pegy = get(handles.robot_peg_y_edit,'String');
        handles.core.settings.misc.robot.PegPosition = [pegx, pegy];
        
        notify(handles.core,'UpdateEvent');
        guidata(fig,handles);
end

function ViscoreUpdate(core, eventdata)
    results = findall(core.gui_plugin_handles,'Name','Vis Sliders 2');
    fig = results(1);
    handles = guidata(fig);
    
    set(handles.robot_slider,'Value',handles.robot_plate_joint.position(2));    
    set(handles.target_slider,'Value',handles.target_plate_joint.position(2));    
    set(handles.robot_peg_x_edit,'String',handles.core.settings.misc.robot.PegPosition(1));
    set(handles.robot_peg_y_edit,'String',handles.core.settings.misc.robot.PegPosition(2));
    
    guidata(fig, handles);
end

function ViscoreShutdown(core, eventdata)
end

