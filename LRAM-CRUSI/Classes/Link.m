classdef Link < hgsetget
    %LINK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        parent = []
        transMtx = makehgtform()
        
        xdata = [-1,5,5,-1];
        ydata = [-1,-1,1,1]*.25;
        zdata = [0,0,0,0];

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
                * makehgtform('yrotate',self.yrotate)...
                * makehgtform('zrotate',self.zrotate)...
                ;
            
            for i = 1:length(self.children)
                self.children(i).UpdateVisual(self.transMtx)            
            end
        end
        
        function [xdata, ydata, zdata] = GetWorldPoints(self)
            
            xdata = zeros(1,length(self.xdata));
            ydata = zeros(1,length(self.ydata));
            zdata = zeros(1,length(self.zdata));            
            
            for k = 1:length(self.xdata)
                vtx = ...
                    self.transMtx * ...
                    [...
                    self.xdata(k);...
                    self.ydata(k);...
                    self.zdata(k)...
                    ;...
                    1 ...
                    ];
                vtx = vtx';
                xdata(k) = vtx(1);
                ydata(k) = vtx(2);
                zdata(k) = vtx(3);
                
            end
        end
    end
    
end

