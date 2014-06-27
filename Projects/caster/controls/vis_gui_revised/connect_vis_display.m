function program_handles = connect_vis_display(ph)
% Connects the visualizer display to the main program.
   ph.PluginTests(1) = VisualizerPlugin('Main Display Window',ph.core);
   set(ph.PluginTests(1),'debug_mode',0);
   set(ph.PluginTests(1),'gui_fcn',@vis_gui_revised);
   ph.PluginTests(1).AddToPlugins();    
   ph.PluginTests(1).LoadGui();   

   program_handles = ph;
end

