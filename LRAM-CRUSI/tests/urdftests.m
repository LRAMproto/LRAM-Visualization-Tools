function robot = urdftests()
h = struct();
h.fig = figure();
h.ax = axes('parent',h.fig);

h.filenames = {...
    '01-myfirst.urdf',...
    '02-multipleshapes.urdf',...
    '03-origins.urdf',...
    '04-materials.urdf',...
    '05-visual.urdf',...
    '06-flexible.urdf'...
    ...
    };

%test1(h);
test2(h);
%test3(h);
%test4(h);
%test5(h);
%test6(h);
end

function test1(h)
    robot = urdf2robot('01-myfirst.urdf');
    robot.SetRootLinkByName('base_link');
    robot.LoadToAxis(h.ax);

end

function test2(h)
    robot = urdf2robot('02-multipleshapes.urdf');
    robot.SetRootLinkByName('base_link');
    robot.LoadToAxis(h.ax);

end

function test3(h)
    robot = urdf2robot('03-origins.urdf');
    robot.SetRootLinkByName('base_link');
    robot.LoadToAxis(h.ax);

end

function test4()
    robot = urdf2robot('04-materials.urdf');
    robot.SetRootLinkByName('base_link');
    robot.LoadToAxis(h.ax);
end

function test5(h)
    robot = urdf2robot('05-visual.urdf');
    robot.SetRootLinkByName('base_link');
    robot.LoadToAxis(h.ax);
end

function test6(h)
    robot = urdf2robot('06-flexible.urdf');
    robot.SetRootLinkByName('base_link');
    robot.LoadToAxis(h.ax);
end