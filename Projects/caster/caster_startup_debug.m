function ph = viscore_startup
%VISCORE_STARTUP Summary of this function goes here
%   Detailed explanation goes here

    make_caster_default_settings();
    
    ph.core = VisualizerCore();
    
    set(ph.core,...
        'settingsfile','caster_default_settings',...
        'debug_mode',0);
    
    % Loads stored settings into the core settings object.
    ph.core.LoadSettings();    
     
   % Loads the Display
   ph = connect_vis_display(ph);
   ph = connect_vis_control_panel(ph);

end

