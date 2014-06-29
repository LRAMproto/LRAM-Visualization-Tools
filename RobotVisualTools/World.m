classdef World < hgsetget
% A Class describing the world in which all joints and links are populated.
% Note that there does not have to be one world per program; a control
% interface using this object could have a different world than a display,
% for example.
%
% Currently inherits from hgsetget to allow for set and get operations.

    properties
        %% Statically Defined Variables
        
        % Specifies name of world.
        name = 'World'

        %% Runtime-Specific Variables
        
        % This is an axes object that has been created before the World
        % is loaded.
        ax
        % tracks all joint objects in runtime.
        joints
        % tracks all link objects in runtime.
        links
        
        % autoUpdate set to 1 to automatically update the world whenever a
        % a joint is moved. If set to zero, you must call UpdateVisual
        % manually. This might be helpful if you wanted to change a ton of
        % variables before rendering.
        autoUpdate = 1;
    end
    
    methods
        function obj = World(ax,links,joints)
            % Generates a world object given the axis, links, and joints.
            obj.ax = ax;
            obj.links = links;
            obj.joints = joints;
            for i= 1:length(links)
                links(i).world = obj;
                joints(i).world = obj;                
            end
        end
        function MakeJointTree(obj)
            % Makes a Joint tree for use in positioning all objects.
            % (a Joint tree is just a set of joint objects connected in a
            % hierarchical fashion, so that each joint can potentially have
            % a parent joint).
            %
            % This allows an update function to apply transformations more
            % efficiently.
            
            % For each joint object...
            for i = 1:length(obj.joints)
                % Examine every joint object that has been loaded.
                for j = 1:length(obj.joints)
                    % If the joint's child is this joint's parent
                    if strcmp(obj.joints(j).child,obj.joints(i).parent)
                        % Set the parent joint data appropriately.
                        obj.joints(i).parentJoint = obj.joints(j);
                    end
                end                
            end
            
        end
        
        function LinkObjects(obj)
            % links runtime Link objects to runtime Joint objects
            for i = 1:length(obj.joints)
                parent_found = 0;
                child_found = 0;
                for j = 1:length(obj.links)
                    if strcmp(obj.links(j).name, obj.joints(i).parent)
                        parent_found = 1;
                        obj.joints(i).parentData = obj.links(j);
                    end
                    if strcmp(obj.links(j).name, obj.joints(i).child)
                        child_found = 1;
                        obj.joints(i).childData = obj.links(j);
                    end
                    if parent_found == 1 && child_found == 1
                        break;
                    end
                end
                if parent_found == 0
                    disp('Check Parent Links for ');
                    disp(obj.joints(i));
                    error('Parent Link Not Found');
                end
                if child_found == 0
                    disp('Check Child Links for ');
                    disp(obj.joints(i));
                    error('Child Link Not Found');
                end
            end

        end

        function UpdateVisual(obj)
            % Updates the visual simulation.
            % FIXME: Rename variables to be consistent with the Link and
            % Joint class once these classes are altered appropriately.
            for i = 1:length(obj.joints)
                child = obj.joints(i).childData;
                trackingPoints = child.trackingPoints;

                xdata = child.vertices.xdata;
                ydata = child.vertices.ydata;
                child.previousVertices = child.currentVertices;                

                [xdata,ydata] = matrix_rotate(xdata,ydata,child.originAngle,child.originAnglePivotPoint);
                if ~isempty(trackingPoints)
                    for pointNo = 1:length(trackingPoints)
                        [trackingPoints(pointNo).worldPosition(1),trackingPoints(pointNo).worldPosition(2)] = ...
                            matrix_rotate(trackingPoints(pointNo).localPosition(1),trackingPoints(pointNo).localPosition(2),...
                            child.originAngle,child.originAnglePivotPoint);
                        trackingPoints(pointNo).worldPosition(1) = trackingPoints(pointNo).localPosition(1)+child.origin(1);
                        trackingPoints(pointNo).worldPosition(2) = trackingPoints(pointNo).localPosition(2)+child.origin(2);
                    end
                end
                        
                xdata = xdata + child.origin(1);
                ydata = ydata + child.origin(2);
                
                curJoint = obj.joints(i);

                while ~isempty(curJoint)
                    % FIXME: Verify that this transformation is accurate.
                    [xdata,ydata] = matrix_rotate(xdata,ydata,curJoint.angle,curJoint.pivotPoint);
                     xdata = xdata + curJoint.origin(1);
                     ydata = ydata + curJoint.origin(2);
                     xdata = xdata + curJoint.position(1);
                     ydata = ydata + curJoint.position(2);

                    
                if ~isempty(trackingPoints)
                for pointNo = 1:length(trackingPoints)
                    [...
                        trackingPoints(pointNo).worldPosition(1),...
                        trackingPoints(pointNo).worldPosition(2)...
                        ] = ...
                        matrix_rotate((trackingPoints(pointNo).worldPosition(1)),(trackingPoints(pointNo).worldPosition(2)),...
                        curJoint.angle,curJoint.pivotPoint);
                        trackingPoints(pointNo).worldPosition(1) = trackingPoints(pointNo).worldPosition(1)+curJoint.origin(1);
                        trackingPoints(pointNo).worldPosition(2) = trackingPoints(pointNo).worldPosition(2)+curJoint.origin(2);
                        trackingPoints(pointNo).worldPosition(1) = trackingPoints(pointNo).worldPosition(1)+curJoint.position(1);
                        trackingPoints(pointNo).worldPosition(2) = trackingPoints(pointNo).worldPosition(2)+curJoint.position(2);                        
                end             
                end
                    curJoint = curJoint.parentJoint;
                
                end
                child.currentVertices = struct('xdata',xdata,'ydata',ydata);

                
                if ~isequal(child.previousVertices,child.currentVertices);
                    disp('updating');
                    set(child.visual,'XData',xdata,'YData',ydata);
                end
                
                % TODO: Add optimization step to avoid re-drawing the joint
                % if it doesn't need to be altered.
                

            end
        end
        
        function LoadAll(obj)
            % Loads all runtime world variables.
            
            % Link all Objects Together
            obj.LinkObjects();
            
            % Establishes a Joint Tree for use of rendering everything in
            % the correct order
            obj.MakeJointTree();
            
            % Loads the visual aspect of the simulation. Note that this
            % step positions all visual objects at the origin; UpdateVisual
            % is responsible for putting everything back where it needs to
            % be.
                       
            for i = 1:length(obj.links)
                obj.links(i).GeneratePoints;
                obj.links(i).previousVertices = struct('xdata',obj.links(i).vertices.xdata,'ydata',obj.links(i).vertices.ydata);
                obj.links(i).currentVertices = struct('xdata',obj.links(i).vertices.xdata,'ydata',obj.links(i).vertices.ydata);
                patchdata = patch(...
                    'Parent',obj.ax,...
                    'XData',obj.links(i).vertices.xdata+obj.links(i).origin(1),...
                    'YData',obj.links(i).vertices.ydata+obj.links(i).origin(2),...
                    'Visible',obj.links(i).visible,...
                    'ButtonDownFcn',obj.links(i).buttonDownFcn,...
                    'FaceColor',obj.links(i).fillColor,...
                    'FaceAlpha',obj.links(i).faceAlpha,...
                    'EdgeAlpha',obj.links(i).edgeAlpha,...
                    'UserData',obj.links(i),...
                    'LineWidth',obj.links(i).lineWidth);
                set(obj.links(i),'visual',patchdata);
            end        
            obj.UpdateVisual();                            
        end
%% Display Functions        
        function DisplayJoints(obj)
            % Displays verbose data for all joints in a world.
            disp('Joints:');
            for i = 1:length(obj.joints)
                disp(obj.joints(i));
            end
        end
        
        function DisplayLinks(obj)
            % Displays verbose data of all joint objects in a world.
            disp('Links:');
            for i = 1:length(obj.links)
                disp(obj.links(i));
            end
        end
        
        function DisplayAll(obj)
            % Displays relevant data for all objects.
            obj.DisplayLinks;
            obj.DisplayJoints;
        end
    end
end

