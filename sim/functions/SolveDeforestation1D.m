function SolveDeforestation1D(N,Tmax,A,F,O,D,L,Agribusiness,O_aux)

global N beta alpha pi wage Tlag

q1 = (1-beta.*(1-pi))./(pi.*(beta.^Tlag));
q2 = (1-beta.*(1-pi).*(1+pi.*(beta.^Tlag)))./(pi.*(beta.^Tlag).*(1-beta));
q3 = (alpha.*(1-beta.^Tlag)+(beta.^Tlag).*(1-pi).*(1-beta))./(pi.*(beta.^Tlag).*(1-beta));

neighbors = cell(1, N);

for i = 1:N
    idx = [i-1, i+1];        % left and right candidates
    idx(idx < 1 | idx > N) = [];  % keep only valid ones
    neighbors{i} = idx;
end

deforest = zeros(1,Tmax);
emissions = zeros(1,Tmax);
DiffProfit = zeros(1,N);  % This will store the differences in Agribusinessess
                          % function psi in the model
figure;                % Starting animation
h = imagesc(D(1,:,1)); % Create heatmap
colorbar;
for t = 1:Tmax-1
    % Calculating land prices R
        % Step 1: calcuting agribusiness diff profits
        for i =1:N
            if Agribusiness(1,i,t) == 1 % we just need to compute this for plots    
                                        % which have not been sold to an
                                        % Agri
                       continue;
                    end
                    pft = 0;
                    ContAgri = sum(Agribusiness(1,neighbors{i},t)); % Counting the S
                    for k = neighbors{i} % Computing profits in contiguous sites
                        if Agribusiness(1,k,t)==1
                            term1 = profit(A,ContAgri+1,k);
                            term2 = profit(A,ContAgri,k);
                            pft = pft + term1 - term2;
                        end
                    end
                DiffProfit(1,i) = pft + profit(A,ContAgri+1,i); 
        end
        % Step 2: calculate the farmers profit when selling land
     FarmersProfit = max(q1*F+q2*wage-q3*A-wage/(1-beta), (A-wage)/(1-beta));

    R(1,:,t) = 1.*DiffProfit + 0*FarmersProfit;
     
    % Farmers
    Vu = value_u(A,R(1,:,t),F);
    Vp = value_p(A,F);

    Du = L == 0 & D(1,:,t) ~= 1 & Agribusiness(1,:,t) ~= 1 & Vu > 0; 
    Dp = L == 1 & D(1,:,t) ~= 1 & Agribusiness(1,:,t) ~= 1 & Vp > 0;
    
    % Updating Deforestation
    D(1,:,t+1) = D(1,:,t) + Du+Dp;
    % Updating Emissions
    O(1,:,t+1) = O(1,:,t) +  D(1,:,t) .* O_aux;
    % Updating the Agribusiness
    Candidates = D(1,:,t) - Agribusiness(1,:,t); %plots that can gain property rights
    PP = Candidates ==1 & rand(1,N) < pi & L==0; %plots that have earned property rights
    NewAgri = PP==1 & DiffProfit >= R(1,:,t);
    Agribusiness(1,:,t+1) = Agribusiness(1,:,t) + NewAgri;

    set(h, 'CData', D(1,:,t)); % Update heatmap data
    pause(0.1); % Pause for smooth animation

    deforest(t) = sum(D(1,:,t));
    emissions(t) = sum(O(1,:,t));
end

% === Final Heatmaps ===
figure;
subplot(1,2,1)
imagesc(D(1,:,1)); colormap hot; colorbar;
title('Initial Deforestation');

subplot(1,2,2)
imagesc(D(1,:,end)); colormap hot; colorbar;
title('Final Deforestation');

figure;
subplot(1,2,1)
plot(1:Tmax-1, deforest(1:Tmax-1), '-o', 'LineWidth', 1.5);
xlabel('Time');
ylabel('Accumulated Deforestation');
title('Deforestation over Time');
grid on;

subplot(1,2,2)
plot(1:Tmax-1, emissions(1:Tmax-1), '-o', 'LineWidth', 1.5);
xlabel('Time');
ylabel('Emissions');
title('Emissions over Time');
grid on;

