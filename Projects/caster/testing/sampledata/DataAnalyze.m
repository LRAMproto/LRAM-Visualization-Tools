% Bad Cast 1: Stopped short, tangled on self
% Bad Cast 2: ditto
% Good Cast:  Made it over bar, suspended at end.
clearvars -except Ts tg
close all
% Which column in the vector contains the which data
% 1 Arm pos (rad)
% 2 Arm target pos (rad)
% 3 Arm Cmd (amps)
% 4 Spool pos (rad)
% 5 Spool Cmd (amps)
% 6 String Angle (rad)

% GC = load('BadBasicCastDataLog.mat');
% GC = load('BadBasicCast2DataLog.mat');
% GC  = load('GoodCastDataLog.mat');
GC = load('ByHandCastHit.mat');
% GC = load('AlmostFlat.mat');
% GC = load('ByHandCast.mat');
% GC = load('ByHandCastAlmost.mat');
% plot_from = [4,9];

% Time Frames
plot_from = [30, 40];
i = find(plot_from(1) < GC.fsTime, 1, 'first');
j = find(plot_from(2) > GC.fsTime, 1, 'last');

% Events
% Constants
stop_ArmPos = 2.9916;   % rad, Position arm triggers cast
stop_String = 3.75;     % rad, Position String Angle triggers cast
far_Enough  = 65;       % rad, How far before string is jerked back

% Release time
t_re = find(and(stop_ArmPos >= GC.fsData(:,1), stop_String >= GC.fsData(:,6)), 1, 'first');

plot(GC.fsTime(i:j), GC.fsData(i:j,1:3))
title('Arm')
xlabel('sec')
ylabel('rad or amps')
legend('Arm pos','Target', 'Cmd amps', 'Location', 'SouthEast')

figure
plot(GC.fsTime(i:j), GC.fsData(i:j,4:5))
title('Spool')
xlabel('sec')
ylabel('rad or amps')
legend('Spool pos','Cmd amps', 'Location', 'SouthEast')

% String Angle
figure
[hA, h_b1, h_b2] = plotyy(GC.fsTime(i:j), GC.fsData(i:j,6),...
                           GC.fsTime(i+1:j), diff(GC.fsData(i:j,6))./diff(GC.fsTime(i:j)));
grid on
title('String Angle')
xlabel('sec')
ylabel(hA(1), 'rad')
ylabel(hA(2), 'rad/sec')
legend('position', 'velocity', 'Location', 'SouthEast')

figure
[hAx, h_l1, h_l2] = plotyy(GC.fsTime(i:j), GC.fsData(i:j,[1:3]),...
                           GC.fsTime(i:j), GC.fsData(i:j,[4]));
line([GC.fsTime(t_re),GC.fsTime(t_re)],[0,10],'Color',[.4,.4,.4])
xlabel('sec')
ylabel(hAx(1), 'rad')
ylabel(hAx(2), 'Spool (rad)')
legend('Arm Pos', 'Arm Target', 'Arm Cmd',...
       'Location', 'NorthWest')
   
% animationArm(plot_from, GC)