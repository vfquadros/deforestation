N = 13
Agribusiness = [0 1 0 1 1 0 1 1 1 1 1 1 1];
DiffProfit = zeros(1,N)


clusters = {};
isOne = (Agribusiness == 1);
d = diff([0 isOne 0]);
startIdx = find(d == 1);
endIdx   = find(d == -1) - 1;

for k = 1:length(startIdx)
    clusters{k} = startIdx(k):endIdx(k);
end

left  = cellfun(@(c) min(c(:)), clusters);
right = cellfun(@(c) max(c(:)), clusters);

cand  = [left-1; right+1];              % 2-by-K candidate borders
valid = cand >= 1 & cand <= N;          % in-bounds mask

neighbors = arrayfun(@(i) cand(valid(:,i), i).', ...
                     1:numel(left), 'UniformOutput', false);

 for i =1:numel(neighbors)
     cluster = clusters{i};
     ContAgri = numel(cluster); % Counting the S
     term1 = sum(profit(A,ContAgri+1,cluster));
     term2 = sum(profit(A,ContAgri,cluster));
     for k = 1:numel(neighbors{i})
            if Agribusiness(1,neighbors{i}(k),t) == 1   % we just need to compute this for plots    
                                                        % which have not been sold to a Agri
                       continue;
            end
            DiffProfit(1,neighbors{i}(k)) = term1 - term2 + profit(A,ContAgri+1,neighbors{i}(k));
            
        
     end
 end
 DiffProfit