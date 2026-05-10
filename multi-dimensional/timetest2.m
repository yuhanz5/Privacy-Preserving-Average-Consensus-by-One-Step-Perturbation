%% 性能测试脚本 d2
clear; close all;

% 公共参数设置
n = 5;
T_total = 200;
rng(20);
num_trials = 50;  % 测试次数

% 加载公共数据
load('adj.mat');
load('A.mat');
load('noise11.mat');

% 预分配存储
times_alg1 = zeros(num_trials, 1);
times_alg2 = zeros(num_trials, 1);

% 预热运行（消除首次运行开销）
algorithm_clppm(n, 10, adj, A, noise);
algorithm_main(n, 10, adj, A, noise);

% 正式测试
for trial = 1:num_trials
    % 测试算法1
    f = @() algorithm_clppm(n, T_total, adj, A, noise);
    times_alg1(trial) = timeit(f);
    
    % 测试算法2
    f = @() algorithm_main(n, T_total, adj, A, noise);
    times_alg2(trial) = timeit(f);
end

%% 可视化结果

% 箱线图对比
% subplot(1,2,1)
boxplot([times_alg1, times_alg2],...
    'Labels', {'clppm algorithm ', 'our algorithm '})
ylabel('运行时间 (秒)')
title('运行时间分布对比')

% % 均值对比
% subplot(1,2,2)
% hold on
% bar(1, mean(times_alg1), 'b')
% bar(2, mean(times_alg2), 'r')
% errorbar(1:2, [mean(times_alg1), mean(times_alg2)],...
%     [std(times_alg1), std(times_alg2)], 'k.', 'LineWidth', 2)
% set(gca, 'XTick', 1:2, 'XTickLabel', {'Alg1', 'Alg2'})
% ylabel('平均运行时间 (秒)')
% title('均值对比 (±标准差)')

% 保存结果
% saveas(gcf, 'time_comparison.png')
fprintf('算法1平均时间: %.4f ± %.4f 秒\n', mean(times_alg1), std(times_alg1));
fprintf('算法2平均时间: %.4f ± %.4f 秒\n', mean(times_alg2), std(times_alg2));