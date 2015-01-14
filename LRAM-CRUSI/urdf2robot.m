function robot = urdf2robot(filename)
% Converts a URDF representation to a useable RDTools robot.
urdf = xml2struct(filename);

RDlinks = [];
RDjoints = [];

% Generates robot.
robot = RDTools.Robot();

% Adds link objects
if isfield(urdf.robot, 'link')
    links = urdf.robot.link;
    
    for k=1:length(links)
        disp(links{k}.Attributes);
        newLink = RDTools.Link();
        newLink.name = links{k}.Attributes.name;
        RDlinks = [RDlinks, newLink];
        
        % Add visual elements
        if isfield(urdf.robot.link{k}, 'visual')
            if isfield(urdf.robot.link{k}.visual.geometry,'cylinder')
                urdf.robot.link{k}.visual.geometry.cylinder.Attributes
            end
        end
        
    end    
    
    robot.AddLinks(RDlinks);
end

% Adds joint objects
if isfield(urdf.robot, 'joint')
    joints = urdf.robot.joint;
    for k=1:length(joints)
        if isa(joints, 'struct')
            curJoint = joints(k);
        elseif isa(joints, 'cell')
            curJoint = joints{k};
        else
            error('unrecognized link format');
        end
        
        newJoint = RDTools.Joint();
        newJoint.name = curJoint.Attributes.name;
        newJoint.type = curJoint.Attributes.type;
        newJoint.parentLink = curJoint.parent.Attributes.link;
        newJoint.childLink = curJoint.child.Attributes.link;
        
        if isfield(curJoint, 'origin')
            
            rpy = strsplit(curJoint.origin.Attributes.rpy,' ');
            newRPY = zeros();
            
            for m=1:length(rpy)
                newRPY(m) = str2double(rpy{m});
            end
            
            newJoint.originRPY = newRPY;           
            
            xyz = strsplit(curJoint.origin.Attributes.xyz,' ');
            newXYZ = zeros();
            
            for m=1:length(rpy)
                newXYZ(m) = str2double(xyz{m});
            end
            
            newJoint.originXYZ = newXYZ;
            
            axisXYZ = strsplit(curJoint.axis.Attributes.xyz,' ');
            newAxisXYZ = zeros();
            
            for m=1:length(rpy)
                newAxisXYZ(m) = str2double(axisXYZ{m});
            end
            
            newJoint.axisXYZ = newAxisXYZ;
        end
        RDjoints = [RDjoints, newJoint];
    end
    robot.AddJoints(RDjoints);
    
end

robot.ConnectObjects();

end

