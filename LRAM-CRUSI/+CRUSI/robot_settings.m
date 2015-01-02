function robot_settings(plugin)
%old_setup(plugin);
h = struct();
h = InitializeRobot(h);
h = SetupRobotLinks(h);
h = SetupRobotJoints(h);
h = LinkRobotLinksToJoints(h);
h = WriteToPluginSettings(h, plugin);
end

function h = WriteToPluginSettings(h, plugin)
    plugin.core.settings.robot = h.robot;
    
end

function h = InitializeRobot(h)
h.robot = RDTools.Robot();
end

function h = SetupRobotLinks(h)
cage = RDTools.Link();
% Load cage visual to shape.
h.robot.SetRoot(cage);
end
function h = SetupRobotJoints(h)
end

function h = LinkRobotLinksToJoints(h)
end

function old_setup(plugin)
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

% Registers servos
s1 = ECTools.Servo(jnt12);
s1.RegMeasureFcn('position',@pmeasure);
s1.RegUpdateFcn('position',@pupdate);

s2 = ECTools.Servo(jnt23);
s2.RegMeasureFcn('position',@pmeasure);
s2.RegUpdateFcn('position',@pupdate);

servos = [s1, s2];

robot.AddLinks(links);
robot.AddJoints(joints);
robot.AddServos(servos);

assert(length(robot.joints) == length(joints));
assert(length(robot.links) == length(links));

robot.SetRoot(jnt01);

lnk1.SetShape('square',5);
%lnk1.SetShape('circle',5);
lnk2.SetShape('rectangle',[10 1]);
lnk3.SetShape('rectangle',[10 1]);

%sf = .50;
%w = 1024*sf;
%h = 1024*sf;

plugin.core.settings.robot = robot;

%fig = figure('position',[0 0 w h]);

%ax = axes('parent',fig,...
%    'xlim',[-10 10],...
%    'ylim',[-10 10],...
%    'xlimmode','manual',...
%    'ylimmode','manual'...
%    );

%robot.LoadToAxis(ax);

%fprintf('Test passed.\n');
%pause(2)
%for k = 0:1000
%    jnt12.SetZRotate(deg2rad(k));
%    jnt23.SetZRotate(deg2rad(k));
%    robot.UpdateVisual();
%    pause(0.001)
%end

end


function val = pmeasure(servo)
val = servo.joint.zRotate;

end

function pupdate(servo, val)
servo.joint.SetZRotate(val);
end