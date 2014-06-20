function make_robot_test()
    test2();
end

function test1()
    fig = figure(...
        'Name','Test Figure',...
        'Units','Pixels',...
        'Position',[50,50,600,600]);
    ax = axes(...
        'Parent',fig,...
        'Units','Pixels',...
        'XLim',[-10 10],...
        'YLim',[-10 10],...
        'XLimMode','Manual',...
        'YLimMode','Manual',...        
        'Position',[50 50 500 500]);
    grid on;
    [X,Y] = squashed_rectangle_continuous(3,2,0.05,100);   
    xOrigin = 0;
    yOrigin = 0;    
    box = patch('XData',X+xOrigin,'YData',Y+yOrigin,'FaceColor',[.7 .7 .7]);
    [armX,armY] = squashed_rectangle_continuous(0.5,5,0.05,4);
	xOrigin = 0;
	yOrigin = -2.50;    
	arm = patch('XData',armX+xOrigin,'YData',armY+yOrigin,'FaceColor',[.3 .3 .3]);
    [pivot_x,pivot_y] = squashed_rectangle_continuous(0.5,0.5,1.0,100);
    pivot_dot = patch('XData',pivot_x,'YData',pivot_y,'FaceColor','m');
    pause(1);    
    for i = 0:.01:2*pi
        [X,Y] = matrix_rotate(armX+xOrigin,armY+yOrigin,i,[0 0]);
        set(arm,'XData',X);
        set(arm,'YData',Y);    
        pause(0.001);
    end    
    
    pause(3);
    close(fig);

end

function test2
    fig = figure(...
        'Name','Test Figure',...
        'Units','Pixels',...
        'Position',[50,50,600,600]);
    ax = axes(...
        'Parent',fig,...
        'Units','Pixels',...
        'XLim',[-10 10],...
        'YLim',[-10 10],...
        'XLimMode','Manual',...
        'YLimMode','Manual',...        
        'Position',[50 50 500 500]);
    grid on;
    
    box = struct(...
        'name','Base',...
        'type','Polygon',...
        'width',3,...
        'height',2,...
        'origin',[0 0],...
        'rotation',0 ...
    );

    [box.xdata, box.ydata] = squashed_rectangle_continuous(box.width,box.height,0.05,100);

    arm = struct(...
        'name','Arm',...
        'type','Polygon',...
        'width',0.5,...
        'height',5,...
        'origin',[0 -2.5],...
        'rotation',pi/2 ...
    );

    [arm.xdata, arm.ydata] = squashed_rectangle_continuous(arm.width,arm.height,0.05,100);

    box.visual = patch('XData',box.xdata+box.origin(1),'YData',box.ydata+box.origin(2),'FaceColor',[.7 .7 .7]);
    arm.visual = patch('XData',arm.xdata+arm.origin(1),'YData',arm.ydata+arm.origin(2),'FaceColor',[.3 .3 .3]);    

    arm_joint = struct(...
        'name','Arm Joint',...
        'type','Joint',...
        'parent',box,...
        'child',arm,...
        'origin',[0 0],...
        'angle',0.35 ...
        );   
    for i = 0:.01:2*pi
        update_joint_angle(arm_joint,i);
        pause(0.001);
    end    
    
end

function update_joint_angle(joint,angle)
    joint.angle = angle;
    [X,Y] = matrix_rotate(joint.child.xdata+joint.child.origin(1),joint.child.ydata+joint.child.origin(2),joint.angle,joint.origin);
    set(joint.child.visual,'XData',X,'YData',Y+joint.child.origin(2));    
end