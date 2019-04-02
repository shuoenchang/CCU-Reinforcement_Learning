clc;
clear;

N_BANDIT = 2000;    % number of bandit problems
K_ARM = 10; % number of arms
N_STEP = 1000;  % number of step for each bandit problems
ELP_CHOOSE = [0, 0.01, 0.1];    % epsilon in epsilon-greedy method
ELP_COUNT = length(ELP_CHOOSE); % number of epsilon

q_star = normrnd(0,1,[N_BANDIT, K_ARM]);    % true mean of reward for every arms in every bandit problems
reward_average = zeros(ELP_COUNT, N_STEP);  % average of reward in every step
optimal_percent = zeros(ELP_COUNT, N_STEP); % optimal choose(%) in every step

for eps=1:ELP_COUNT     % loop for different epsilon
    reward_all = zeros(N_BANDIT, N_STEP);   % use to calculate for average reward
    optimal_choose = zeros(N_BANDIT, N_STEP);   % store for optimal choose
    epsilon = ELP_CHOOSE(eps);  % epsilon for this bandit
    for bandit=1:N_BANDIT   % loop for different bandit
        q_estimate = zeros(1, K_ARM);   % estimated reward
        reward_sum = zeros(1, K_ARM);   % use for update estimated reward
        arm_choose = zeros(1, K_ARM);   % use for update estimated reward
        [value, optimal] = max(q_star(bandit, :));  % using q_star to calculate the true optimal arms
        for step=1:N_STEP   % loop for step in each bandit
            if(rand(1) < epsilon)   % if rand(1)<epsilon 
                choose = unidrnd(K_ARM);    % random choose arms
            else 
                [value, choose] = max(q_estimate);  % choose arms from estimated reward
            end
            reward = normrnd(q_star(bandit, choose), 1);    % reward in this step (from arm choosen before)
            reward_all(bandit, step) = reward;  % store reward taken this time
            
            if(choose == optimal)
                optimal_choose(bandit, step) = 1;   % success choose the optimal
            end
            % ---update for estimated reward by sample-average method--- %
            reward_sum(choose) = reward_sum(choose)+reward;
            arm_choose(choose) = arm_choose(choose)+1;
            q_estimate(choose) = reward_sum(choose)/arm_choose(choose);
            % ---update for estimated reward by sample-average method--- %
        end     % end loop for step
    end     % end loop for bandit
    reward_average(eps, :) = mean(reward_all, 1);   % calculate average reward for drawing figure
    optimal_percent(eps, :) = sum(optimal_choose, 1)/N_BANDIT;  % calculate optimal percent for drawing figure
end     % end loop for epsilon

% ---draw the figure a--- %
color_choice = 'grb';
figure; hold on; grid on; 
sub = [];
for i=1:3
    sub(i) = plot( 1:N_STEP, reward_average(i,:), [color_choice(i),'-'] ); 
end
legend( sub, { '£`=0', '£`=0.01', '£`=0.1' }, 'Location', 'SouthEast' ); 
xlabel( 'steps' ); ylabel( 'Average Reward' ); 
saveas(gcf, 'figure_a.png');

% ---draw the figure b--- %
figure; hold on; grid on; 
sub = [];
for i=1:ELP_COUNT
    sub(i) = plot( 1:N_STEP, optimal_percent(i,:), [color_choice(i),'-'] ); 
end
set(gca,'YLim',[0 1])
set(gca, 'YTickLabel',num2str(100.*get(gca,'YTick')','%g%%'))
legend( sub, { '£`=0', '£`=0.01', '£`=0.1' }, 'Location', 'SouthEast' ); 
xlabel( 'steps' ); ylabel( 'Optimal Action' ); 
saveas(gcf, 'figure_b.png');