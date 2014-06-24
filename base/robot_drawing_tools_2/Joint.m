classdef Joint < hgsetget
    % Creates an object which can control the movement of links connected
    % together.
    
    properties
        % Unique name for a link for searching purposes.
        name = 'Undefined'
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
        pivot_point = [0, 0];
        % Position relative to joint
        position = [0 0];
        % Angle relative to joint
        angle = 0;
        %% Runtime Defined Variables:
        % These are created by the World() class during runtime, and should
        % not be altered.
        %
        % TODO: Alter variable names to be more consistent with the rest of
        % the Joint class.

        % Stores data for parent and child links.
        parentdata        
        childdata
        
        % Stores name of parent joint for positioning purposes.
        parentjoint;
        
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
        
        function Rotate(obj, theta)
            % Rotates the joint to a specific angle.
            % TODO: Add error checking to joint angle.
            obj.angle = theta;
        end
        
        function MoveY(obj,y)
            % Moves a variable in the x position.
            obj.position = [obj.position(1),y];
        end
        
        % TODO: Define MoveX, MoveTo(x,y) for joints.

    end
    
end

