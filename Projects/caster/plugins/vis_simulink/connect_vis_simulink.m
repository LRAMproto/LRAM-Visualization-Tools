function program_handles = connect_vis_simulink(ph)
% Connects the visualizer display to the main program.
if ~bdIsLoaded('casting_simulation')
    disp('Opening simulink file... this may several moments if running Simulink for the first time.');
    open_system('casting_simulation');
end
ph.SimulinkTest = VisualizerPlugin('Simulink Input',ph.core);
set(ph.SimulinkTest,'debugMode',0);
ph.SimulinkTest.AddToPlugins();
set_param('casting_simulation/Caster Model','userdata',ph.SimulinkTest);

notify(ph.core,'UpdateEvent');
program_handles = ph;
end



