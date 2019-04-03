clc;
clear;

global WORLD_SIZE;
WORLD_SIZE = 4;
ACTION_PROB = 0.25;
DELTA = 1e-10; 
GAMMA = 1;
DERECTION = [[0, -1]; [0, 1]; [-1,0]; [1, 0]];

state_values = zeros(WORLD_SIZE, WORLD_SIZE);
old_state_values = state_values;
iteration = 0;

fid=fopen('history.txt','w');
fprintf(fid,'iteration = %d\r\n', iteration);
fprintf(fid,'%.3f  %.3f  %.3f  %.3f\r\n', state_values);


while(1)
    iteration = iteration+1;
    old_state_values = state_values;
    for x=1:WORLD_SIZE
        for y=1:WORLD_SIZE
            if(is_terminal(x, y))
                continue;
            end
            value = 0;
            for k=1:4
                [new_x, new_y, reward] = next_step([x, y], DERECTION(k, :));
                value = value + ACTION_PROB*(reward+GAMMA*old_state_values(new_x, new_y));
            end
            state_values(x, y) = value;
        end
    end
    
    if(abs(sum(state_values-old_state_values)) < DELTA)
        break;
    end
    if(iteration == 1 || iteration == 2 || iteration == 3 || iteration == 10)
        fprintf(fid,'\r\niteration = %d\r\n', iteration);
        fprintf(fid,'%.3f  %.3f  %.3f  %.3f\r\n', state_values);
    end
end

fprintf(fid,'\r\niteration = ¡Û\r\n');
fprintf(fid,'%.1f  %.1f  %.1f  %.1f\r\n', state_values);
fclose(fid);

function [new_x, new_y, reward] = next_step(xy, dir_xy)
    global WORLD_SIZE;
    new_x = xy(1)+dir_xy(1);
    new_y = xy(2)+dir_xy(2);
    if(new_x==0 || new_x==WORLD_SIZE+1)
        new_x = xy(1);
    end
    if(new_y==0 || new_y==WORLD_SIZE+1)
        new_y = xy(2);
    end
    reward = -1;
end

function terminal = is_terminal(x,y)
    global WORLD_SIZE;
    if ((x==1 && y==1) || (x==WORLD_SIZE && y==WORLD_SIZE))
        terminal = true;
    else
        terminal = false;
    end
end