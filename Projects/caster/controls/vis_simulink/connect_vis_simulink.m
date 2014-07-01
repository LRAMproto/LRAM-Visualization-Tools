function program_handles = connect_vis_simulink(ph)
% Connects the visualizer display to the main program.
open_system('casting_simulation');
ph.SimulinkTest = VisualizerPlugin('Simulink Input',ph.core);
set(ph.SimulinkTest,'debugMode',0);
ph.SimulinkTest.AddToPlugins();
set_param('casting_simulation/Caster Model','userdata',ph.SimulinkTest);

notify(ph.core,'UpdateEvent');
program_handles = ph;
end



