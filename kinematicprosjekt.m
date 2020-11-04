clear all
import ETS3.*
links = [
	Revolute('d', 30, 'alpha', -pi/2)
    Revolute('a', -100, 'alpha', pi)
	Revolute('a', -100)
	Revolute('a', -100)
	Revolute('a', -100)
	];
%qz = [0 0.314 0.62 0.377 -pi/5];
syms q1 q2 q3 q4 q5 real
L(1) = Link([q1 30 0 -pi/2 0]);
L(2) = Link([q2 0 -100 pi 0]);
L(3) = Link([q3 0 -100 0 0]);
L(4) = Link([q4 0 -100 0 0]);
L(5) = Link([q5 0 -100 0 0]);
qz = [q1 q2 q3 q4 q5];
px = SerialLink(L, 'name', 'forklift');
TE = px.fkine([0 pi/2 pi/4 -pi/5 -pi/5]); %Forward
%syms q1 q2 q3 q4 q5
%TE = px.fkine([q1, q2, q3, q4]) %Forward
%TI = px.ikine(TE, 'mask', [1 1 1 0 1 1]) %Inverse
%px.fkine(TI) %Check if the answer is = TE
%TE = px.fkine([q1, q2, q3, q4, q5])
%view(3)
%px.plot(qz)
%p = TE.t;
%p = p(1:3)
Je = real(px.jacobe(qz));
J = real(px.jacob0(qz));%End effector spatial velocity expressed in the world frame
j = simplify(Je);
px.jacobe(qz); %spatial velocity in the end-efffector coordinate frame
%px.vellipse(qz)
qd = pinv(j)*[0.5 0 0 0 0 0]'; %Required joint velocity for desired motion of 0.1m/s in x-direction
xd = j*qd;
simplify(xd)%End effector velocity
%jk = J(1:4,:)
%view(3
%TE.animate()
