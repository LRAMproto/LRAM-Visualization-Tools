classdef Layer < hgsetget
    %LAYER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        displayAxis = [];
        visuals = [];
        visibility = 'on';
        name = 'untitled';
    end
    
    methods
        function self = Layer(ax)
           self.displayAxis = ax; 
        end
        
        function AddVisual(self, visual)
            self.visuals = union(self.visuals, visual);
        end
        
        function SetVisibility(self, val)
            switch(val)
                case 'on'
                    self.visibility = 'on';
                    for k=1:length(self.visuals)
                        set(self.visuals(k),'visible','on');
                    end                    
                case 'off'
                    self.visibility = 'off';
                    for k=1:length(self.visuals)
                        set(self.visuals(k),'visible','off');
                    end
            end
        end
        
        function result = IsVisible(self)
            switch(self.visibility)
                case 'on'
                    result = true;
                case 'off'
                    result = false;
            end        
        end
    end
    
end

