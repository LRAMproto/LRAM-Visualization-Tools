classdef ProgramPlugin < hgsetget
    % This class allows for various sub-programs to connect to a
    % VisualizerCore object.
    
    properties
        
        % Uniquely identifying name of program.
        name
        
        guiPluginHandle
        
        % Core
        core
        
        % figure handle used for creating visual elements
        guiHandle
        
        % GUI function called by LoadGui().
        guiFcn
        
        % Core Listener
        
        preUpdateListener;
        
        updateListener;
        
        postUpdateListener;
        
        shutdownListener;
        
        debugMode = 0;
        
        % Runtime defined functions for updating and shutting down
        
        preUpdateFcn;
        
        updateFcn;
        
        postUpdateFcn;
        
        shutdownFcn;
        
    end
    
    methods
        function obj = ProgramPlugin(name,core)
            results = findobj(core.plugins,'name',name);
            if (numel(results)>0)
                error('* Running plugin already exists with this name');
            end
            obj.core = core;
            
            obj.name = name;

        end
        
        function AddToPlugins(obj)
            if(obj.debugMode)
                fprintf('* Adding plugin [%s] to core plugins.\n',obj.name);
            end
            % Registers event listeners.
            obj.preUpdateListener = addlistener(obj.core,'PreUpdateEvent',@obj.ViscorePreUpdate);
            obj.updateListener = addlistener(obj.core,'UpdateEvent',@obj.ViscoreUpdate);
            obj.shutdownListener = addlistener(obj.core,'ShutdownEvent',@obj.ViscoreShutdown);
            obj.postUpdateListener = addlistener(obj.core,'PostUpdateEvent',@obj.ViscorePostUpdate);            
            % Adds the plugin to the core.
            obj.core.plugins = union(obj.core.plugins,obj);
            
        end
        
        function RemoveFromPlugins(obj)
            if(obj.debugMode)
                fprintf('* Removing plugin [%s] from core plugins.\n',...
                    obj.name);
            end
            % Removes the plugin from the core.
            obj.core.plugins = setdiff(obj.core.plugins,obj);
            % Removes event listeners
            delete(obj.updateListener);
            delete(obj.shutdownListener);
            delete(obj.postUpdateListener);            
        end        
        
        function LoadGui(obj)
            % Loads the GUI pointed to by the plugin.
            obj.guiFcn(obj);
        end

        function CloseGui(obj)
            delete(obj.guiPluginHandle);
            obj.guiPluginHandle = [];
        end
        
        
        function ConnectGui(obj,guiHandle)
            obj.core.guiPluginHandles = union(obj.core.guiPluginHandles,guiHandle);
            obj.guiPluginHandle = guiHandle;
            notify(obj.core,'UpdateEvent');
        end        
        
        
        %% Visualizer Event Functions

        function obj = ViscorePreUpdate(obj,core,eventdata)
            if (obj.debugMode)
                fprintf('* [%s] hears pre update from core.\n',obj.name);
            end
            
            if ~isempty(obj.updateFcn)
                % execute assigned shutdown function
                obj.preUpdateFcn(core, eventdata, obj);
            end
        end                 
        
        function obj = ViscoreUpdate(obj,core,eventdata)
            if (obj.debugMode)
                fprintf('* [%s] hears update from core.\n',obj.name);
            end
            
            if ~isempty(obj.updateFcn)
                % execute assigned shutdown function
                obj.updateFcn(core, eventdata, obj);
            end
            
        end
        
        function obj = ViscoreShutdown(obj,core,eventdata)
            if (obj.debugMode)
                fprintf('* [%s] hears shudown from core.\n',obj.name);
            end
            
            if ~isempty(obj.shutdownFcn)
                % execute assigned shutdown function
                obj.shutdownFcn(core, eventdata, obj);
            end
        end
        
        function obj = ViscorePostUpdate(obj,core,eventdata)
            if (obj.debugMode)
                fprintf('* [%s] hears post update from core.\n',obj.name);
            end
            
            if ~isempty(obj.postUpdateFcn)
                % execute assigned shutdown function
                obj.postUpdateFcn(core, eventdata, obj);
            end
            
        end
        
    end
    
end

