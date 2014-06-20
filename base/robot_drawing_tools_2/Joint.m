classdef Joint < hgsetget
    % Creates an object which can control the movement of links connected
    % together.
    
    properties
        name = 'Undefined'
        type = 'Fixed'
        % Stores name of Link Objects for object generation
        parent
        child
        origin = [0 0];
        pivot_point = [0, 0];
        angle = 0;
        % Stores runtime data on Link Objects
        parentdata
        childdata
        % Stores name of parent object for positioning
        parentjoint;
        
    end
    
    methods
        function obj = set.name(obj,val)
            if isa(val,'char')
                obj.name = val;
            else
                error('Joint name must be a string');
            end
        end
        
        function UpdateJointAngle(joint,angle)
                %joint.angle = angle;
                %[X,Y] = matrix_rotate(joint.child.xdata+joint.child.origin(1),joint.child.ydata+joint.child.origin(2),joint.angle,joint.origin);
                %set(joint.child.visual,'XData',X,'YData',Y+joint.child.origin(2));    
        end        
    end
    
end

