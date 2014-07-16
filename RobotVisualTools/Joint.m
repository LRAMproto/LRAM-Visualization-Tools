classdef Joint < hgsetget
    % Creates an object which can control the movement of links connected
    % together.
    
    properties
        % Unique name for a link for searching purposes.
        name = [];
        rank = 1;
        tag = 'Undefined'
        % Link type.
        % * Fixed: No rotation
        % * Revolute: Rotates about X and Y
        % * Continuous: Translates accross x,y.
        % At the moment, no validation is done for joint types. If future
        % validation were important, than specifying the joint type might
        % be important.
        type = 'Fixed'
        %% Stores name of Link objects (not yet instantiated)
        parent
        child
        %% Stores data on where the joint is positioned,
        % Origin relative to parent link:
        origin = [0 0];
        % Pivot relative to joint.
        pivotPoint = [0, 0];
        % Position relative to joint
        position = [0 0];
        % Angle relative to joint
        angle = 0;
        %% Runtime Defined Variables:
        % These are created by the World() class during runtime, and should
        % not be altered.
        %
        
        % Stores data for parent and child links.
        parentData
        childData
        
        % Stores runtime object of parent joint for positioning purposes.
        parentJoint;
        
        % Robot object.
        robot
        
        % World in which it is populated.
        world
        
        % Default value: no transformations are given when the matrix
        % changes direction.
        
        localMatrix = eye(4,4);
        worldMatrix = eye(4,4);
        
    end
    
    methods
        function obj = set.name(obj,val)
            % Sets the name of the link. It seems reasonable to force this
            % to be a string.
            if isa(val,'char')
                obj.name = val;
            else
                error('Joint name must be a string');
            end
        end
        
        function MakeLocalMatrix(obj)
            % sets rotation stuff
            obj.localMatrix(1,1) = cos(obj.angle);
            obj.localMatrix(1,2) = sin(obj.angle);
            obj.localMatrix(2,1) = -sin(obj.angle);
            obj.localMatrix(2,2) = cos(obj.angle);
            % sets x pivot point
            obj.localMatrix(4,1)=obj.pivotPoint(1);
            % sets y pivot point
            obj.localMatrix(4,2)=obj.pivotPoint(2);            
            
        end
        
        function MakeWorldMatrix(obj)
            if isempty(obj.parentJoint);
                parentWorldMatrix = eye(4,4);
            else
                parentWorldMatrix = obj.parentJoint.worldMatrix;
            end
            obj.worldMatrix = obj.localMatrix * parentWorldMatrix;
        end        
        
        function Rotate(obj, theta)
            % Rotates the joint to a specific angle.
            obj.angle = theta;
            
            if ~isfloat(theta) && ~isequal(size(theta),[1 1]);
                error('angle invalid');
            end
            % TODO: Add checking of joint limits?
            
            if ~isempty(obj.world) && obj.world.autoUpdate == 1
                obj.world.UpdateVisual();
            end
            
        end
        
        function MoveY(obj,y)
            if ~isfloat(y) && ~isequal(size(y),[1 1]);
                error('y invalid');
            end
            % Moves a variable in the x position.
            % TODO: Add checking of joint limits?
            obj.position = [obj.position(1),y];
            if ~isempty(obj.world) && obj.world.autoUpdate == 1
                obj.world.UpdateVisual();
            end
        end
        
        function MoveX(obj,x)
            if ~isfloat(x) && ~isequal(size(x),[1 1]);
                error('x invalid');
            end
            % Moves a variable in the x position.
            % TODO: Add checking of joint limits?
            obj.position = [x,obj.position(2)];
            if ~isempty(obj.world) && obj.world.autoUpdate == 1
                obj.world.UpdateVisual();
            end
        end
        
        function MoveXY(obj,x,y)
            if isfloat([x,y]) && isequal(size([x,y]),[1,2])
                obj.position = [x,y];
                if ~isempty(obj.world) && obj.world.autoUpdate == 1
                    obj.world.UpdateVisual();
                end
            else
                error('invalid input');
            end
        end
        
    end
    
end

