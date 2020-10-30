clear all
import ETS3.*
links = [
	Revolute('d', 30, 'alpha', -pi/2)
    Revolute('a', -100, 'alpha', pi, 'offset', pi/2)
	Revolute('a', -100)
	Revolute('a', -100)
	Revolute('a', -100)
	]
qz = [0 pi/2 pi/4 -pi/5 -pi/5];
px = SerialLink(links, 'name', 'forklift');
TE = px.fkine([0 pi/2 pi/4 -pi/5 -pi/5]) %Forward
%syms q1 q2 q3 q4 q5
%TE = px.fkine([q1, q2, q3, q4]) %Forward
TI = px.ikine(TE, 'mask', [1 1 1 0 1 1]) %Inverse
px.fkine(TI) %Check if the answer is = TE
%TE = px.fkine([q1, q2, q3, q4, q5])
view(3)
px.plot(qz)



t = [0:0.05:2];
m = [1 1 1 0 1 1];
q0 = [0 0 0 0 0];             %Animasjon
qready = jtraj(q0, TI, t);
px.plot(qready)



%p = TE.t;
%p = p(1:3)
%J = px.jacob0([0 pi/1.2 pi/2 pi/5]) %End effector spatial velocity expressed in the world frame
%px.jacobe(qz) %spatial velocity in the end-efffector coordinate frame
%px.vellipse(qz)
%qd = pinv(J)*[0.5 0 0 0 0 0]' %Required joint velocity for desired motion of 0.1m/s in x-direction
%xd = J*qd %End effector velocity
%jk = J(1:4,:)