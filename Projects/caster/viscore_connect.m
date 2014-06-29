function handles = viscore_connect(guifcn,core)
% Version 0.2 (dev)
% This function serves as a standard method of connecting to the visualizer
% core program, assuming everything has been properly structured.
%
% Parameters:
%
% GUIFCN (figure) = handle of GUI connecting to the visualizer core.
% CORE = VisualizerCore object
% Tries to find the viscore GUI

    % Appends plugins 
    core.guiPluginHandles(length(core.guiPluginHandles)+1) = guifcn; 
    
    handles = guidata(guifcn);
    fprintf('Connecting gui function [%s] to viscore\n',get(guifcn,'Name'));
    handles.core = core;
    notify(handles.core,'UpdateEvent');
    guidata(guifcn, handles);

end

