function caster_block_update(block)

setup(block)

end

function setup(block)
block.NumInputPorts = 1;
block.NumOutputPorts = 0;
block.RegBlockMethod('Update',@Update);
end

function Update(block)
plugin = get_param(gcb,'UserData');
arm_joint = findobj(plugin.core.settings.CastingRobot.joints,'name','Arm Joint');
arm_joint.Rotate(block.InputPort(1).Data);
notify(plugin.core,'UpdateEvent');
end