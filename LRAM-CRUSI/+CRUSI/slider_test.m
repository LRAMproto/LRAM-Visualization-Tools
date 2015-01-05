function slider_test(plugin)
%SLIDER_TEST Summary of this function goes here
%   Detailed explanation goes here

fig = init(plugin);
end

function testfunct(menu, eventdata)
fig = get(get(menu, 'parent'),'parent');
h = guidata(fig);
RDTools.gen_layer_menu(h.layers);
end

function fig = init(plugin)


fig = figure('name','Control Panel','menubar','none');
f = uimenu('label','workspace');
uimenu(f, ...
    'label', 'a',...
    'callback',@testfunct);

plugin.ConnectGui(fig);

h = struct();
L = RDTools.Layer(plugin.core.settings.robot.displayAxis);
set(L, 'name', 'Test');
h.layers = [L, L];

h.plugin = plugin;
h.servolabels = [];
h.servosliders = [];

for k=1:length(plugin.core.settings.robot.servos)
   disp('joint detected');
   
   data.plugin = plugin;
   %data.joint = plugin.core.settings.robot.joints(k);
   data.joint = plugin.core.settings.robot.servos(k).joint;
   data.servo = plugin.core.settings.robot.servos(k);
   
   %pnl = uipanel('parent',f,'position',[40*k, 0, 40, 400]);
   
   lbl = uicontrol(...
       'style','text',...
       'position',[40*k, 400, 40, 20],...
       'string',data.servo.Measure('position'));
   ctrl = uicontrol(...
       'parent', fig, ...
       'style','slider',...
       'position',[40*k, 0, 40, 400],...
       'callback',@SliderCallback,...
       'max',deg2rad(180),...
       'min',deg2rad(-180),...
       'value',data.servo.Measure('position'),...
...%       'value',get(data.joint,'zRotate'),...
       'UserData', data...
);
%    disp(ctrl);

   addlistener(ctrl,'ContinuousValueChange',@SliderCallback);

    h.servosliders = [h.servosliders, ctrl];
    h.servolabels = [h.servolabels, lbl];
    
    disp('successfully set userdata');    
    
end

set(plugin, 'postUpdateFcn',@UpdateInterface);

guidata(fig, h);

end

function UpdateInterface(core, eventdata, plugin)
    fig = plugin.guiPluginHandle;
%    fprintf('Handle of %s\n', plugin.name);
%    disp(fig);
    h = guidata(fig);
    disp(h);
    for k=1:length(h.servolabels)
       set(h.servolabels(k), 'string',num2str(core.settings.robot.servos(k).Measure('position'))); 
    end
    

end

function SliderCallback(slider, eventdata)
    data = get(slider, 'userdata');
%    data.joint.SetZRotate(get(slider,'value'));
    data.servo.UpdateParam('position',get(slider, 'value'));
    notify(data.plugin.core,'PostUpdateEvent');
    
%    disp(data.joint);
    
end


