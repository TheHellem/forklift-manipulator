%Sjekker om den utregnede forward kinematics stemmer overens med det toolboxen regner ut
clear all
import ETS3.*
syms q1 q2 q3 q4
L(1) = Link([q1 30 0 -pi/2 0]);
L(2) = Link([q2 0 -100 pi 0]);
L(3) = Link([q3 0 -100 0 0]);
L(4) = Link([q4 0 -100 0 0]);
%L(5) = Link([q5 0 -100 0 0]);

five_link = SerialLink(L, 'name', 'forklift');

TE = five_link.fkine([q1 q2 q3 q4])

TE = five_link.fkine([0 0 0 0])
