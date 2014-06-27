function h = viscore_tests()
% The following tests the visualizer core program doing various things.
h = test3();
    
end
% This is deprecated; we no longer use the display function to load the
% GUI.

function h = test1()

    make_caster_default_settings();
    
    core = VisualizerCore();
    
    set(core,...
        'name','LRAM Visualizer Core',...
        'settingsfile','caster_default_settings',...
        'debug_mode',1);
    
    % Loads stored settings into the core settings object.
    core.LoadSettings();
    
    h = core.program_handles;
    
    % Now that we have loaded the settings, we can load the GUI.
    
    % Loads the visual interface.
    vis_gui_revised(h);

    % Loads a control interface.
    
    vis_sliders_2(h);
    
end

function h =  test2()

    make_caster_default_settings();
    
    h.core = VisualizerCore();
    
    set(h.core,...
        'settingsfile','caster_default_settings',...
        'debug_mode',0);
    
    % Loads stored settings into the core settings object.
    h.core.LoadSettings();    
    
    % Now that we have loaded the settings, we can load the GUI.

    % Loads a test plugin.
   h.PluginTests(1) = VisualizerPlugin('Test',h.core);
   set(h.PluginTests(1),'debug_mode',0);
   set(h.PluginTests(1),...
       'gui_fcn',@testfunction);

   h.PluginTests(1).AddToPlugins();
   
   % Loads the Control Panel for the Display
   h.PluginTests(2) = VisualizerPlugin('Control Panel',h.core);
   set(h.PluginTests(2),'debug_mode',0);
   set(h.PluginTests(2),'gui_fcn',@vis_sliders_2);
   h.PluginTests(2).AddToPlugins();    
   h.PluginTests(2).LoadGui();
   
   % Loads the Display
   h.PluginTests(3) = VisualizerPlugin('Main Display Window',h.core);
   set(h.PluginTests(3),'debug_mode',0);
   set(h.PluginTests(3),'gui_fcn',@vis_gui_revised);
   h.PluginTests(3).AddToPlugins();    
   h.PluginTests(3).LoadGui();   
   
end

function h =  test3()

    make_caster_default_settings();
    
    h.core = VisualizerCore();
    
    set(h.core,...
        'settingsfile','caster_default_settings',...
        'debug_mode',0);
    
    % Loads stored settings into the core settings object.
    h.core.LoadSettings();    
     
   % Loads the Display
   h.PluginTests(1) = VisualizerPlugin('Main Display Window',h.core);
   set(h.PluginTests(1),'debug_mode',0);
   set(h.PluginTests(1),'gui_fcn',@vis_gui_revised);
   h.PluginTests(1).AddToPlugins();    
   h.PluginTests(1).LoadGui();   
   
end
