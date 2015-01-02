function settings = crusi_startup_debug()
settings.core = ProgramCore();

set(settings.core, 'settingsFile', 'caster_default_settings.mat');
settings.core.LoadSettings();

set(settings.core, 'debugMode', 1);
% Initializes the model for the robot first. This is important because the
% visual display can't use what isn't there.

% Modelling Plugin - controls the updates of the robot and such.
% has no GUI but modifies the core settings.
settings.model = ProgramPlugin('model', settings.core);
CRUSI.robot_settings(settings.model);
set(settings.model, 'debugMode',0);
settings.model.AddToPlugins();

% Display Function

settings.display = ProgramPlugin('display', settings.core);
set(settings.display,...
    'guiFcn',@CRUSI.visual_display);
set(settings.display, 'debugMode',0);
settings.display.AddToPlugins();
settings.display.LoadGui();

settings.slider = ProgramPlugin('slider', settings.core);
set(settings.slider,...
    'guiFcn',@CRUSI.slider_test);
set(settings.slider, 'debugMode', 0);
settings.slider.AddToPlugins();
settings.slider.LoadGui();

notify(settings.core, 'PreUpdateEvent');
notify(settings.core, 'UpdateEvent');
notify(settings.core, 'PostUpdateEvent');

end