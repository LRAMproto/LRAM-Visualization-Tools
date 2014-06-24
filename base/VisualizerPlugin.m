classdef VisualizerPlugin < hgsetget
    % An experimental class to manage the operations of an individual
    % plugin for the visualizer core.
    
    % If implemented, creating additional plugins would be much easier to
    % do.
    
    properties
        % Tracks handles of entire program.
        program_handles
        
        % Uniquely identifying name of program.
        name
        
        % Core
        core
        
        % figure handle used for creating visual elements
        gui_handle
        gui_fcn
        
        % Core Listener
        update_listener;
        shutdown_listener;              

        debug_mode = 0;
        
        % Runtime defined functions for updating and shutting down
        update_fcn;
        shutdown_fcn;
        
    end
    
    methods
        function obj = VisualizerPlugin(name,core)
            results = findobj(core.plugins,'name',name);
            if (numel(results)>0)
                error('* Running plugin already exists with this name');
            end
            obj.core = core;
            
            obj.name = name;
            obj.update_listener = addlistener(obj.core,'UpdateEvent',@obj.ViscoreUpdate);
            obj.shutdown_listener = addlistener(obj.core,'ShutdownEvent',@obj.ViscoreShutdown);
        end      
        
        function AddToPlugins(obj)
            if(obj.debug_mode)
                fprintf('* Adding plugin [%s] to core plugins.\n',obj.name);
            end
            
            obj.core.plugins = [obj.core.plugins,obj];
            %obj.program_handles.core.plugins(length(obj.program_handles.core.plugins)+1) = handle(obj);
            
        end
        
        function LoadGui(obj)
            % Loads the GUI pointed to by the plugin.
            obj.gui_fcn(obj.core);
        end
        
        
        %% Visualizer Event Functions
        
        function obj = ViscoreUpdate(obj,core,eventdata)
            if (obj.debug_mode)
               fprintf('* [%s] hears update from core.\n',obj.name);
            end

            if ~isempty(obj.update_fcn)
                % execute assigned shutdown function
            end
            
        end
        
        function obj = ViscoreShutdown(obj,core,eventdata)
            if (obj.debug_mode)
               fprintf('* [%s] hears shudown from core.\n',obj.name);
            end
            
            if ~isempty(obj.shutdown_fcn)
                % execute assigned shutdown function
            end           
            
        end
            
    end
    
end

