function linktest()

x = Link();

y = Link(x);
set(y,'xrotate',deg2rad(30));
set(y,'origin',[5 0 0]);

z = Link(y);
set(z,'yrotate',deg2rad(22));
set(z,'origin',[5 0 0]);

a = Link(z);
set(a,'zrotate',deg2rad(122));
set(a,'origin',[5 0 0]);
links = [x,y,z,a];

for i = 1:length(links)
disp(links(i))
disp(links(i).transMtx)
end

x.UpdateVisual(makehgtform())
ax = axes('xlim',[-1 10],'ylim',[-1 10]');
set(ax,'xlimmode','manual','ylimmode','manual');

for i = 1:length(links)
disp(links(i))
disp(links(i).transMtx)
[x,y,z] = links(i).GetWorldPoints();
disp(x)
disp(y)
disp(z)
patch('xdata',x,'ydata',y,'zdata',z,'facecolor',[(i)/length(links),0,0]);
end


end
