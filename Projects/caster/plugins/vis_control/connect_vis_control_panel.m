function program_handles = connect_vis_control_panel(ph)
% Connects the visualizer display to the main program.
ph.Plugins.ControlPanel = ProgramPlugin('Control Panel',ph.core);
set(ph.Plugins.ControlPanel,'debugMode',1);
set(ph.Plugins.ControlPanel,'guiFcn',@vis_control);
ph.Plugins.ControlPanel.AddToPlugins();
ph.Plugins.ControlPanel.LoadGui();
notify(ph.core,'UpdateEvent');
program_handles = ph;
end

