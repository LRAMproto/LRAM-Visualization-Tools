function programHandles = connect_vis_display(ph)
% Connects the visualizer display to the main program.
ph.PluginTests(1) = VisualizerPlugin('Main Display Window',ph.core);
set(ph.PluginTests(1),'debugMode',0);
set(ph.PluginTests(1),'guiFcn',@vis_gui_revised);
ph.PluginTests(1).AddToPlugins();
ph.PluginTests(1).LoadGui();

programHandles = ph;
end

