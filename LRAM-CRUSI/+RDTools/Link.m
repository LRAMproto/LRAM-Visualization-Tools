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
        alpha = 1;
        capPct = 0;
        numPoints = 100;
        
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
                'facealpha',self.alpha,...
                'facecolor',self.color...
                );
            
            for k = 1:length(self.childJoints)
                self.childJoints(k).GenVisual(ax);
            end
        end
        
        function SetCapPct(self, pct)
            self.capPct = pct;
        end
        
        function GenShapeData(self)
            assert(~isempty(self.shapeType));
            assert(~isempty(self.dims));
            
            xData = [];
            yData = [];
            
            if (self.capPct > 0)
                self.numPoints = 100;
            end
            
            switch(self.shapeType)
                case 'square'
                    [xData, yData] = ...
                        squashed_rectangle_continuous(...
                        self.dims(1), self.dims(1), self.capPct, self.numPoints ...
                        );
                case 'rectangle'
                    assert(length(self.dims) == 2);
                    [xData, yData] = ...
                        squashed_rectangle_continuous(...
                        self.dims(1), self.dims(2), self.capPct, self.numPoints ...
                        );
                case 'circle'
                    assert(length(self.dims) == 1);
                    [xData, yData] = ...
                        squashed_rectangle_continuous(...
                        self.dims(1)*2, self.dims(1)*2, 1, self.numPoints ...
                        );
                    
            end
            
            self.xdata = xData;
            self.ydata = yData;
        end
        
        function UpdateVisual(self, mtx)
            
%            for m=1:size(self.xdata,1)
%                disp('going through visual update')
                points = [];
                
                for k=1:length(self.xdata)
                    points = [points; [self.xdata(k),self.ydata(k)]];
                end
                
                newxdata = [];
                newydata = [];
                
                for k=1:size(points,1)
                    newPoint = mtx * [points(k,1:2) 0 1]';
                    newPoint = newPoint';
                    newxdata = [newxdata, newPoint(1)];
                    newydata = [newydata, newPoint(2)];
                end
                
                
                
                set(self.visual,'xdata',newxdata,'ydata',newydata)
                
                for k=1:length(self.childJoints)
                    self.childJoints(k).UpdateVisual(mtx);
                end
%            end
        end
        
        function SetColor(self, color)
            self.color = color;
        end
        
        
    end
    
end

