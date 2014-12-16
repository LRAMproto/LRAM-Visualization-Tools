classdef Link < hgsetget
    %LINK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        shapeType = [];
        dims = [];
        xdata = [];
        ydata = [];
        zdata = [];
        childJoints = [];
        visual = [];
        color = [0 0 0];
    end
    
    methods
        
        function AddChild(self, joint)
           assert(isa(joint,'RDTools.Joint'));     
           self.childJoints = [self.childJoints, joint]; 
        end
        function SetShape(self, name, varargin)
            assert(isa(name, 'char'));
            self.shapeType = name;
            self.dims = varargin{1};
            self.GenShapeData();
        end
        
        function GenVisual(self, ax)
            self.visual = patch(...
                'parent',ax,...
                'xdata',self.xdata,...
                'ydata',self.ydata,...
                'facecolor',self.color...
            );
        
            for k = 1:length(self.childJoints)
               self.childJoints(k).GenVisual(ax);
            end
        end
        
        function GenShapeData(self)
            assert(~isempty(self.shapeType));
            assert(~isempty(self.dims));

            xData = [];
            yData = [];
            
            switch(self.shapeType)
                case 'square'
                    assert(length(self.dims) == 1);
                    xData = [-1 1 1 -1]*self.dims(1)/2;
                    yData = [-1 -1 1 1]*self.dims(1)/2;
                case 'rectangle'
                    assert(length(self.dims) == 2);
                    xData = [-1 1 1 -1]*self.dims(1)/2;
                    yData = [-1 -1 1 1]*self.dims(2)/2;                   
                    
            end                    
            
            self.xdata = xData;
            self.ydata = yData;
        end
        
        function SetColor(self, color)
            self.color = color;
        end
        
    end
    
end

