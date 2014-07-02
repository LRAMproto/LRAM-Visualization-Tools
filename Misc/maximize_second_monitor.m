function position = maximize_second_monitor(fig)
p = get(0,'monitorpositions');
[width, height] = getwh(p);
scroffset = 50;
position = [p(2,1),p(1,2),width,height+scroffset]
set(fig,'position',position);
end

function [width, height] = getwh(p)
width = p(2,3)-p(2,1);
height = p(2,4)-p(2,2);

    end