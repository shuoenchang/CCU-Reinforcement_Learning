clc;
clear;

N_BANDIT = 2000;
K_ARM = 10;
N_STEP = 1000;
ELP_CHOOSE = [0, 0.01, 0.1];
ELP_COUNT = length(ELP_CHOOSE);

q_star = normrnd(0,1,[N_BANDIT, K_ARM]);
reward_average = zeros(ELP_COUNT, N_STEP);
optimal_percent = zeros(ELP_COUNT, N_STEP);

for eps=1:ELP_COUNT
    reward_all = zeros(N_BANDIT, N_STEP);
    optimal_choose = zeros(N_BANDIT, N_STEP);
    epsilon = ELP_CHOOSE(eps);
    for bandit=1:N_BANDIT
        q_estimate = zeros(1, K_ARM);
        reward_sum = zeros(1, K_ARM);
        arm_choose = zeros(1, K_ARM);
        [value, optimal] = max(q_star(bandit, :));
        for step=1:N_STEP
            if(rand(1) < epsilon)
                choose = unidrnd(K_ARM);
            else
                [value, choose] = max(q_estimate);
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
    reward_average(eps, :) = mean(reward_all, 1);
    optimal_percent(eps, :) = sum(optimal_choose, 1)/N_BANDIT;
end

color_choice = 'grb';
figure; hold on; grid on; 
sub = [];
for i=1:3
    sub(i) = plot( 1:N_STEP, reward_average(i,:), [color_choice(i),'-'] ); 
end
legend( sub, { '0', '0.01', '0.1' }, 'Location', 'SouthEast' ); 
xlabel( 'steps' ); ylabel( 'Average Reward' ); 

figure; hold on; grid on; 
sub = [];
for i=1:3
    sub(i) = plot( 1:N_STEP, optimal_percent(i,:), [color_choice(i),'-'] ); 
end
set(gca,'YLim',[0 1])
set(gca, 'YTickLabel',num2str(100.*get(gca,'YTick')','%g%%'))
legend( sub, { '£`=0', '£`=0.01', '£`=0.1' }, 'Location', 'SouthEast' ); 
xlabel( 'steps' ); ylabel( 'Optimal Action' ); 