classdef Link < hgsetget
    %LINK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties        
        % URDF-Specific Stats
        name = [];
        
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
        shapeData = [];
    end
    
    methods
        
        function obj = Link(parent_joint)
            if exist('parent_joint', 'var')
                parent_joint.AddChild(obj);
            end
        end
        
        function AddChild(self, joint)
            assert(isa(joint,'RDTools.Joint'));
            self.childJoints = [self.childJoints, joint];
        end
        
        function SetShape(self, name, varargin)
            assert(isa(name, 'char'));
            self.shapeType = name;
            self.shapeData = varargin;
            self.dims = varargin{1};
            self.GenShapeData();
        end
        
        function GenVisual(self, ax)
            disp('Generating Visual');
            disp(self.xdata);
            disp(self.ydata);
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
                case 'custom'
                    disp('custom shape entered');
                    xData = self.shapeData{1};
                    disp(size(xData));
                    yData = self.shapeData{2};
                    disp(size(yData));
                case 'square'
                    [xData, yData] = ...
                        squashed_rectangle_continuous(...
                        self.dims(1), self.dims(1), self.capPct, self.numPoints ...
                        );
                    xData = xData';
                    yData = yData';
                case 'rectangle'
                    assert(length(self.dims) == 2);
                    [xData, yData] = ...
                        squashed_rectangle_continuous(...
                        self.dims(1), self.dims(2), self.capPct, self.numPoints ...
                        );
                    xData = xData';
                    yData = yData';
                    
                case 'circle'
                    assert(length(self.dims) == 1);
                    [xData, yData] = ...
                        squashed_rectangle_continuous(...
                        self.dims(1)*2, self.dims(1)*2, 1, self.numPoints ...
                        );
                    xData = xData';
                    yData = yData';
                    
            end
            
            self.xdata = xData;
            self.ydata = yData;
        end
        
        function UpdateVisual(self, mtx)
            newxdata = [];
            newydata = [];
            for m=1:size(self.xdata,1)
                disp('going through visual update')
                points = [];
                
                for k=1:length(self.xdata)
                    points = [points; [self.xdata(m,k),self.ydata(m,k)]];
                end
                
                newxdataP = [];
                newydataP = [];
                
                for k=1:size(points,1)
                    newPoint = mtx * [points(k,1:2) 0 1]';
                    newPoint = newPoint';
                    newxdataP = [newxdataP, newPoint(1)];
                    newydataP = [newydataP, newPoint(2)];
                end
                newxdata = [newxdata; newxdataP];
                newydata = [newydata; newydataP];

            end
                disp(size(newxdata));
                disp(size(newydata));            
            set(self.visual,'xdata',newxdata,'ydata',newydata)
            
            for k=1:length(self.childJoints)
                self.childJoints(k).UpdateVisual(mtx);
            end
        end
        
        function SetColor(self, color)
            self.color = color;
        end
        
        
    end
    
end

