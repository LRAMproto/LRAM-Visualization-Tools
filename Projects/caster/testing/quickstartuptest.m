function [ output_args ] = quickstartuptest( input_args )
% starts application, then closes all windows after two seconds.
caster_startup;
pause(1);
close all force;
end

