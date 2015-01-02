classdef Link < hgsetget
    %LINK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        parent = []
        transMtx = makehgtform()
        xdata = []
        ydata = []
        zdata = []
        origin = [0,0,0]
        scale = [1,1,1]
        xrotate = 0
        yrotate = 0
        zrotate = 0
        children = []
    end
    
    methods              
        
        function self = Link(varargin)
            if nargin > 0
                self.parent = varargin{1};
                self.parent.children = [self.parent.children, self];                
            end
        end
        
        function UpdateVisual(self, mtx)        
            self.transMtx = mtx * makehgtform('translate',self.origin) ...
                * makehgtform('xrotate',self.xrotate)...
                * makehgtform('yrotate',self.xrotate)...
                * makehgtform('zrotate',self.xrotate)...
                ;
            
            for i = 1:length(self.children)
                self.children(i).UpdateVisual(self.transMtx)            
            end
        end
        
        function points = GetWorldPoints(self)            
        end
    end
    
end

