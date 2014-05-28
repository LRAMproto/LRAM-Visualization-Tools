function [ output_args ] = vis_urdf_gui( input_args )
    fig = figure(...
        'Name','vis_urdf_gui',...
        'Color',[1 1 1],...
        'Menubar','figure',...
        'ToolBar','figure'...
        );
    ax = axes(...
        'Parent',fig,...
        'Visible','on'...
    );
    grid on;
    xlabel('x');
    ylabel('y');
    zlabel('z');
    %view([-37.5 -30]);
    %view([180 0]);
    r = xml2struct('caster.urdf');

    size = r.robot.link{1}.visual.geometry.box.Attributes.size;

    xyz = regexp(size,'\s','split');
    x = str2double(xyz{1});
    y = str2double(xyz{2});
    z = str2double(xyz{3});
    
    base = patch(...
        'Parent',ax,...
        'FaceColor',[0.7 0.7 0.7],...
        'XData',[-1 -1 1 1]*(x/2),...
        'YData',[-1 1 1 -1]*(z/2)...
        );
    
    size = r.robot.link{2}.visual.geometry.box.Attributes.size;
    
    xyz = regexp(size,'\s','split');
    x = str2double(xyz{1});
    y = str2double(xyz{2});
    z = str2double(xyz{3});
    arm = patch(...
        'Parent',ax,...
        'FaceColor',[0.3 0.3 0.3],...
        'XData',[-1 -1 1 1]*(x/2),...
        'YData',[-1 1 1 -1]*(z/2)...
        );
    
    origin = r.robot.link{2}.visual.origin.Attributes.xyz;
    disp(origin);
    xyz = regexp(origin,'\s','split');
    x = str2double(xyz{1});
    y = str2double(xyz{2});
    z = str2double(xyz{3});

    fprintf('%d %d %d\n',x,y,z);
    
    x0 = get(arm,'XData');
    y0 = get(arm,'YData');
    
    set(arm,'XData',x+x0,'YData',z+y0);
    
    set(ax,...
        'XLim',[-1 1],...
        'YLim',[-1 1],...
        'ZLim',[-1 1]...
        );
    %%loadObject();
    
    origin = r.robot.joint.origin.Attributes.xyz;
    disp(origin);
    xyz = regexp(origin,'\s','split');
    x = str2double(xyz{1});
    y = str2double(xyz{2});
    z = str2double(xyz{3});

    rotate(arm,[0 90],29);
end

