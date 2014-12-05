function linktest()

x = Link();

y = Link(x);
set(y,'xrotate',30);
set(y,'origin',[10 0 1]);

z = Link(y);
set(z,'yrotate',22);
set(z,'origin',[10 0 1]);

a = Link(z);
set(a,'zrotate',122);
set(a,'origin',[10 0 1]);
links = [x,y,z,a];

for i = 1:length(links)
disp(links(i))
disp(links(i).transMtx)
end

x.UpdateVisual(makehgtform())

for i = 1:length(links)
disp(links(i))
disp(links(i).transMtx)

end


end
