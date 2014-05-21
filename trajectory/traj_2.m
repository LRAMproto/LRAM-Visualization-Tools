clc
clf
clear

% Trajectory calculator units [mks]

% Variables
t = linspace(0,1,20);           % Time span
theta = pi/3.5;                   % Release angle    [radians]
omega = [0 0 4*pi];             % Angular velocity [rad/sec]
target = [2.49 1.36];           % Location of target from lower left

% Constants:
% L   = .432;                   % Initial Length of arm
L   = 0.432;
Yo  = 1.33;                     % Drive motor position from ground
Xo  = .33;                      % Drive motor position from left

% Positions
Rx  = L*sin(theta);
Ry  = -L*cos(theta);
Ro  = [Rx Ry 0];
Vo  = cross(omega,Ro);

% Calling the trajectory function
[positions,velocities] = trajectory(t,Vo,Ro,Xo,Yo,target);


quiver(Xo,Yo,Ro(1),Ro(2))


% Plot and formatting 
plot(target(1),target(2),'linewidth',15)       % Target (Blue)
hold on
plot(Xo,Yo,'+r','linewidth',4)                 % Rotation axis (Red)
title('Position in Frame')
xlabel('Horizontal Distance [meters]')
ylabel('Vertical Distance [meters]')
hold on
grid on
axis([0 3.03 0 2.18])

plot(positions(1,:),positions(2,:),'o-k','linewidth',1.1)

% Print the velocity data
fprintf('Velocities:\n')
fprintf('X\n')
fprintf('Y\n')
disp(velocities)


%% **The following script draws arrows from the origin to each position to represent**
%% the string at a designated time interval.

% for i = 1:length(t)
%     linex(i) = positions(1,i) - positions(1,1);
%     liney(i) = positions(2,i) - positions(2,1);
%  
% end
% 
% point = [linex; liney];
% quiver((.33 + Rx) .* ones(1,length(t)),(1.33 + Ry) .* ones(1,length(t)),point(1,:),point(2,:))

