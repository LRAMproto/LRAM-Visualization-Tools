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
        
        function UpdateVisual(self, mtx)
            
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
        end
        
        function SetColor(self, color)
            self.color = color;
        end
        
        function ApplyPatchTForm(self, data)
            pat = self.visual;
            
            if data.hasChanged
                fprintf('... Update...\n');
                points = [];
                
                for k=1:length(data.xdata)
                    points = [points; [data.xdata(k),data.ydata(k)]];
                end
                TOriginR = makehgtform('zrotate',data.originRotate(3));
                TOrigin = makehgtform('translate',data.origin);
                R = makehgtform('zrotate',data.zrotate);
                T = makehgtform('translate',data.pivotPoint);
                M = T * R * inv(T) * TOrigin * TOriginR;
                
                newxdata = [];
                newydata = [];
                
                for k=1:size(points,1)
                    newPoint = M * [points(k,1:2) 0 1]';
                    newPoint = newPoint';
                    newxdata = [newxdata, newPoint(1)];
                    newydata = [newydata, newPoint(2)];
                end
                
                set(pat,'xdata',newxdata,'ydata',newydata)
                data.hasChanged = false;
            else
                fprintf('... Not Updated...\n');
            end
            
        end
        
    end
    
end

