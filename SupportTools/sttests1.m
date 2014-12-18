function data = sttests1()

data.core = ProgramCore();
set(data.core,...
    'settings',struct('x',0),...
    'debugMode',true);

data.plugin = ProgramPlugin('test',data.core);
set(data.plugin,...
    'preUpdateFcn',@preuf,...
    'updateFcn',@uf,...
    'postUpdateFcn',@postuf,...
    'shutdownFcn',@shutdownf,...
    'debugMode',true...
);

data.plugin2 = ProgramPlugin('test2',data.core);
set(data.plugin2,...
    'preUpdateFcn',@preuf,...
    'updateFcn',@uf,...
    'postUpdateFcn',@postuf,...
    'shutdownFcn',@shutdownf,...
    'debugMode',true...
);

data.plugin.AddToPlugins()
data.plugin2.AddToPlugins()

disp(data.core);
disp(data.plugin);

notify(data.core,'PreUpdateEvent');
notify(data.core,'UpdateEvent');
notify(data.core,'PostUpdateEvent');
notify(data.core,'ShutdownEvent');

end

function preuf(core, eventData, plugin)

end

function uf(core, eventData, plugin)
    core.settings.x = core.settings.x + 1;
end

function postuf(core, eventData, plugin)

end

function shutdownf(core, eventData, plugin)

end