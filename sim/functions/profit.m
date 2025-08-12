function Profit = profit(A,S,k)
        % k == 1 refers to the profit of plot n conditional to having S
        % other contiguous plots.
        global beta elasticity tau delta wage
        gamma = 1 ./ ((elasticity-1) .* (1 - beta));
        Profit = gamma.*delta.*(tau.*wage./b(A,S,k)).^(1-elasticity);