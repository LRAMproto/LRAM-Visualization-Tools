function program_handles = connect_vis_simulink(ph)
% Connects the visualizer display to the main program.
if ~bdIsLoaded('casting_simulation')
    disp('Opening simulink file... this may several moments if running Simulink for the first time.');
    open_system('casting_simulation');
end
ph.SimulinkTest = ProgramPlugin('Simulink Input',ph.core);
set(ph.SimulinkTest,'debugMode',0);
ph.SimulinkTest.AddToPlugins();
% Sets the UserData parameter to the plugin to allow for continuous
% updates.
set_param('casting_simulation/Caster Visualizer Display',...
    'UserData',ph.SimulinkTest);

notify(ph.core,'UpdateEvent');
% Exports updated program handles
program_handles = ph;
end



