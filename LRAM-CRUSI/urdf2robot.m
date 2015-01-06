function [robot, urdf] = urdf2robot(filename)
% Converts a URDF representation to a useable RDTools robot.
urdf = xml2struct(filename);

links = urdf.robot.link;
joints = urdf.robot.joint;
RDlinks = [];
RDjoints = [];

for k=1:length(links)
    disp(links{k}.Attributes);
    newLink = RDTools.Link(); 
    newLink.name = links{k}.Attributes.name;
    RDlinks = [RDlinks, newLink];
end

for k=1:length(joints)
    disp(joints{k}.Attributes);    
    newJoint = RDTools.Joint();
    newJoint.name = joints{k}.Attributes.name;
    newJoint.type = joints{k}.Attributes.type;
    newJoint.parentLink = joints{k}.parent.Attributes.link;
    newJoint.childLink = joints{k}.child.Attributes.link;
    
    rpy = strsplit(urdf.robot.joint{k}.origin.Attributes.rpy,' ');
    newRPY = zeros();

    for m=1:length(rpy)
        newRPY(m) = str2double(rpy{m});
    end
    
    newJoint.originRPY = newRPY;

    
    xyz = strsplit(urdf.robot.joint{k}.origin.Attributes.xyz,' ');
    newXYZ = zeros();

    for m=1:length(rpy)
        newXYZ(m) = str2double(xyz{m});
    end
    
    newJoint.originXYZ = newXYZ;

    axisXYZ = strsplit(urdf.robot.joint{k}.axis.Attributes.xyz,' ');
    newAxisXYZ = zeros();
    
    for m=1:length(rpy)
        newAxisXYZ(m) = str2double(axisXYZ{m});
    end    
    
    newJoint.axisXYZ = newAxisXYZ;
    
    RDjoints = [RDjoints, newJoint];
end

robot = RDTools.Robot();

robot.AddLinks(RDlinks);
robot.AddJoints(RDjoints);
robot.ConnectObjects();

end

