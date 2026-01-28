clear
close all
clc
%% Create figure and plot initial snake
fSnake=figure(WindowState="maximized", WindowStyle="alwaysontop");
% Attach key handler
set(fSnake,'KeyPressFcn',@(src,event)keyPress(src,event));

% Define the grid size (number of points)
Ngrid=3;

% Initialize snake's initial position (x, y)
x=[0,0];
y=[0,0];

% Colors
green = [0.4660, 0.6740, 0.1880];
orange = [0.9290, 0.6940, 0.1250];

% Plot the initial snake line
h=plot(x, y, LineWidth=10, color=green);
xlim([-Ngrid Ngrid])
xticks(-Ngrid:Ngrid)
ylim([-Ngrid Ngrid])
yticks(-Ngrid:Ngrid)

grid on
axis square
hold on

% Plot snake's head
head=scatter(x(end), y(end), 'filled', 'diamond', 'MarkerFaceColor', green, 'MarkerEdgeColor', green, 'LineWidth', 10);

% Generate random valid starting target point (food) for snake
xPoint=randi([-Ngrid, Ngrid]);
yPoint=randi([-Ngrid, Ngrid]);
while ~xPoint && ~yPoint
    xPoint=randi([-Ngrid, Ngrid]);
    yPoint=randi([-Ngrid, Ngrid]);
end

% Plot the initial food position
s=scatter(xPoint, yPoint, 'filled', 'o', 'MarkerFaceColor', orange, 'MarkerEdgeColor', orange, 'LineWidth', 10);

%% Initialize pause buffers
pauseTint=0.5;
pauseTend=0.3;
pauseT=0.5;
Neat=1; % Index for the pause array

lenMax = (2*Ngrid+1)^2;
pauseT_array = zeros(lenMax-1,1);
for lenCurrent = 2:lenMax
    pauseT_array(lenCurrent-1) = (lenCurrent+2*Ngrid) / (lenCurrent+2*Ngrid-0.1);
end
pauseT_array = pauseT_array-min(pauseT_array);
pauseT_array = pauseT_array/max(pauseT_array) * (pauseTint-pauseTend) + pauseTend;

%% Animation loop
eat=0; % Flag to indicate if snake ate food
start=1; % Game start flag
noEdge=0;

% Dictionary for movement inputs, directions, and inverse directions
dic=cell(5,3);
inputs=['numpad1'; 'numpad8'; 'numpad4'; 'numpad5'; 'numpad6'; 'numpad0']; % Movement keys
invInputs=['numpad0'; 'numpad5'; 'numpad6'; 'numpad8'; 'numpad4'; 'numpad0']; % Inverse directions
scalarDir=[inf; -1; 1; 1; -1; -inf]; % Scalar values for diff of direction
for i=1:size(inputs,1)
    dic{i,1}=inputs(i,:);
    dic{i,2}=scalarDir(i,:);
    dic{i,3}=invInputs(i,:);
end

