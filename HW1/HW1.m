clc;
clear;

N_BANDIT = 2000;
K_ARM = 10;
N_RUN = 1000;

q_star = normrnd(0,1,[N_BANDIT,K_ARM]);
reward_all = zeros(N_BANDIT, N_RUN);
optimal_choose = zeros(N_BANDIT, N_RUN);

for bi=1:N_BANDIT
    q_estimate = zeros(1, K_ARM);
    reward_sum = zeros(1, K_ARM);
    arm_choose = zeros(1, K_ARM);
    [value, optimal] = max(q_star(bi, :));
    for play=1:N_RUN
         [value, choose] = max(q_estimate);
         reward = normrnd(q_star(bi, choose), 1);
         reward_all(bi, play) = reward;
         if(choose == optimal)
             optimal_choose(bi, play) = 1;
         end
         reward_sum(choose) = reward_sum(choose)+reward;
         arm_choose(choose) = arm_choose(choose)+1;
         q_estimate(choose) = reward_sum(choose)/arm_choose(choose);
    end
end