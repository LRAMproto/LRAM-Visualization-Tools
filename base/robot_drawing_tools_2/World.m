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
    end
    
    methods
        function obj = World(ax,links,joints)
            % Generates a world object given the axis, links, and joints.
            obj.ax = ax;
            obj.links = links;
            obj.joints = joints;
            for i= 1:length(links)
                links(i).world = obj;
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
                        obj.joints(i).parentjoint = obj.joints(j);
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
                        obj.joints(i).parentdata = obj.links(j);
                    end
                    if strcmp(obj.links(j).name, obj.joints(i).child)
                        child_found = 1;
                        obj.joints(i).childdata = obj.links(j);
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
                child = obj.joints(i).childdata;
                xdata = child.vertices.xdata;
                ydata = child.vertices.ydata;
                
                [xdata,ydata] = matrix_rotate(xdata,ydata,child.origin_angle,child.origin_angle_pivot_point);
                xdata = xdata + child.origin(1);
                ydata = ydata + child.origin(2);
                
                cj = obj.joints(i);

                while ~isempty(cj)
                    % FIXME: Verify that this transformation is accurate.
                    [xdata,ydata] = matrix_rotate(xdata',ydata',cj.angle,cj.pivot_point);
                     xdata = xdata + cj.origin(1);
                     ydata = ydata + cj.origin(2);
                     xdata = xdata + cj.position(1);
                     ydata = ydata + cj.position(2);
                    cj = cj.parentjoint;
                end

                % TODO: Add optimization step to avoid re-drawing the joint
                % if it doesn't need to be altered.
                
                set(child.visual,'XData',xdata,'YData',ydata);

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
                patchdata = patch(...
                    'Parent',obj.ax,...
                    'XData',obj.links(i).vertices.xdata+obj.links(i).origin(1),...
                    'YData',obj.links(i).vertices.ydata+obj.links(i).origin(2),...
                    'EdgeAlpha',1,...
                    'ButtonDownFcn',obj.links(i).buttondown_fcn,...
                    'FaceColor',obj.links(i).fillcolor,...
                    'UserData',obj.links(i),...
                    'LineWidth',obj.links(i).line_width);
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

