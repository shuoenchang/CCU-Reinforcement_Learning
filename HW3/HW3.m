clear;
clc;

% number of states (ternimal + nonternimal)
global nStates; % [T A B C D E T]
nStates = 7;    % [1 2 3 4 5 6 7]
           
valueM = monte_carlo(0.1);
valueT = temporal_difference(0.1);
           
function [value] = monte_carlo(alpha)
    global nStates;
    % ternimal and nonternimal states initial
    value = 0.5*ones(1, nStates); value(1)=0; value(end)=0; 
    nEpisodes = 100;
    for i = 1:nEpisodes
        state = 4;
        visit = state;
        returns = 0;
        while(1)    % each episode
             if rand<0.5
                 state_ = state-1;
                 if(state_ == 1)
                     break;
                 end
             else
                 state_ = state+1;
                 if(state_ == 7)
                     returns = 1;
                     break;
                 end
             end
             state = state_;
             visit = [visit state];
        end
        
        for si=1:length(visit)  % update value by simple every visit
            value(visit(si)) = value(visit(si)) + alpha*(returns-value(visit(si)));
        end
    end
    
end

function [value] = temporal_difference(alpha)
    global nStates;
    % ternimal and nonternimal states initial
    value = 0.5*ones(1, nStates); value(1)=0; value(7)=0; 
    nEpisodes = 100;
    for i = 1:nEpisodes
        state = 4;
        reward = 0;
        while(1)    % each episode
             if rand<0.5    % choose action
                 state_ = state-1;
             else
                 state_ = state+1;
                 if(state_ == 7)
                     reward = 1;
                 end
             end    
             
             value(state) = value(state) + alpha*(reward+value(state_)-value(state));
             state = state_;
             if(state==1 || state==7)
                 break;
             end
        end     % end each episode
    end
end
