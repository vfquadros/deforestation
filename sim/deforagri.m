% ########################
% ### 1D deforestation ###
% ########################

% Last version: Aug 7 2025

% ######################################################
% ### Deforestation Model with Agribusiness Dynamics ###
% ######################################################

clear all; clc; close all;
colormap hot;

addpath functions\

% ##################
% ### Parameters ###
% ##################

global N beta alpha pi elasticity wage Tlag Sbar tau delta pI rho

i = 1; % 0 = pi is zero and A decreasing
      % 1 = Agribusiness in the vertex
      % 2 = Agribusiness in the middle

% #######################################
% ### pi =0 and A decreasing (static) ###
% #######################################


if i == 0 
    N = 15;
    Tmax = 25;            % Number of time periods
    beta = 0.10;
    alpha = 0.75;
    pi = 0;
    Tlag = 2;              % Time producing at low productivity
    delta = 1;             % Demand shifter
    tau = 1.2;             % Transport cost
    wage = 1;
    elasticity = 1.5;
    Sbar =6;
    pI = 1;
    rho = 1.5;
    
    A = linspace(3.1,1.1, N);                % Productivity > 1
    F = 1.8*ones(1,N);               % Homogeneous deforestation cost
    L = zeros(1,N); L(1,1:N/2) = 1;  % Legal status (1 = protected, 0 = unprotected)
                                     % everything is protected (static case)
    w = wage * ones(1,N);            % Constant wage
    
    D = zeros(1, N, Tmax); D(1,1,1) = 1; % Agrinusiness starts in one of the vertices
    O = zeros(1, N, Tmax); O_aux = rand(1,N); O(:,:,1) = D(1,1,1).*O_aux;
    Agribusiness = zeros(1, N, Tmax); Agribusiness(1,1,1) = 1; % Agribusiness starts in one of the vertices
    
    SolveDeforestation1D(N,Tmax,A,F,O,D,L,Agribusiness,O_aux)
end
% ##################################
% ### Agribusiness in the vertex ###
% ##################################

if i == 1
    N = 15;
    Tmax = 25;            % Number of time periods
    beta = 0.10;
    alpha = 0.75;
    pi = 0.5;
    Tlag = 2;              % Time producing at low productivity
    delta = 1;             % Demand shifter
    tau = 1.2;             % Transport cost
    wage = 1;
    elasticity = 1.5;
    Sbar =6;
    pI = 1;
    rho = 1.5;
    
    A = 2.*ones(1,N);                % Productivity > 1
    F = 1.8*ones(1,N);               % Homogeneous deforestation cost
    L = zeros(1,N); L(1,1:N/2) = 1;  % Legal status (1 = protected, 0 = unprotected)
                                     % everything is protected (static case)
    w = wage * ones(1,N);            % Constant wage
    
    D = zeros(1, N, Tmax); D(1,end,1) = 1; % Agrinusiness starts in one of the vertices
    O = zeros(1, N, Tmax); O_aux = rand(1,N); O(:,:,1) = D(1,1,1).*O_aux;
    R = zeros(1, N, Tmax); 
    Agribusiness = zeros(1, N, Tmax); Agribusiness(1,end,1) = 1; % Agrinusiness starts in one of the vertices
    
    SolveDeforestation1D(N,Tmax,A,F,O,D,L,Agribusiness,O_aux)
end

% ##################################
% ### Agribusiness in the middle ###
% ##################################

if i == 2
    N = 15;
    Tmax = 25;            % Number of time periods
    beta = 0.10;
    alpha = 0.7;
    pi = 0.55;
    Tlag = 2;              % Time producing at low productivity
    delta = 1;             % Demand shifter
    tau = 1.2;             % Transport cost
    wage = 1;
    elasticity = 1.5;
    Sbar =6;
    pI = 1;
    rho = 1.5;
    
    A = 2.1.*ones(1,N);                       % Productivity > 1
    F = 1.65*ones(1,N);                      % Homogeneous deforestation cost
    L = zeros(1,N); L(1,2) = 1; L(1,13) = 1;  % Legal status (1 = protected, 0 = unprotected)
    w = wage * ones(1,N);                   % Constant wage
    
    D = zeros(1, N, Tmax); D(1,8,1) = 1; % Agrinusiness starts in one of the middle
    O = zeros(1, N, Tmax); O_aux = rand(1,N); O(:,:,1) = D(1,1,1).*O_aux;
    R = zeros(1, N, Tmax); 
    Agribusiness = zeros(1, N, Tmax); Agribusiness(1,8,1) = 1; % Agrinusiness starts in one of the vertices
    
    SolveDeforestation1D(N,Tmax,A,F,O,D,L,Agribusiness,O_aux)
end
