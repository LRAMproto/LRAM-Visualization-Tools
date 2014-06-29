function gui = vis_gui_revised(programHandles)
% A visual display to connect to the visualizer core.
% TODO: Refactor to take advantage of plugin objects.
    core = programHandles.core;

    if (isequal(size(get(0,'monitorpositions')),[2,4]))
        dims = [-1800 -270 1800 1200];
    else
        dims = [0 0 900 600];
    end
    gui = figure(...
        'Name','vis_gui_revised',...
        'Color',[1 1 1],...
        'Position',dims...
        );

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
        hold on;
        grid on;
        guidata(gui, handles);
    gui_init(gui,core);    
    
function gui_init(gui,core)
    handles = guidata(gui);    
    handles.core = core;
    results = findobj(core.plugins,'name','Main Display Window');
    handles.plugin = results(1);      
    set(handles.core.plugins,'update_fcn',@ViscoreUpdate);
    set(handles.core.plugins,'shutdown_fcn',@ViscoreShutdown);    
    settings = core.settings;    
    handles.world = World(handles.display_axis, settings.links, settings.joints);
    handles.world.LoadAll();
    guidata(gui, handles);
    handles = viscore_connect(gui,core);

    guidata(gui, handles);
    
    function ViscoreUpdate(core, eventdata)
        results = findobj(core.guiPluginHandles,'Name','vis_gui_revised');
        fig = results(1);
        handles = guidata(fig);
        handles.world.UpdateVisual();

    function ViscoreShutdown(core, eventdata)
            results = findobj(0,'Name','vis_gui_revised');
            fig = results(1);
            handles = guidata(fig);
            delete(handles.core); % Removes orphan event listeners.            
            delete(fig);
