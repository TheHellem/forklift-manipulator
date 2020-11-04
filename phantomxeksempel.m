import ETS3.*
mdl_phantomx
links = [
	Revolute('d', 40, 'alpha', -pi/2)
	Revolute('a', -105, 'alpha', pi)
	Revolute('a', -105)
	Revolute('a', -105)
	]

% Note alpha_2 = pi, needed to account for rotation axes of joints 3 and 4 having
% opposite sign to joint 2.
%
% s='Rz(q1) Tz(L1) Ry(q2) Tz(L2) Ry(q3) Tz(L3) Ry(q4) Tz(L4)'
% DHFactor(s)

px = SerialLink(links, 'name', 'PhantomX', 'manufacturer', 'Trossen Robotics', ...
    'plotopt', {'tilesize', 50});
qz = [0 -1.3509 1.0367 -0.565487];
px.tool = trotz(-pi/2) * trotx(pi/2)
view(3)
px.teach()