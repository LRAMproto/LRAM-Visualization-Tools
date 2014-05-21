function handles = viscore_connect(guifcn)
% Version 0.1 (dev)
% This function serves as a standard method of connecting to the visualizer
% core program, assuming everything has been properly structured.
%
% Parameters:
%
% GUIFCN (figure) = handle of GUI object.
% Tries to find the viscore GUI
results = findall(0,'Name','lram viscore');
if (numel(results) == 0)
    error('viscore has not been initialized.');
else
    handles = guidata(guifcn);
    fprintf('Connecting gui function [%s] to viscore\n',get(guifcn,'Name'));
    handles.core = get(results(1),'UserData');
    handles.corelistener = addlistener(handles.core,'Update',@handles.ViscoreUpdate);
    handles.shutdownlistener = addlistener(handles.core,'Shutdown',@handles.ViscoreShutdown);
    notify(handles.core,'Update');
end
end

