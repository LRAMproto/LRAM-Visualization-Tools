classdef Robot < hgsetget
    % Keeps track of all informaiton related to a single robot. This allows
    % multiple robots to be represented in the same simulation.   
   
    properties
        % Uniquely identifying name of a robot that exists in a world.
        name
        % Environment that the robot is rendered  in.
        world
        % Pieces of a robot object.
        links
        % Points of articulation allowing link objects to move.
        joints       
        
        % For debugging purposes.
        updateStepTime = 0;
        
        % Allows robot to output debugging messages.
        debugMode = 0
    end
    
    methods
        function obj = Robot(name,links,joints)
            % Generates a robot object given the nanme, links, and joints.
            obj.name = name;
            obj.links = links;
            obj.PutJoints(joints);
            for i= 1:length(links)
                links(i).robot = obj;
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
                parent_found = false;
                child_found = false;
                for j = 1:length(obj.links)
                    if strcmp(obj.links(j).name, obj.joints(i).parent)
                        parent_found = true;
                        obj.joints(i).parentData = obj.links(j);
                    end
                    if strcmp(obj.links(j).name, obj.joints(i).child)
                        child_found = true;
                        obj.joints(i).childData = obj.links(j);
                    end
                    if parent_found == true && child_found == true
                        break;
                    end
                end
                if parent_found == false
                    disp('Check Parent Links for ');
                    disp(obj.joints(i));
                    error('Parent Link Not Found');
                end
                if child_found == false
                    disp('Check Child Links for ');
                    disp(obj.joints(i));
                    error('Child Link Not Found');
                end
            end
            
        end
        
        function LoadAll(obj)
            for i = 1:length(obj.links)
                obj.links(i).GeneratePoints;
                
                xdata = obj.links(i).vertices.xdata+obj.links(1).origin(1);
                ydata = obj.links(i).vertices.ydata+obj.links(1).origin(2);
                
                set(obj.links(i),...
                    'currentVertices',pkg_vertices(xdata,ydata));
                
                set(obj.links(i),...
                    'previousVertices',obj.links(i).currentVertices);
                
                % FIXME: Put steps to transform the base object
                % appropriately here.
                
                % FIXME: End Transformation code
                
                % Loads the base shape (not transformed by joints) into the
                % world.
                
                if ~isempty(obj.world)
                    if strcmp(get(obj.world.displayAxis,'type'),'axes')
                        patchdata = patch(...
                            'Parent',obj.world.displayAxis,...
                            'XData',obj.links(i).vertices.xdata,...
                            'YData',obj.links(i).vertices.ydata,...
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
            
            isUpdated = zeros(1,length(obj.joints));
            
            for i = 1:length(obj.joints)
                % TODO: Define 4D Matrix Rotation Here to replace previous
                % things.
                obj.joints(i).MakeWorldMatrix();
                
                if obj.updateStepTime > 0
                    pause(obj.updateStepTime)
                end
                
                child = obj.joints(i).childData;
                trackingPts = child.trackingPoints;
                
                xdata = child.vertices.xdata;
                ydata = child.vertices.ydata;
                set(child,'previousVertices',child.currentVertices);
                
                [xdata,ydata] = matrix_rotate(...
                    xdata,...
                    ydata,...
                    child.originAngle,...
                    child.originAnglePivotPoint);
                if ~isempty(trackingPts)
                    for pointNo = 1:length(trackingPts)
                        [trackingPts(pointNo).worldPosition(1),...
                            trackingPts(pointNo).worldPosition(2)] = ...
                            matrix_rotate(...
                            trackingPts(pointNo).localPosition(1),...
                            trackingPts(pointNo).localPosition(2),...
                            child.originAngle,...
                            child.originAnglePivotPoint);
                        trackingPts(pointNo).worldPosition(1) =...
                            trackingPts(pointNo).localPosition(1)...
                            + child.origin(1);
                        trackingPts(pointNo).worldPosition(2) = ...
                            trackingPts(pointNo).localPosition(2)...
                            + child.origin(2);
                    end
                end
                
                xdata = xdata + child.origin(1);
                ydata = ydata + child.origin(2);
                
                curJoint = obj.joints(i);
                
                while ~isempty(curJoint)
                    % FIXME: Verify that this transformation is accurate.
                    [xdata,ydata] = matrix_rotate(...
                        xdata,...
                        ydata,...
                        curJoint.angle,...
                        curJoint.pivotPoint);
                    xdata = xdata + curJoint.origin(1);
                    ydata = ydata + curJoint.origin(2);
                    xdata = xdata + curJoint.position(1);
                    ydata = ydata + curJoint.position(2);
                    
                    
                    if ~isempty(trackingPts)
                        for pointNo = 1:length(trackingPts)
                            [...
                                trackingPts(pointNo).worldPosition(1),...
                                trackingPts(pointNo).worldPosition(2)...
                                ] = ...
                                matrix_rotate(...
                                trackingPts(pointNo).worldPosition(1),...
                                trackingPts(pointNo).worldPosition(2),...
                                curJoint.angle,...
                                curJoint.pivotPoint);
                            trackingPts(pointNo).worldPosition(1) =...
                                trackingPts(pointNo).worldPosition(1)...
                                + curJoint.origin(1);
                            trackingPts(pointNo).worldPosition(2) = ...
                                trackingPts(pointNo).worldPosition(2)...
                                + curJoint.origin(2);
                            trackingPts(pointNo).worldPosition(1) =...
                                trackingPts(pointNo).worldPosition(1)...
                                + curJoint.position(1);
                            trackingPts(pointNo).worldPosition(2) = ...
                                trackingPts(pointNo).worldPosition(2)...
                                + curJoint.position(2);
                        end
                    end
                    curJoint = curJoint.parentJoint;
                    
                end
                set(child,'currentVertices',pkg_vertices(xdata,ydata));
                
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
        
        %% Joint Addition/Removal Operations
        % These operations allow for joints to be sorted in such a way that
        % more efficient updating operations take place.
        
        function RankJoints(obj)
            % Ranks are based on how many transformations take place to
            % move this joint.
            for i = 1:length(obj.joints)
                obj.joints(i).rank = 0;
                cj = obj.joints(i);
                while ~isempty(cj)
                    obj.joints(i).rank = obj.joints(i).rank + 1;
                    results = findobj(obj.joints,'child',cj.parent);
                    if numel(results) > 0
                        cj = results(1);
                    else
                        cj = [];
                    end
                    
                end
                
            end
            
        end
        
        function SortJoints(obj)
            % Sorts joints based on rank, allowing for faster updates. This
            % is an in-place sort.
            obj.RankJoints();
            for i=1:length(obj.joints)
                for j = i:length(obj.joints)
                    if obj.joints(j).rank < obj.joints(i).rank
                        temp = obj.joints(i);
                        obj.joints(i) = obj.joints(j);
                        obj.joints(j) = temp;
                    end
                end
                
            end
        end
        
        function PutJoints(obj,joints)
            % Accepts a set of joint objects rather than adding and sorting
            % indvidually.
            obj.joints = joints;
            for i=1:length(obj.joints)
                obj.joints(i).robot = obj;
                obj.joints(i).MakeLocalMatrix();
            end
            obj.SortJoints();
        end
        
        function AddJoint(obj,joint)
            % Adds a single joint.
            obj.joints = union(obj.joints,joint);
            obj.SortJoints();
        end
        
        function RemoveJoint(obj,joint)
            % Removes a single joint.
            % Disassociates the joint with the robot.
            joint.robot = [];
            obj.joints = setdiff(obj.joints,joint);
            obj.SortJoints();
        end
        
    end
    
end

