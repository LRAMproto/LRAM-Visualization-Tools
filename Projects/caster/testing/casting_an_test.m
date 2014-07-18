function casting_an_test
previous = pwd;
cd(fileparts(mfilename('fullpath')))

ph = caster_startup_debug_display_only;
% Turning off fig window as we don't need to render it.
% set(ph.Plugins.Display.guiPluginHandle,'visible','off');

an = Animation('CastAnTest',...
    fullfile(pwd,'frames'),...
    ph.Plugins.Display.guiPluginHandle);

% Finds Arm joint for fast modification
userdata.world = ph.core.settings.world();
set(userdata.world.displayAxis,'XLim',[-0.5 1],'YLim',[.75, 1.75]);
userdata.arm_joint = findobj(ph.core.settings.CastingRobot.joints,'name','Arm Joint');

if (isempty(userdata.arm_joint))
    error('Cant find arm joint.');
end    
set(an,...
    'userData',userdata,...
    'videoFile',fullfile(pwd,'caster_test_video_2.avi'),...
    'updateFcn',@frameUpdateFcn);
fprintf('Beginning Rendering\n');
for i=1:100
    an.RunUpdateFcn();
    an.RenderFrame();
end

fprintf('Rendering finished.\n');
fprintf('Outputting to Video.\n');
an.OutputToVideo();
fprintf('Video Output Finished.\n');

cd(previous);
% Turning off fig window as we don't need to render it.
% set(ph.Plugins.Display.guiPluginHandle,'visible','on');
end

function frameUpdateFcn(animation, frameNo)
    userdata = get(animation,'userData');
    userdata.arm_joint.Rotate(2*pi*(frameNo-1)/100);
    userdata.world.UpdateVisual();
end