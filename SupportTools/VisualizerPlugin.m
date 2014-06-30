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
        
        guiPluginHandle
        
        % Core
        core
        
        % figure handle used for creating visual elements
        guiHandle
        guiFcn
        
        % Core Listener
        updateListener;
        
        postUpdateListener;
        
        shutdownListener;
        
        debugMode = 0;
        
        % Runtime defined functions for updating and shutting down
        
        updateFcn;
        
        postUpdateFcn;
        
        shutdownFcn;
        
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
            obj.postUpdateListener = addlistener(obj.core,'PostUpdateEvent',@obj.ViscorePostUpdate);
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
            obj.guiFcn(obj);
        end
        
        function ConnectGui(obj,guiHandle)
            obj.core.guiPluginHandles(length(obj.core.guiPluginHandles)+1) = guiHandle;
            obj.guiPluginHandle = guiHandle;
            notify(obj.core,'UpdateEvent');
        end
        
        %% Visualizer Event Functions
        
        function obj = ViscoreUpdate(obj,core,eventdata)
            if (obj.debugMode)
                fprintf('* [%s] hears update from core.\n',obj.name);
            end
            
            if ~isempty(obj.updateFcn)
                % execute assigned shutdown function
                obj.updateFcn(core, eventdata);
            end
            
        end
        
        function obj = ViscoreShutdown(obj,core,eventdata)
            if (obj.debugMode)
                fprintf('* [%s] hears shudown from core.\n',obj.name);
            end
            
            if ~isempty(obj.shutdownFcn)
                % execute assigned shutdown function
                obj.shutdownFcn(core, eventdata);
            end
        end
        
        function obj = ViscorePostUpdate(obj,core,eventdata)
            if (obj.debugMode)
                fprintf('* [%s] hears post update from core.\n',obj.name);
            end
            
            if ~isempty(obj.postUpdateFcn)
                % execute assigned shutdown function
                obj.postUpdateFcn(core, eventdata);
            end
            
        end
        
    end
    
end

