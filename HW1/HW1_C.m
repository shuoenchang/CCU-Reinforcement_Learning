clc;
clear;

N_BANDIT = 2000;
K_ARM = 10;
N_STEP = 1000;
N_TIME = 2; % first time for epsilon, second time for UCB

q_star = normrnd(0,1,[N_BANDIT, K_ARM]);
reward_average = zeros(N_TIME, N_STEP);
optimal_percent = zeros(N_TIME, N_STEP);

for time=1:N_TIME   % loop for time
    reward_all = zeros(N_BANDIT, N_STEP);
    optimal_choose = zeros(N_BANDIT, N_STEP);
    epsilon = 0.1;
    for bandit=1:N_BANDIT
        q_estimate = zeros(1, K_ARM);
        reward_sum = zeros(1, K_ARM);
        if(time == 1)   % epsilon-greedy method
            arm_choose = zeros(1, K_ARM);
        else    % UCB method
            arm_choose = zeros(1, K_ARM)+1e-10;  % 1e-10 to avoid divided by 0 in UCB
            c = 2;  % UCB with c=2
        end
        [value, optimal] = max(q_star(bandit, :));
        for step=1:N_STEP
            if(time == 1)   % epsilon-greedy method
                if(rand(1) < epsilon)
                    choose = unidrnd(K_ARM);
                else
                    [value, choose] = max(q_estimate);
                end
            else    % UCB method
                [value, choose] = max(q_estimate + c.*sqrt(log(step)./arm_choose));
            end
            reward = normrnd(q_star(bandit, choose), 1);
            reward_all(bandit, step) = reward;
            if(choose == optimal)
                optimal_choose(bandit, step) = 1;   
            end
            reward_sum(choose) = reward_sum(choose)+reward;
            arm_choose(choose) = arm_choose(choose)+1;
            q_estimate(choose) = reward_sum(choose)/arm_choose(choose);
        end
    end
    reward_average(time, :) = mean(reward_all, 1);
    optimal_percent(time, :) = sum(optimal_choose, 1)/N_BANDIT;
end     % end loop for time

color_choice = 'kb';
figure; hold on; grid on; 
sub = [];
for i=1:2
    sub(i) = plot( 1:N_STEP, reward_average(i,:), [color_choice(i),'-'] ); 
end
legend( sub, { '£`-greedy £`=0.1', 'UCB c=2' }, 'Location', 'SouthEast' ); 
xlabel( 'steps' ); ylabel( 'Average Reward' ); 
saveas(gcf, 'figure_c.png');

%{
figure; hold on; grid on; 
sub = [];
for i=1:2
    sub(i) = plot( 1:N_STEP, optimal_percent(i,:), [color_choice(i),'-'] ); 
end
set(gca,'YLim',[0 1])
set(gca, 'YTickLabel',num2str(100.*get(gca,'YTick')','%g%%'))
legend( sub, {'£`-greedy £`=0.1', 'UCB c=2' }, 'Location', 'SouthEast' ); 
xlabel( 'steps' ); ylabel( 'Optimal Action' ); 
%}