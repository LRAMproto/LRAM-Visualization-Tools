function caster_block_update(block)

setup(block)

end

function setup(block)
block.NumInputPorts = 1;
block.NumOutputPorts = 0;
block.RegBlockMethod('Update',@Update);
end

function Update(block)
% Runs during simulation update. Nothing happens if no plugin is connected.
plugin = get_param(gcb,'UserData');
if ~isempty(plugin)
    arm_joint = findobj(plugin.core.settings.CastingRobot.joints,'name','Arm Joint');
    arm_joint.Rotate(block.InputPort(1).Data);
    notify(plugin.core,'UpdateEvent');
end
end