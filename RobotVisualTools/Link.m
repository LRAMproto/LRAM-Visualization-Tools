classdef Link < hgsetget
    % A class which defines robot shapes. Inherits from hgsetget to allow
    % for set() functions and get() functions to work appropriately.
    
    properties
        % Sets properties for every Link object.
        
        %% Statically Defined Variables
        
        % Human Readable Name
        name = 'Default';
        % DEPRECATE: Uniquely identifying name.
        tag = 'Undefined';
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
        originAngle = 0;
        
        % Specifies where the object is rotated.
        originAnglePivotPoint = [0 0];
        
        % specifies the curvature of drawn objects.
        cap_pct = 0;
        
        % specifies how many vertices to give the visual component of the
        % object.
        num_points = 100;
        
        % Sets the fill color of the patch that is used. It defaults to
        % black, but can be set to anything.        
        fillColor = [0 0 0];
        
        % Changes visibility. Recognized Values: 'on', 'off'
        visible = 'on';

        % Opacity of the patch object.
        % 1.0 = completely opaque
        % 0.5, 50% opacity,
        % 0.0 =  100% transparent.
        faceAlpha = 1;
        % Opacity of the edges of a patch.
        % 1.0 = completely opaque
        % 0.5, 50% opacity,
        % 0.0 =  100% transparent.
        edgeAlpha = 1;
        
        % Sets the line width of all points. Must be greater than zero.
        lineWidth = 0.5;
        
        %% Runtime Defined Variables

        % Tracks the runtime object of a patch in Figure Axes.
        visual = [];
        
        % tracks the xdata and ydata of the visual patch object.
        vertices = pkg_vertices();
        
        % Tracks the current vertices
        currentVertices = pkg_vertices();

        % Tracks the previous vertices.
        previousVertices = pkg_vertices();
        
        %Define behavior when one of the links is clicked.        
        buttonDownFcn = [];
        
        % Robot object.
        robot
        
        % World that the link belongs to.
        world
        
        % Tracks a set of points relative to a link's local position.
        trackingPoints = [];
        
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
        
        function obj = set.fillColor(obj,val)
            obj.fillColor = val;
            if ~isempty(obj.visual)
                set(obj.visual,'FaceColor',val);
            end
            
        end      
        
        function GeneratePoints(obj,varargin)
            % Generates a set default set of coordinates for the link out
            % of shape data.
            
            switch obj.type
                case 'Custom'
                    if length(varargin) == 2;
                        xdata = custom_x;
                        ydata = custom_y;
                        set(obj,'vertices',pkg_vertices(xdata,ydata));
                    end
                    
                case 'Rectangle'
                    if (obj.cap_pct == 0)
                        obj.num_points = 4;
                    end
                    [xdata,ydata] = squashed_rectangle_continuous(...
                        obj.width,...
                        obj.height,...
                        obj.cap_pct,...
                        obj.num_points);
                    set(obj,'vertices',pkg_vertices(xdata,ydata));
                case 'Circle'
                    [xdata,ydata] = squashed_rectangle_continuous(...
                        obj.radius*2,...
                        obj.radius*2,...
                        1,...
                        obj.num_points);
                    set(obj,'vertices',pkg_vertices(xdata,ydata));
            end
            
            
        end
        % TODO: Delete deprecated Link methods to eliminate redundancy and
        % confusion.
        
        function ToggleVisibility(obj)
            % Changes visibility of a joint object.
            if strcmp(obj.visible,'off')
                obj.visible = 'on';
                set(obj.visual,'visible','on');
            elseif strcmp(obj.visible,'on')
                obj.visible = 'off';
                set(obj.visual,'visible','off');
            end
            
        end
        
        function MoveTo(obj,destination)
            % Moves the visual element of a link to a given point.
            % Deprecated. This should be moved to the Joint class so that a
            % joint defines where a link goes instead of a link.
            
            obj.currentPosition = destination;
            set(obj.visual,...
                'XData',obj.vertices.xdata+obj.currentPosition(1),...
                'YData',obj.vertices.ydata+obj.currentPosition(2));
        end
        
        function AddTrackingPoint(obj,name,position)
            % Adds a new tracking point to the simulation/
            newpoint = TrackingPoint();
            set(newpoint,...
                'name',name,...
                'parentLink',obj,...
                'localPosition',position);
            obj.trackingPoints = union(obj.trackingPoints,newpoint);
        end
        
    end
    
end

