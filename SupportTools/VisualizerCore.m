classdef VisualizerCore < hgsetget
    % VisualizerCore version 1.0 (dev)
    % Core function for LRAM Visualizer. Manipulates base information on
    % the robot used by various sub-programs.
    %    
    properties
        name
        % Name for referring to a visualizer core object. Mainly for future
        % use, but the visualizer core so far supports only one robot.
        
        % Tracks relevant runtime data.
        program_handles
        
        % Keeps track of the file from which settings are loaded.
        settingsfile = []

        % Keeps track of the settings during runtime for the program.
        settings
        
        % Identifies all plugins connected to the core.
        plugins = [];
        
        % Identifies the handles of all open programs.
        gui_plugin_handles = [];
        
        
        % Specifies whether the program will display debugging messages.
        debug_mode = 0;
    end

    methods
        function obj = VisualizerCore()
            % Constructor method.
            obj.program_handles.core = obj;
        end
        
        function Shutdown(obj)
            %Shuts down the Visualizer Core
            if (obj.debug_mode)
                disp('## Core Shutting Down ##');
            end
            notify(obj,'ShutdownEvent');
        end
        
        
        function LoadSettings(obj)
            % Loads settings to the Visualizer Core.
            if (obj.debug_mode)
                disp('## Core loading stored settings ##');
            end
            
            if isempty(obj.settingsfile)
                error('No settings to load.');
            end
            obj.LoadSettingsFrom(obj.settingsfile)
            notify(obj,'UpdateEvent');
        end
        
        function LoadSettingsFrom(obj,filename)
            % Loads a set of settings into the core from a file.
            if (obj.debug_mode)
                fprintf('## Core loading settings from [%s]\n',filename);
            end
            obj.settingsfile =  filename;
            obj.settings = load(obj.settingsfile);
        end
        
        function SaveSettingsTo(obj, filename)
            % Saves a set of settings to a specified file path            
            if (obj.debug_mode)
                fprintf('## Core saving settings to [%s]\n',filename);
            end            
            settings = obj.settings;
            save(filename,'-struct','settings');
        end
        
    end
    events
        UpdateEvent
        % Every program using viscore to get and set information about the
        % visualizer must listen to the VisualizerCore 'Update' event.
        ShutdownEvent
        % To be defined in future programs. Hopefully, this can shut down
        % any program that is being used by the visualizer, or at least
        % send a signal that the core object is no longer available.
        TestMessageEvent
        % For testing event listeners. Nothing important should be done
        % with this.
    end   
end
