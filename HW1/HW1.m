clc;
clear;

N_BANDIT = 2000;
K_ARM = 10;
N_PLAY = 1000;
ELP_CHOOSE = [0, 0.01, 0.1];
ELP_COUNT = length(ELP_CHOOSE);

q_star = normrnd(0,1,[N_BANDIT, K_ARM]);
reward_average = zeros(ELP_COUNT, N_PLAY);
optimal_percent = zeros(ELP_COUNT, N_PLAY);

for eps=1:ELP_COUNT
    reward_all = zeros(N_BANDIT, N_PLAY);
    optimal_choose = zeros(N_BANDIT, N_PLAY);
    epsilon = ELP_CHOOSE(eps);
    for bandit=1:N_BANDIT
        q_estimate = zeros(1, K_ARM);
        reward_sum = zeros(1, K_ARM);
        arm_choose = zeros(1, K_ARM);
        [value, optimal] = max(q_star(bandit, :));
        for play=1:N_PLAY
            if(rand(1) < epsilon)
                choose = unidrnd(K_ARM);
            else
             [value, choose] = max(q_estimate);
             reward = normrnd(q_star(bandit, choose), 1);
             reward_all(bandit, play) = reward;
            end

             if(choose == optimal)  
                 optimal_choose(bandit, play) = 1;   
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
    sub(i) = plot( 1:N_PLAY, reward_average(i,:), [color_choice(i),'-'] ); 
end
legend( sub, { '0', '0.01', '0.1' }, 'Location', 'SouthEast' ); 
xlabel( 'plays' ); ylabel( 'Average Reward' ); 

figure; hold on; grid on; 
sub = [];
for i=1:3
    sub(i) = plot( 1:N_PLAY, optimal_percent(i,:), [color_choice(i),'-'] ); 
end
legend( sub, { '0', '0.01', '0.1' }, 'Location', 'SouthEast' ); 
xlabel( 'plays' ); ylabel( 'Optimal Action' ); 