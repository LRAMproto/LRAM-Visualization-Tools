classdef Link < hgsetget
    % A class which defines robot shapes. Inherits from hgsetget to allow
    % for set() functions and get() functions to work appropriately.
    
    properties
        % Sets properties for every Link object.
        
        %% Statically Defined Variables
        
        % Uniquely identifying name.
        name = 'Default';
        % Type of link; usually Rectangle, Circle, or Custom
        type = 'Undefined';
        % Width of visual element of the link; not always used but
        % sometimes helpful;

        %% Sets geometry of link objects
        width = 0;
        % Height of visual element of the link.
        height = 0;
        % In the case of circles, this specifies data about the radius of
        % the circle.
        radius = 0;
        
        %% Specifies how link objects should be rendered visually.
        % Origin at which the link is drawn. A square drawn at 0,0 will be
        % drawn with the center of the square at 0,0, with respect to the
        % relative position of the square.
        origin = [0,0];
        % Angle at which the joint is drawn by default.
        origin_angle = 0;
        % Specifies where the object is rotated.
        origin_angle_pivot_point = [0 0];
        % FIXME: Deprecate the 'current position' of the link, as this
        % isn't used.
        current_position = [0 0];
        % specifies the curvature of drawn objects.
        cap_pct = 0;
        
        % specifies how many vertices to give the visual component of the
        % object.
        num_points = 100;
        
        % Sets the fill color of the patch that is used. It defaults to
        % black, but can be set to anything.

        fillcolor = [0 0 0];
        
        %% Runtime Defined Variables
        % Tracks where the runtime object
        visual = [];
        % tracks the xdata and ydata of the visual patch object.
        vertices = struct('xdata',[],'ydata',[]);
        
        % TODO: Define optimization steps in the World class that take
        % advantage of current_vertices and previous_vertices
        
        current_vertices = struct('xdata',[],'ydata',[]);
        previous_vertices = struct('xdata',[],'ydata',[]);
        
        % TODO: Define behavior when one of the links is clicked.
        % FIXME: Make buttondownfcn consistent with the rest of the program
        % variables.
        buttondownfcn = [];
        

    end
    
    methods
        %% Sets Variables
        
        function obj = set.radius(obj,val)
            if val < 0
                error('Radius must be zero or greater.');
            end
            obj.radius = val;
            set(obj,'width',val*2);
            set(obj,'height',val*2);
        end

        function obj = set.width(obj,val)
            if val < 0
                error('Width must be zero or greater.');
            end
            obj.width = val;
        end        

        function obj = set.height(obj,val)
            if val < 0
                error('Height must be zero or greater.');
            end
            obj.height = val;
        end        

        
        function GeneratePoints(obj,varargin)
            % Generates a set default set of coordinates for the link out
            % of shape data.

            switch obj.type
                case 'Custom'
                    if length(varargin) == 2;
                        obj.vertices.xdata = custom_x;
                        obj.vertices.ydata = custom_y;
                    end                   
                case 'Rectangle'
                    [obj.vertices.xdata, obj.vertices.ydata] = squashed_rectangle_continuous(obj.width, obj.height, obj.cap_pct, obj.num_points);
                case 'Circle'
                    [obj.vertices.xdata,obj.vertices.ydata] = squashed_rectangle_continuous(obj.radius*2, obj.radius*2, 1, obj.num_points);
            end
            
        end
        % TODO: Delete deprecated Link methods to eliminate redundancy and
        % confusion.
        
        function MoveTo(obj,destination)
            % Moves the visual element of a link to a given point.
            % Deprecated. This should be moved to the Joint class so that a
            % joint defines where a link goes instead of a link.
            
            obj.current_position = destination;
            set(obj.visual,...
                'XData',obj.vertices.xdata+obj.current_position(1),...
                'YData',obj.vertices.ydata+obj.current_position(2));            
        end
        
    end
    
end

