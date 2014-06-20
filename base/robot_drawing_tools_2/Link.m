classdef Link < hgsetget
    %A class which defines robot shapes.
    
    properties
        name = 'Default';
        type = 'Undefined';
        width = 0;
        height = 0;
        origin = [0,0];
        origin_angle = 0;
        origin_angle_pivot_point = [0 0];
        current_position = [0 0];
        radius = 0;
        vertices = struct('xdata',[],'ydata',[]);
        current_vertices = struct('xdata',[],'ydata',[]);
        cap_pct = 0;
        num_points = 100;
        fillcolor = [0 0 0];
        visual = [];
        

    end
    
    methods
        function MoveTo(obj,destination)
            obj.current_position = destination;
            set(obj.visual,...
                'XData',obj.vertices.xdata+obj.current_position(1),...
                'YData',obj.vertices.ydata+obj.current_position(2));            
        end
        
        function GeneratePoints(obj,varargin)
            switch obj.type
                case 'Custom'
                    if length(varargin) == 2;
                        obj.vertices.xdata = custom_x;
                        obj.vertices.ydata = custom_y;
                    end                   
                case 'Rectangle'
                    [obj.vertices.xdata, obj.vertices.ydata] = squashed_rectangle_continuous(obj.width,+ obj.height, obj.cap_pct, obj.num_points);
                case 'Circle'
                    [obj.vertices.xdata,obj.vertices.ydata] = squashed_rectangle_continuous(obj.radius*2, obj.radius*2, 1, obj.num_points);
            end
            
        end
        
    end
    
end

