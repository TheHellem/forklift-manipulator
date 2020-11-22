
%Simulation of the robot arm changing its pose to match the pose of the
%pallet as described in the section conserning sensory system.

clear all
import ETS3.*  %Importerer pakke som tillater transformasjoner i 3D

syms q1 q2 q3 q4 q5;
q = [q1 q2 q3 q4 q5];
d = [30 0 0 0 0];
a = [0 -100 -100 -100 -100];
alpha = [-pi/2 pi 0 0 0];

for i = 1:5
    L(i) = Link([0 d(i) a(i) alpha(i)]); %Lager DH-parameter-tabell
end

robot = SerialLink(L, "name", "robotarm") %Definerer roboten
q_start = [0.440 0.880  1.868 -0.387 -0.586];  %Definerer joints q1,q2,q3,q4,q5 (radians)
forkine = robot.fkine(q_start) %Forward kinematics

% forkine = [0.9046 -0.0136 -0.4259 -272.5;...
%     0.4259 -0.0064 -0.9048 -128.3;...
%     0.0150 0.9999 0 -34.47;...
%     0 0 0 1]

invkine = robot.ikine(forkine,'u', 'mask', [1 1 1 0 1 1]) %Inverse kinematics

q_in = [0, 0, 0, 0, 0]; %For showing the arm moving to the desired pose,
                        %let's say that the initial joint angles are q_in.
view(3)
%robot.teach(q_start)
robot.plot(q_in)        %Plots arm with initial joint angles.

t = [0:0.05:2];
q_bane = jtraj(q_in, invkine, t);  %Defines trajectory from initial joint 
                                   %angles to desired pose.
robot.plot(q_bane)  %Plots the trajectory
