classdef VisualizerCore < handle
    %VISUALIZERCORE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name
        guifcn
        settings
    end
    
    methods
        function obj = VisualizerCore(name)
            obj.name = name;
        end
        
        function showGUI(obj)
            eval(obj.guifcn);
        end
        
        function loadControl(obj,guifcn)
            eval(guifcn);
        end;             
    end
    events
        Update
        Close
        TestMessage % Tests event listener.
    end   
end
