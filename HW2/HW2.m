clear;
clc;

global WORLD_SIZE;
WORLD_SIZE = 4; % size of grid world
ACTION_PROB = 0.25; % using random policy for each direction
DELTA = 1e-10;  % threshold use for testing if converge
GAMMA = 1;  % undiscounted
DERECTION = [[0, -1]; [0, 1]; [-1,0]; [1, 0]];  % use for transition

state_values = zeros(WORLD_SIZE, WORLD_SIZE);   % state value in this iteration
old_state_values = state_values;    % state value in previous iteration
iteration = 0;

fid = fopen('history.txt','w'); % store the iteration history in file
fprintf(fid,'iteration = %d\r\n', iteration);
fprintf(fid,'%.3f\t%.3f\t%.3f\t%.3f\r\n', state_values);

while(1)
    iteration = iteration+1;
    old_state_values = state_values;    % store previous state value
    for x=1:WORLD_SIZE
        for y=1:WORLD_SIZE
            if(is_terminal(x, y))
                continue;   % if it is terminal, no need to do transition
            end
            value = 0;  % value for (x,y)
            for k=1:4
                [new_x, new_y, reward] = next_step([x, y], DERECTION(k, :));    % check for position after transition
                value = value + ACTION_PROB*(reward+GAMMA*old_state_values(new_x, new_y)); % iterate Bellman equation
            end
            state_values(x, y) = value; % update state values at (x,y)
        end
    end
    if(sum(abs(state_values-old_state_values)) < DELTA) 
        break;  % converge
    end
    if(iteration == 1 || iteration == 2 || iteration == 3 || iteration == 10)
        fprintf(fid,'\r\niteration = %d\r\n', iteration);
        fprintf(fid,'%.3f\t%.3f\t%.3f\t%.3f\r\n', state_values);
    end
end

fprintf(fid,'\r\niteration = ¡Û\r\n');
fprintf(fid,'%.3f\t%.3f\t%.3f\t%.3f\r\n', state_values);
fclose(fid);

function [new_x, new_y, reward] = next_step(xy, dir_xy)
    global WORLD_SIZE;
    new_x = xy(1)+dir_xy(1);
    new_y = xy(2)+dir_xy(2);
    if(new_x==0 || new_x==WORLD_SIZE+1) 
        new_x = xy(1);  % x is out of grid world's range
    end
    if(new_y==0 || new_y==WORLD_SIZE+1)
        new_y = xy(2);  % y is out of grid world's range
    end
    reward = -1;
end

% function check for if it is terminal
function terminal = is_terminal(x,y)
    global WORLD_SIZE;
    if ((x==1 && y==1) || (x==WORLD_SIZE && y==WORLD_SIZE))
        terminal = true;
    else
        terminal = false;
    end
end