function rbottest1()

robot = RDTools.Robot();

% Initialization Tests
assert(isempty(robot.root))
assert(isempty(robot.links))
assert(isempty(robot.joints))

lnk1 = RDTools.Link();
lnk2 = RDTools.Link();

jnt12 = RDTools.Joint();
jnt12.SetParent(lnk1);

jnt12.AddChild(lnk2);
assert(length(jnt12.children)==1);

links = [lnk1, lnk2];
joints = [jnt12];

robot.AddLinks(links);
robot.AddJoints(joints);

assert(length(robot.joints) == length(joints));
assert(length(robot.links) == length(links));

robot.SetRoot(lnk1);

assert(robot.root == lnk1);

end

