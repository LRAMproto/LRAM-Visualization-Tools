classdef Robot < hgsetget
    % Keeps track of all information related to a single robot. This would
    % allow multiple robots doing different things to be represented in the
    % same simulation.
    
    % TODO: refactor code to make unique robot objects.
    
    properties
        % Uniquely identifying name of a robot that exists in a world.
        name
        % Environment that the robot exists in.
        world
        % Pieces of a robot object.
        links
        % Points of articulation allowing link objects to move.
        joints

        % For debugging purposes.
        updateStepTime = 0;
        
        debugMode = 0
    end
    
    methods
        function obj = Robot(name,links,joints)
            % Generates a robot object given the nanme, links, and joints.
            obj.name = name;
            obj.links = links;
            obj.joints = joints;
            for i= 1:length(links)
                links(i).robot = obj;
                joints(i).robot = obj;
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
        function LoadAll(obj)
            for i = 1:length(obj.links)
                obj.links(i).GeneratePoints;
                obj.links(i).previousVertices = struct('xdata',obj.links(i).vertices.xdata,'ydata',obj.links(i).vertices.ydata);
                obj.links(i).currentVertices = struct('xdata',obj.links(i).vertices.xdata,'ydata',obj.links(i).vertices.ydata);
                if ~isempty(obj.world)
                    if strcmp(get(obj.world.displayAxis,'type'),'axes')
                        patchdata = patch(...
                            'Parent',obj.world.displayAxis,...
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
                end
            end
        end
        
        function UpdateVisual(obj)
            for i = 1:length(obj.joints)
                if obj.updateStepTime > 0
                    pause(obj.updateStepTime)
                end
                
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
                    if obj.debugMode
                        disp('updating');
                    end
                    
                    set(child.visual,'XData',xdata,'YData',ydata);
                end
            end
        end
        
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

