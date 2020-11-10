clear all
import ETS3.*
links = [
	Revolute('d', 30, 'alpha', -pi/2)
    Revolute('a', -100, 'alpha', pi)
	Revolute('a', -100)
	Revolute('a', -100)
	Revolute('a', -100)
	]
qz = [0 0 0 0 0];
px = SerialLink(links, 'name', 'forklift');
TE = px.fkine([0 pi pi/4 -pi/4 0]); %Forward
%syms q1 q2 q3 q4 q5
%TE = px.fkine([q1, q2, q3, q4]) %Forward
TI = px.ikine(TE, 'mask', [1 1 1 1 0 1]); %Inverse

px.fkine(TI) %Check if the answer is = TE
%TE = px.fkine([q1, q2, q3, q4, q5])
view(3)
%px.plot(qz)

t = [0:0.05:4];
m = [1 1 1 1 0 1];
q0 = [0 pi -pi/4 -pi/4 pi/2]; %Animasjon
qready = jtraj(q0, TI, t);
px.plot(qready)


t = [0:0.05:4];
m = [1 1 1 1 0 1];
TE=[pi pi pi/4 -pi/4 0]
qready1 = jtraj(TI, TE, t);
px.plot(qready1)


t = [0:0.05:4];
m = [1 1 1 1 0 1];
q1 = [pi pi -pi/4 pi/4 0];
TE=[pi pi pi/4 -pi/4 0]
qready1 = jtraj(TE, q1, t);
px.plot(qready1)

