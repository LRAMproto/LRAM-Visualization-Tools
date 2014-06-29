classdef VisualizerPlugin < hgsetget
    % An experimental class to manage the operations of an individual
    % plugin for the visualizer core.
    
    % If implemented, creating additional plugins would be much easier to
    % do.
    
    properties
        % Tracks handles of entire program.
        programHandles
        
        % Uniquely identifying name of program.
        name
        
        % Core
        core
        
        % figure handle used for creating visual elements
        guiHandle
        guiFcn
        
        % Core Listener
        updateListener;
        shutdownListener;              

        debugMode = 0;
        
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
            obj.updateListener = addlistener(obj.core,'UpdateEvent',@obj.ViscoreUpdate);
            obj.shutdownListener = addlistener(obj.core,'ShutdownEvent',@obj.ViscoreShutdown);
        end      
        
        function AddToPlugins(obj)
            if(obj.debugMode)
                fprintf('* Adding plugin [%s] to core plugins.\n',obj.name);
            end
            
            obj.core.plugins = [obj.core.plugins,obj];
            %obj.programHandles.core.plugins(length(obj.programHandles.core.plugins)+1) = handle(obj);
            
        end
        
        function LoadGui(obj)
            % Loads the GUI pointed to by the plugin.
            obj.guiFcn(obj.core.programHandles);
        end
        
        
        %% Visualizer Event Functions
        
        function obj = ViscoreUpdate(obj,core,eventdata)
            if (obj.debugMode)
               fprintf('* [%s] hears update from core.\n',obj.name);
            end

            if ~isempty(obj.update_fcn)
                % execute assigned shutdown function
                obj.update_fcn(core, eventdata);
            end
            
        end
        
        function obj = ViscoreShutdown(obj,core,eventdata)
            if (obj.debugMode)
               fprintf('* [%s] hears shudown from core.\n',obj.name);
            end
            
            if ~isempty(obj.shutdown_fcn)
                % execute assigned shutdown function
                obj.shutdown_fcn(core, eventdata);
            end           
            
        end
            
    end
    
end