%% Main game loop
while true
    % Read current direction from figure
    if isvalid(fSnake) && isappdata(fSnake,'dir') 
        dir=getappdata(fSnake,'dir');
    else
        dir='numpad1';
    end
    if ~start
        pause(1)
    end
    
    % Update direction based on key press
    b=cell2mat(dic(:,1))==dir;
    b=b(:,end);
    dir=dic{b,1}; % Ensure valid direction
    a=find(b);
    % Prevent snake from moving in reverse direction
    if (mod(a,2) && dic{b,2}==(x(end)-x(end-1))) || (~mod(a,2) && dic{b,2}==(y(end)-y(end-1)))
        dir=dic{b,3}; % Switch to inverse direction
    end
    
    % Handle different keypresses
    switch dir
        case 'numpad1'
            clc
            disp('SSSSSSSSnake.....')
            figure(fSnake)
            
        case 'numpad8' % Extend snake in y-direction
            if eat && start
                x=[x(1:end) x(end)];
                if y(end)+1<=Ngrid || ~noEdge
                    y=[y(1:end) y(end)+1];
                else
                    y=[y(1:end) -Ngrid];
                end
            elseif ~eat && start
                x=[x(2:end) x(end)];
                if y(end)+1<=Ngrid || ~noEdge
                    y=[y(2:end) y(end)+1];
                else
                    y=[y(2:end) -Ngrid];
                end
            end

        case 'numpad4' % Extend snake in x-direction
            if eat && start
                if x(end)-1>=-Ngrid || ~noEdge
                    x=[x(1:end) x(end)-1];
                else
                    x=[x(1:end) Ngrid];
                end
                y=[y(1:end) y(end)];
            elseif ~eat && start
                if x(end)-1>=-Ngrid || ~noEdge
                    x=[x(2:end) x(end)-1];
                else
                    x=[x(2:end) Ngrid];
                end
                y=[y(2:end) y(end)];
            end
            
        case 'numpad5' % Move down
            if eat && start
                x=[x(1:end) x(end)];
                if y(end)-1>=-Ngrid || ~noEdge
                    y=[y(1:end) y(end)-1];
                else
                    y=[y(1:end) Ngrid];
                end
            elseif ~eat && start
                x=[x(2:end) x(end)];
                if y(end)-1>=-Ngrid || ~noEdge
                    y=[y(2:end) y(end)-1];
                else
                    y=[y(2:end) Ngrid];
                end
            end
            
        case 'numpad6' % Move right
            if eat && start
                if x(end)+1<=Ngrid || ~noEdge
                    x=[x(1:end) x(end)+1];
                else
                    x=[x(1:end) -Ngrid];
                end
                y=[y(1:end) y(end)];
                    
            elseif ~eat && start
                if x(end)+1<=Ngrid || ~noEdge
                    x=[x(2:end) x(end)+1];
                else
                    x=[x(2:end) -Ngrid];
                end
                y=[y(2:end) y(end)];
            end
            
        case 'numpad0'
            Snake

    end
    eat=0; % Reset eating flag
    
    if start
        %% Check for game over conditions
        % Check for edges collision
        if x(end)<-Ngrid || x(end)>Ngrid || y(end)<-Ngrid || y(end)>Ngrid
            set(head, 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r')
            text(Ngrid , 0, 'Game Over', 'FontSize', 35, 'FontWeight', 'bold', 'Color', 'r')
            text(Ngrid , -1, 'Press 0 To Restart', 'FontSize', 35, 'FontWeight', 'bold', 'Color', 'r')

            start=0;
            continue
        end
        % Check for self-collision
        if any(x(end)==x(2:end-1) & y(end)==y(2:end-1)) && ~all(dir=='numpad1')
            set(h, 'XData', x) % Update snake plot
            set(h, 'YData', y)
            set(head, 'XData', x(end), 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r')
            set(head, 'YData', y(end), 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r')
            text(Ngrid , 0, 'Game Over', 'FontSize', 35, 'FontWeight', 'bold', 'Color', 'r')
            text(Ngrid , -1, 'Press 0 To Restart', 'FontSize', 35, 'FontWeight', 'bold', 'Color', 'r')

            start=0;
            continue
        end
        
        %% Eating
        % If snake eats food, generate new food location and check if grid is fully occupied (winning condition)
        if x(end)==xPoint && y(end)==yPoint
            eat=1; % Snake eats food
        end
        if eat
            % Create a mask of the board
            place=false(2*Ngrid+1);
            place(sub2ind(size(place), y+Ngrid+1, x+Ngrid+1))=true; % snake cells marked
            % If no more open slots for the food = WIN
            if sum(place, 'all')==(2*Ngrid+1)^2
                set(h, 'XData', x) % Update snake plot
                set(h, 'YData', y)
                set(head, 'XData', x(end), 'MarkerEdgeColor', 'g', 'MarkerFaceColor', 'g')
                set(head, 'YData', y(end), 'MarkerEdgeColor', 'g', 'MarkerFaceColor', 'g')
                set(s, 'Xdata', []) % Remove the last food
                set(s, 'Ydata', [])
                text(Ngrid , 0, 'WIN! Congratulation', 'FontSize', 35, 'FontWeight', 'bold', 'Color', 'g')
                break
            end
            
            % Generate new food location
            mu=0; % Mean centered at 0
            sigma=Ngrid/2; % Standard deviation (adjust for desired spread)
            n=100; % Number of samples
            
            found=false;
            while ~found
                % Sample a batch from normal distribution
                randVals=round(normrnd(0,Ngrid/2,[100,2])); % 100 candidates
                randVals(randVals>Ngrid)=Ngrid;
                randVals(randVals<-Ngrid)=-Ngrid;
                
                idx = sub2ind(size(place), randVals(:,2)+Ngrid+1, randVals(:,1)+Ngrid+1);
                % Filter to keep only free cells
                freeMask=~place(idx);
                valid=randVals(freeMask,:);
                
                if ~isempty(valid)
                    % Pick one valid candidate
                    idx=randi(size(valid,1));
                    xPoint=valid(idx,1);
                    yPoint=valid(idx,2);
                    found=true;
                end
            end
            set(s, 'Xdata', xPoint) % Plot new food location
            set(s, 'Ydata', yPoint)
            % Each snake eat, puse is shorter
            pauseT = pauseT_array(Neat);
            Neat = Neat + 1;
        end
        
        %% Update snake plot with new position
        set(head, 'XData', x(end))
        set(head, 'YData', y(end))
        set(h, 'XData', x)
        set(h, 'YData', y)
        
        %% Pause for animation effect
        tStart=tic;
        while toc(tStart)<pauseT
            drawnow limitrate % update graphics only when needed
        end
    end
end
% end

function keyPress(fig,event)
% Allowed keys
validKeys={'numpad8','numpad4','numpad5','numpad6','numpad0','numpad1'};

% Update direction based on key press
if isappdata(fig,'dir')
    dir=getappdata(fig,'dir');
else
    dir='1'; % Default idle state
end

% If pressed key is valid, update it
if any(strcmp(event.Key,validKeys))
    dir=event.Key;
end

% Save into figure's appdata (fast + local)
setappdata(fig,'dir',dir);
end
