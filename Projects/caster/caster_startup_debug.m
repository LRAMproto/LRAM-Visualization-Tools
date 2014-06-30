function ph = caster_startup_debug
% This function allows for the user to recieve a copy of all program
% handles that the startup routine generates.

    % Generates all default settings afresh.
    make_caster_default_settings();
    
    % Initializes a program core to manage update operations
    ph.core = VisualizerCore();
    
    % Sets the settings file
    set(ph.core,...
        'settingsFile','caster_default_settings',...
        'debugMode',0);
    
    % Loads stored settings into the core settings object.
    ph.core.LoadSettings();    
     
   % Loads the Display and the Control panel.
   ph = connect_vis_display(ph);
   ph = connect_vis_control_panel(ph);

end

