function gui = vis_gui_revised(core)
    gui = figure(...
        'Name','vis_gui_revised',...
        'MenuBar','none',...
        'Color',[1 1 1],...
        'Position',[-1800 -270 1800 1200]...
        );

        dims = [-1800 -270 1800 1200];

        wheight = 3; % Meters
        wwidth = wheight*3/2; % meters
        
        handles.display_axis = axes(...
            'Parent',gui,...
            'Units','Pixels',...
            'Position',[250,50,dims(3)*.75,dims(4)*.75],...
            'XLim',[0-1 wwidth-1],...
            'YLim',[0 wheight],...
            'XLimMode','Manual',...
            'YLimMode','Manual'...
            );
        %axis off;
        grid on;
        guidata(gui, handles);
    gui_init(gui,core);    
    
function gui_init(gui,core)
    handles = guidata(gui);
    settings = core.settings;    
    handles.world = World(handles.display_axis, settings.links, settings.joints);
    handles.world.LoadAll();
    handles.ViscoreUpdate = @ViscoreUpdate;
    handles.ViscoreShutdown = @ViscoreShutdown;
    guidata(gui, handles);
    handles = viscore_connect(gui,core);

    guidata(gui, handles);
    
    function ViscoreUpdate(core, eventdata)
        results = findobj(core.gui_plugin_handles,'Name','vis_gui_revised');
        fig = results(1);
        handles = guidata(fig);
        handles.world.UpdateVisual();

    function ViscoreShutdown(core, eventdata)
            results = findobj(0,'Name','vis_gui_revised');
            fig = results(1);
            handles = guidata(fig);
            delete(handles.core); % Removes orphan event listeners.            
            delete(fig);
