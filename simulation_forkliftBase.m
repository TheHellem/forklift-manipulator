clear all
clf
clc
%% Map

% Map for Lattice (innlagt sikkerhetsavstand til vegg)

noFlyMap = binaryOccupancyMap(100, 100, 1);
noFly = zeros(100, 100);

noFly(1:2,:) = 1;
noFly(end-1:end,:) = 1;
noFly([1:40, 61:100],1:2) = 1;
noFly(1:100,end-1:end) = 1;

noFly(36:64,20:100) = 1;
noFly(1:14,20:100) = 1;
noFly(end-14:end,20:100) = 1;

% Faktisk vegg

map = binaryOccupancyMap(100, 100, 1);
occ = zeros(100, 100);

occ(1,:) = 1;
occ(end,:) = 1;
occ([1:40, 61:100],1) = 1;
occ(1:100,end) = 1;

occ(49:50,22:100) = 1;

occ(37:62,[22:23 33:34 44:45 55:56 66:67 77:78 88:89]) = 1;

occ(1:12, [22:23 33:34 44:45 55:56 66:67 77:78 88:89]) = 1;
occ(end-12:end, [22:23 33:34 44:45 55:56 66:67 77:78 88:89]) = 1;

setOccupancy(map, occ)

estMap = occupancyMap(occupancyMatrix(map));
vMap = validatorOccupancyMap;
vMap.Map = estMap;

%% Lattice Planner

entrance = [1 50 0];
packagePickupLocation = [76 20 2];

planner = Lattice(noFly, 'grid', 5, 'root', entrance);    % Kan justere grid for økt nøyaktighet
planner.plan('cost', [1 5 19]);
route = planner.query(entrance, packagePickupLocation);


%% Get poses from route

rsConn = reedsSheppConnection('MinTurningRadius', 2); % Må justere det etter hva tuck klarer

startPoses = route(1:end-1,:);
endPoses = route(2:end,:);

rsPathSegs = connect(rsConn, startPoses, endPoses);
poses = [];
for i = 1:numel(rsPathSegs)
    lengths = 0:0.1:rsPathSegs{i}.Length;
    [pose, ~] = interpolate(rsPathSegs{i}, lengths);
    poses = [poses; pose];
end

%% Plott 1

% Plottefunksjonen til Corke er bugga, fant alternativ løsning

helperViz = HelperUtils;
% 
figure(1)
planner.plot(); hold on
title('Initial Route to Package')
robotPatch = helperViz.plotRobot(gca, poses(1,:)); hold on
axesColors = get(gca, 'ColorOrder');
routeLine = helperViz.plotRoute(gca, route, axesColors(2,:));

%% Sensor

rangefinder = rangeSensor('HorizontalAngle', pi/2);
numReadings = rangefinder.NumReadings;

%% Oppdatere rute basert på sensordata

% Setup visualization.
helperViz = HelperUtils;

v = VideoWriter('base_sim.avi');
open(v);

figure(2)
show(estMap)
hold on
robotPatch = helperViz.plotRobot(gca, poses(1,:));
rangesLine = helperViz.plotScan(gca, poses(1,:), ...
    NaN(numReadings,1), ones(numReadings,1));
axesColors = get(gca, 'ColorOrder');
routeLine = helperViz.plotRoute(gca, route, axesColors(2,:));
traveledLine = plot(gca, NaN, NaN);
title('Forklift Route to Package')
hold off


idx = 1;
tic;
while idx <= size(poses,1)
    % Insert range finder readings into map.
    [ranges, angles] = rangefinder(poses(idx,:), map);
    insertRay(estMap, poses(idx,:), ranges, angles, ...
        rangefinder.Range(end));
    
    % Update visualization.
    show(estMap, 'FastUpdate', true);
    helperViz.updateWorldMap(robotPatch, rangesLine, traveledLine, ...
        poses(idx,:), ranges, angles)
    frame = getframe(gcf)
    writeVideo(v,frame);
    drawnow
    
    % Regenerate route when obstacles are detected in the current one.
    isRouteOccupied = any(checkOccupancy(estMap, poses(:,1:2)));
    if isRouteOccupied && (toc > 0.5)
        idx = idx + 1;
%         currentPose = poses(idx,:)
%         planner = Lattice(occ, 'grid', 2, 'root', currentPose);
%         planner.plan('cost', [1 5 5])
%         route = planner.query(currentPose, packagePickupLocation);
%         % Get poses from the route.
%         startPoses = route(1:end-1,:);
%         endPoses = route(2:end,:);
%         rsPathSegs = connect(rsConn, startPoses, endPoses);
%         poses = [];
%         for i = 1:numel(rsPathSegs)
%             lengths = 0:0.1:rsPathSegs{i}.Length;
%             [pose, ~] = interpolate(rsPathSegs{i}, lengths);
%             poses = [poses; pose]; %#ok<AGROW>
%         end
%         
%         routeLine = helperViz.updateRoute(routeLine, route);
%         idx = 1;
%         tic;
    else
        idx = idx + 1;
    end
end

close(v);
