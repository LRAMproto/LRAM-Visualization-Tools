function gui = vis_gui_revised(plugin)
% A visual display to connect to the visualizer core.
% TODO: Refactor to take advantage of plugin objects.
handles.plugin = plugin;

if (isequal(size(get(0,'monitorpositions')),[2,4]))
    dims = [-1800 -270 1800 1200];
else
    dims = [0 0 900 600];
end
gui = figure(...
    'Name','vis_gui_revised',...
    'Color',[1 1 1],...
    'MenuBar','none',...
    'Position',dims...
    );
handles.plugin.ConnectGui(gui);

wheight = 3; % Meters
wwidth = wheight*3/2; % meters

handles.display_axis = axes(...
    'Parent',gui,...
    'Units','Pixels',...
    'Position',[50,50,dims(3)*.75,dims(4)*.75],...
    'XLim',[0-.75 wwidth-.5],...
    'YLim',[0 wheight],...
    'XLimMode','Manual',...
    'YLimMode','Manual'...
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
