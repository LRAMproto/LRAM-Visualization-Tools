function servocontroller(block)
setup(block)
end

function setup(block)
block.NumInputPorts = 4;
block.NumOutputPorts = 4;
block.RegBlockMethod('SetInputPortSamplingMode',@SetInputPortSamplingMode);
end


function SetInputPortSamplingMode(block)
    mode = 0;
    block.InputPortSamplingMode = mode;
end