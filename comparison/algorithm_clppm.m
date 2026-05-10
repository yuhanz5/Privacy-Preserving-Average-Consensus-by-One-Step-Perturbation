
%% 算法1clppm  主循环函数
function [x, z] = algorithm_clppm(n, T_total, adj, A, noise)
    x = zeros(n,T_total);
    x(:,1) = [1; 2; 4; 3; 5];
    z = zeros(1,T_total);
    z(1) = x(1,1) - 0.1*rand;

    for t = 1:T_total-1
        % 通信过程
        S = zeros(n,n);
        for i = 1:n
            neighbors = find(adj(i,:));
            for j = neighbors
                if t == 1
                    S(i,j) = x(i,t) + noise(i,j);
                else,if t <= 20
                    noise = zeros(n, n);
                    noise(i,j) = 200*(rand-0.5);
                    S(i,j) = x(i,t) + noise(i,j);
                    else
                    S(i,j) = x(i,t);
                    end
                end
            end
        end
        
        % 状态更新
        x_new = x(:,t);
        for i = 1:n
            delta = 0;
            neighbors = find(adj(i,:));
            for j = neighbors
                s_ij = S(j,i);
                s_ji = S(i,j);
                delta = delta + A(i,j)*(s_ij - s_ji);
            end
            x_new(i) = x_new(i) + delta;
        end
        x(:,t+1) = x_new;
        
        % 监听更新
        sum_z = 0;
        neighbors = find(adj(1,:));
        for j = neighbors
            term = A(1,j)*(x(j,t) - x(1,t));
            sum_z = sum_z + term;
        end
        z(t+1) = z(t) + (x(1,t+1) - x(1,t)) - 0.9*sum_z;
    end
end

