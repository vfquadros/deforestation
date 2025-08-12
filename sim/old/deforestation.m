% Last version: Aug 7 2025

% ######################################################
% ### Deforestation Model with Agribusiness Dynamics ###
% ######################################################

clear all; clc; close all;
colormap hot;

% ##################
% ### Parameters ###
% ##################

N = 30;
Tmax = 1;                % Number of time periods
beta = 0.01;
alpha = 0.75;
pi = 0.2;
Tlag = 4;                % Time producing at low productivity
sigma = 3;               % Elasticity of demand
delta_n = 1;             % Demand shifter
tau_n = 1.2;             % Transport cost
Gamma = 1 / ((1 - beta) * sigma);
wage = 1;

% #######################
% ### Grid Parameters ###
% #######################

A = 1 + rand(N);         % Productivity > 1
F = 1.44.*ones(N);          % Deforestation cost
L = ones(N);             % Legal status (1 = protected, 0 = unprotected)
L(:, (N/2+1):end) = 0;       % Right half unprotected
w = wage * ones(N);      % Constant wage

% ###################
% ### Time Series ###
% ###################

D = zeros(N, N, Tmax); D(:,:,1) = eye(N);
O = zeros(N, N, Tmax); O_aux = rand(N); O(:,:,1) = eye(N).*O_aux;
R = zeros(N, N, Tmax); R(:,:,1) = (2 + rand(N)) .* ((A - w) ./ (1 - beta));
S = zeros(N, N, Tmax); S(:,:,1) = eye(N);


% ######################
% ### Some Functions ###
% ######################

Sigma = @(S, Sbar, s) sqrt(max(0, Sbar^2 - s*(Sbar - S).^2)); % Inverted U-Shape
B = @(A, S, pI, rho, Sbar, s) pI * (rho - 1) * (A .* Sigma(S, Sbar, s) ./ ...
    (rho * pI)).^(rho / (rho - 1));

for t = 1:Tmax
    % Farmers
    term1 = alpha * A * (1 - beta^Tlag) / (1 - beta);
    term2 = beta^Tlag * (pi * (R(:,:,t)+wage/(1-beta)) + (1 - pi) .* ...
        (A + beta * pi * (R(:,:,t) + wage / (1 - beta))) ./ (1 - beta * (1 - pi)));
    Vu = term1 - F + term2;
    Vp = ((1 - beta^Tlag) * alpha + beta^Tlag) .* A / (1 - beta) - F;

    D_u = L == 0 & D(:,:,t) ~= 1 & Vu > 0; 
    D_p = L == 1 & D(:,:,t) ~= 1 & Vp > 0;

    D(:,:,t+1) = D(:,:,t) + D_u+D_p;
    O(:,:,t+1) = (D_p+D_u) .* O_aux;
    R(:,:,t+1) = R(:,:,t);

    % Agribusiness
end

% === Final Heatmaps ===
figure;
subplot(1,2,1)
imagesc(D(:,:,1)); colormap hot; colorbar;
title('Initial Deforestation');

subplot(1,2,2)
imagesc(D(:,:,end)); colormap hot; colorbar;
title('Final Deforestation');

Agribusiness
D