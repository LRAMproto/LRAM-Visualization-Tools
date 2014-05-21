function status = check_integrity()
% Checks the integrity of the VisualizerCore object stored in the UserData
% property of the Viscore GUI.

results = findall(0,'Name','lram viscore');
status = 0;

if (numel(results)==0)
    error('viscore not initialized.');
end

core_gui = results(1);

disp('Checking integrity of visualizer Core...');
core = get(core_gui,'UserData');

if (~isa(core.settings.plate_height,'double') || isnan(core.settings.plate_height))
    disp('Plate height wrong type.');
    status = -1;
end

if (~isa(core.settings.target_height,'double') || isnan(core.settings.target_height))
    disp('Target height wrong type.');
    status = -1;
end

disp('All checks passed');
end

