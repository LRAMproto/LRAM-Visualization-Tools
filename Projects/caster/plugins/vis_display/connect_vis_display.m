function programHandles = connect_vis_display(ph)
% Connects the visualizer display to the main program.
ph.Plugins.Display = ProgramPlugin('Main Display Window',ph.core);
set(ph.Plugins.Display,'debugMode',1);
set(ph.Plugins.Display,'guiFcn',@vis_display);
ph.Plugins.Display.AddToPlugins();
ph.Plugins.Display.LoadGui();

programHandles = ph;
end

