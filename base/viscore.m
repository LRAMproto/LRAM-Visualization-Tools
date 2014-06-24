function gui = viscore(program_handles)
%% Visualizer Core for LRAM, version 1
%
% The following function loads a simple figure window 
% that allows multiple programs to modify simulation data at the same time.
% 
%

name = 'lram viscore';
if (isempty(findall(0,'Name',name)))
    gui = handle(viscore_init(name));
else
    error ('Please close all running viscore instances');
end

end

function fh = viscore_init(name)
%% Creates the main interface for the Visualizer.

fh = figure(...
    'Name',name,...
    'Units','Pixels',...
    'Color',[0.4 0.4 0.5],...
    'Position',[0,500,100,50]);

handles = guidata(fh);

set(fh, 'MenuBar','none');
handles.label = uicontrol(...
    'FontName','Impact',...
    'BackgroundColor',[0.4 0.3 0.5],...
    'Parent',fh,...
    'Style','Text',...
    'Units','Pixels',...
    'Position',[0,25,100,20],...
    'String','Visualizer Core'...
    );

% Creates a visualizer core object for managing data sharing between
% plugins
core = VisualizerCore(name);

% Associates the UserData field of a matlab figure to the newly created
% core object. You could alternately set it to be a figure handle, but this
% would require several steps instead of one.

set(fh,'UserData',core);

% When the core program exits, all plugins should exit automatically.
% Associating the shutdown core function with the DeleteFcn callback allows
% the core to send a shutdown event for all ancillary programs to respond
% to appropriately.
set(fh,'DeleteFcn',@ShutdownCore);

% Loads various menus for use in the core program.
handles.filemenu = uimenu(fh,'Label','File');
handles.loadmenu = uimenu(handles.filemenu,'Label','Load Settings','Callback',@LoadMenuFcn);
handles.savemenu = uimenu(handles.filemenu,'Label','Save Settings','Callback',@SaveMenuFcn);

% Packages the handles into the GUI of the figure.
guidata(fh,handles);

%should load a struct containing the name of the last settings.
LoadSettings(fh,'robot_definitions/caster/caster_default_settings.mat');

end

function LoadMenuFcn(hObject, eventdata)
% Loads new file data into the visualizer.
menu = get(hObject,'Parent');
figure = get(menu,'Parent');
filename = uigetfile('.mat');
LoadSettings(figure, filename);

end

function SaveMenuFcn(hObject, eventdata)
% Saves information loaded in the visualizer.
menu = get(hObject,'Parent');
fig = get(menu,'Parent');
core = getCore();
settings = core.settings;
filename = uiputfile('.mat');
save(filename,'-struct','settings');

end

function LoadSettings(figure, filename)
% Load settings for the entire visualizer to use.
core = getCore();
core.settings = load(filename);
notify(core,'Update');
end

function ShutdownCore(hObject, eventdata)
% Sends a signal to all listening objects to shut down when the user exits
% the core window.
core = get(hObject,'UserData');
notify(core,'Shutdown');
end
