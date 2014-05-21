classdef VisualizerCore < handle
    % VisualizerCore version 0.1 (dev)
    % Core function for LRAM Visualizer. Manipulates base information on
    % the robot used by various sub-programs.
    %
    % This class is initially called by the GUI function, 'viscore'.
    
    properties
        name
        % Name for referring to a visualizer core object. Mainly for future
        % use, but the visualizer core so far supports only one robot.
        settings
    end

    methods
        function obj = VisualizerCore(name)
            % Initializes the VisualizerCore object.
            obj.name = name;
        end
    end
    events
        Update
        % Every program using viscore to get and set information about the
        % visualizer must listen to the VisualizerCore 'Update' event.
        Shutdown
        % To be defined in future programs. Hopefully, this can shut down
        % any program that is being used by the visualizer, or at least
        % send a signal that the core object is no longer available.
        TestMessage
        % For testint event listeners. Nothing important should be done
        % with this.
    end   
end
