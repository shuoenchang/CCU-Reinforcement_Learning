clear;
clc;

% number of states (ternimal + nonternimal)
global nStates; % [T A B C D E T]
nStates = 7;    % [1 2 3 4 5 6 7]

alphaMC = [0.01, 0.02, 0.03, 0.04];
alphaTD = [0.05, 0.10, 0.15];
answerMC = zeros(4, 100);
answerTD = zeros(3, 100);
plotMC = ['k-.'; 'r-.'; 'g-.'; 'b-.'];
plotTD = ['m-'; 'c-'; 'y-'];
ah = [];

% MC method
figure; 
for i=1:4
    for runs=1:100
        values = monte_carlo(alphaMC(i));   % get each episode(1, 2, 3, ..., 100) value
        answerMC(i,:) = answerMC(i,:)+rms_error(values);    % the sum of error in each episode
    end
    answerMC(i,:) = answerMC(i,:)/100;  % the mean of error
    h = plot( answerMC(i,:), plotMC(i,:) ); ah = [ah; h];
    hold on; 
end

% TD method
for i=1:3
    for runs=1:100
        values = temporal_difference(alphaTD(i));
        answerTD(i,:) = answerTD(i,:)+rms_error(values);
    end
    answerTD(i,:) = answerTD(i,:)/100;
    h = plot( answerTD(i,:), plotTD(i,:) ); ah = [ah; h]; 
    hold on; 
end

xlabel('walks/episodes'); ylabel('average RMS error'); 
legend( ah, { 'MC \alpha=0.01', 'MC \alpha=0.02', 'MC \alpha=0.03', 'MC \alpha=0.04'...
              'TD \alpha=0.05', 'TD \alpha=0.10', 'TD \alpha=0.15'} ); 
saveas(gcf, 'figure.png');

% to get rms_error
function [error] = rms_error(values)
    trueValue = (1:5)/6;    % true value = (1/6, 2/6, 3/6, 4/6, 5/6)
    error = sqrt(mean(((values-trueValue).^2), 2)); % calculate episode by episode
    error = error'; % column to row
end
           
function [values] = monte_carlo(alpha)
    global nStates;
    % ternimal and nonternimal states initial
    value = 0.5*ones(1, nStates); value(1)=0; value(end)=0; 
    values = [];
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
        values = [values; value(2:6)];   % store each episode value
    end
    
end

function [values] = temporal_difference(alpha)
    global nStates;
    % ternimal and nonternimal states initial
    value = 0.5*ones(1, nStates); value(1)=0; value(7)=0; 
    values = [];
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
        values = [values; value(2:6)];  % store each episode value
    end
end
