function linktest()

x = Link();
numSubLinks = 100;
links = [x];
prevLink = x;

for k=1:numSubLinks
   lnk = Link(prevLink);
   set(lnk,'xrotate',deg2rad(k));
   set(lnk,'yrotate',deg2rad(k));
   set(lnk,'zrotate',deg2rad(k));   
   set(lnk,'origin',[.1 0 0])
   links = [links,lnk];
   prevLink = lnk;
end

for i = 1:length(links)
disp(links(i))
disp(links(i).transMtx)
end
idty = makehgtform();

x.UpdateVisual(idty)
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
