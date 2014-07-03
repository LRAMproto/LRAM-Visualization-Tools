function gui = vis_gui_revised(plugin)
% A visual display to connect to the visualizer core.
% TODO: Refactor to take advantage of plugin objects.
handles.plugin = plugin;

% Makes figure for single monitor.
dims = [0 0 900 600];

gui = figure(...
    'Name','vis_gui_revised',...
    'Color',[1 1 1],...
    'MenuBar','none',...
    'Units','Pixels',...
    'Position',dims...
    );
% Changes monitor position if there are multiple windows.
if (isequal(size(get(0,'monitorpositions')),[2,4]))
    dims = maximize_second_monitor(gui);
end

handles.plugin.ConnectGui(gui);

wheight = 3; % Meters
wwidth = wheight*3/2; % meters

window_width = dims(3);
window_height = dims(4);

ax_proportion = 1.1;
ax_width = window_height*ax_proportion;
ax_height = ax_width*2/3;
x_ax_offset = (window_width-ax_width)/2;
y_ax_offset = (window_height-ax_height)/2;
ax_position = [x_ax_offset,y_ax_offset,ax_width, ax_height];

handles.display_axis = axes(...
    'Parent',gui,...
    'Units','Pixels',...
    'XLim',[0-.75 wwidth-.5],...
    'YLim',[0 wheight],...
    'XLimMode','Manual',...
    'YLimMode','Manual'...
    );
set(handles.display_axis,...
        'Position',ax_position,...
        'visible','off'...
);
%        axis off;
%        zoom off;
%        hold on;
%        grid on;

set(handles.plugin,'updateFcn',@ViscoreUpdate);
set(handles.plugin,'shutdownFcn',@ViscoreShutdown);
settings = handles.plugin.core.settings;
handles.world = World(handles.display_axis, settings.CastingRobot);
handles.world.LoadAll();
guidata(gui, handles);
%handles = viscore_connect(gui,core);

guidata(gui, handles);

function ViscoreUpdate(core, eventdata)
results = findall(core.guiPluginHandles,'Name','vis_gui_revised');
if numel(results) == 0
    error('ViscoreUpdate in vis_gui_revised cannot find vis_gui_revised.');
end
fig = results(1);
handles = guidata(fig);
handles.world.UpdateVisual();
notify(core,'PostUpdateEvent');

function ViscoreShutdown(core, eventdata)
results = findall(core.guiPluginHandles,'Name','vis_gui_revised');
if numel(results) == 0
    error('ViscoreShutdown cannot find vis_gui_revised.');
end
fig = results(1);
handles = guidata(fig);
delete(fig);
