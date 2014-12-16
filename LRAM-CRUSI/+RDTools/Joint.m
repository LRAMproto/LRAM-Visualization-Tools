classdef Joint < hgsetget
    %JOINT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        parent = [];
        children = [];
    end
    
    methods
        function AddChild(self, lnk)
            self.children = [self.children, lnk];
        end
        
        function SetParent(self, parent)
            self.parent = parent;
        end
        
        function GenVisual(self, ax)
           for k=1:length(self.children)
               self.children(k).GenVisual(ax);
           end
        end
        
    end
    
end

