function rbottest2()

robot = RDTools.Robot();

% Initialization Tests

lnk1 = RDTools.Link();
links = [lnk1];
joints = [];

numLinks = 20;
prevLink = lnk1;

lengthOfString = 15;
widthOfString = 1;

for k=1:numLinks
    newJoint = RDTools.Joint();
    newLink = RDTools.Link();
    newJoint.AddChild(newLink);
    newJoint.SetOrigin([lengthOfString/numLinks 0 0])    
    newJoint.SetPivotPoint([lengthOfString/numLinks/2 0 0])
    prevLink.AddChild(newJoint);
    
    newLink.SetColor([k/numLinks k/numLinks k/numLinks])
    newLink.SetShape('rectangle',[lengthOfString/numLinks widthOfString]);    
    links = [links, newLink];
    joints = [joints, newJoint];
    prevLink = newLink;
end

robot.AddLinks(links);
robot.AddJoints(joints);

robot.SetRoot(lnk1);

assert(robot.root == lnk1);

sf = .5;
w = 1024*sf;
h = 1024*sf;

fig = figure('position',[0 0 w h]);

ax = axes('parent',fig,...
    'xlim',[-10 10],...
    'ylim',[-10 10],...
    'xlimmode','manual',...
    'ylimmode','manual'...
    );

robot.LoadToAxis(ax);

fprintf('Test passed.\n');
pause(2)

for k = 0:1000
    for j = 1:length(joints)
       joints(j).SetZRotate(deg2rad(k)); 
           
    end
    robot.UpdateVisual();
    pause(0.001)
end

end

