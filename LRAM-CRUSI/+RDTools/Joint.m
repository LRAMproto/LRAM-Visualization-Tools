classdef Joint < hgsetget
    %JOINT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        parent = [];
        children = [];
        origin = [0 0 0];
        pivotPoint = [0 0 0];
        zRotate = 0;
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
        
        function SetOrigin(self, origin)
           self.origin = origin; 
        end
        
        function SetPivotPoint(self, pivotPoint)
           self.pivotPoint = pivotPoint; 
        end
        
        function UpdateVisual(self, mtx)
            TOrigin = makehgtform('translate',self.origin);
            ZRotate = makehgtform('zrotate',self.zRotate);
            mtx = mtx * ZRotate * TOrigin;
            
            for k=1:length(self.children)
                self.children(k).UpdateVisual(mtx);
            end
        end
        
        function SetZRotate(self, val)
            self.zRotate = val;
        end
    end
    
end

