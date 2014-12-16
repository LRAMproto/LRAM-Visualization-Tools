function rbottest1()

robot = RDTools.Robot();

% Initialization Tests
assert(isempty(robot.root))
assert(isempty(robot.links))
assert(isempty(robot.joints))

lnk1 = RDTools.Link();
lnk2 = RDTools.Link();

lnk1.SetColor([1 0 0]);
lnk2.SetColor([0 1 0]);

jnt12 = RDTools.Joint();
jnt12.SetParent(lnk1);
jnt12.SetOrigin([0 5 0]);
jnt12.SetPivotPoint([0 0 0]);
jnt12.SetZRotate(deg2rad(15));

jnt12.AddChild(lnk2);
lnk1.AddChild(jnt12);

assert(length(jnt12.children)==1);

links = [lnk1, lnk2];
joints = [jnt12];

robot.AddLinks(links);
robot.AddJoints(joints);

assert(length(robot.joints) == length(joints));
assert(length(robot.links) == length(links));

robot.SetRoot(lnk1);

assert(robot.root == lnk1);

lnk1.SetShape('square',5);
lnk2.SetShape('rectangle',[10 1]);

sf = .50;
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
end

