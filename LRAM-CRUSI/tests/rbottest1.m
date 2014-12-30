function rbottest1()

robot = RDTools.Robot();

% Initialization Tests
assert(isempty(robot.root))
assert(isempty(robot.links))
assert(isempty(robot.joints))


lnk1 = RDTools.Link();
lnk2 = RDTools.Link();
lnk3 = RDTools.Link();
lnk2.SetCapPct(0.1);
lnk3.SetCapPct(0.1);

jnt01 = RDTools.Joint();
jnt01.AddChild(lnk1);
jnt01.SetOrigin([0 0 0]);

lnk1.SetColor([1 0 0]);
lnk2.SetColor([0 1 0]);
lnk3.SetColor([0 0 1]);

jnt12 = RDTools.Joint();
jnt12.SetParent(lnk1);

jnt12.SetOrigin([5 0 0]);
jnt12.SetPivotPoint([0 0 0]);
jnt12.SetZRotate(deg2rad(45));
jnt12.AddChild(lnk2);

lnk1.AddChild(jnt12);

assert(length(jnt12.children)==1);

jnt23 = RDTools.Joint();

jnt23.SetParent(lnk2);
jnt23.SetOrigin([10 0 0]);
jnt23.SetPivotPoint([5 0 0]);
jnt23.SetZRotate(deg2rad(20));
jnt23.AddChild(lnk3);

lnk2.AddChild(jnt23);

links = [lnk1, lnk2, lnk3];
joints = [jnt12, jnt23];

robot.AddLinks(links);
robot.AddJoints(joints);

assert(length(robot.joints) == length(joints));
assert(length(robot.links) == length(links));

robot.SetRoot(jnt01);

lnk1.SetShape('square',5);
lnk1.SetShape('circle',5);
lnk2.SetShape('rectangle',[10 1]);
lnk3.SetShape('rectangle',[10 1]);

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
pause(2)
for k = 0:1000
    jnt12.SetZRotate(deg2rad(k));
    jnt23.SetZRotate(deg2rad(k));
    robot.UpdateVisual();
    pause(0.001)
end

end

