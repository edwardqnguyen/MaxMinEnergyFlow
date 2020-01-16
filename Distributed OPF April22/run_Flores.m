%% Generalized Code to Run DOPF for Flores System, 46 Bus System
%Code Written April 20, 2019
clear all
close all
addpath(genpath('../'))

%% Input Relevant Load / Price Data
n = 46;
%bus_loads = readtable('C:\Users\sruth\Desktop\P2P_Alg\39_Bus_data.csv', 'ReadVariableNames', true, 'ReadRowNames', true );
%bus_loads = csvread('C:\Users\sruth\Desktop\P2P_Alg\8_Bus_data_avg.csv',1,1);


%bus_loads = [0	6.161620405	3.851012753	9.627531883	24.26138035	6.161620405	9.627531883	1.925506377	12.13069017	9.627531883	6.161620405	9.627531883	6.161620405	7.702025506	6.161620405	0.770202551	0.770202551	3.080810203	0	3.851012753	3.851076873	6.161620405	15.40405101	15.40405101	3.851012753	3.851012753	1.925506377	1.925506377	1.925506377	6.161620405	0.962753188	0.962753188	1.925506377	3.851012753	19.25506377	7.699972146	3.080810203	1.925506377	0.962753188	9.627531883	1.925506377	0.962753188	3.85313004	9.627531883	1.925506377	0];
%average bus loads
bus_loads = [0	5.460737971	3.412961232	8.53240308	21.50165576	5.460737971	8.53240308	1.706480616	10.75082788	8.53240308	5.460737971	8.53240308	5.460737971	6.825922464	5.460737971	0.682592246	0.682592246	2.730368986	0	3.412961232	3.413018058	5.460737971	13.65184493	13.65184493	3.412961232	3.412961232	1.706480616	1.706480616	1.706480616	5.460737971	0.853240308	0.853240308	1.706480616	3.412961232	17.06480616	6.824102673	2.730368986	1.706480616	0.853240308	8.53240308	1.706480616	0.853240308	3.414837678	8.53240308	1.706480616	0]; 


%blu = bus_loads(1,:);
%blu = bus loads, hour 1

%LMP = [15.58 14.37 12.96 12.41 13.60 15.34 19.47 20.68]; 
LMP = 252.802013699132 * ones(1,46); 
%for MASS, June 1, 2015, over 24 hours
%% Create DF for 46-Bus Flores System
%Case file
mpc = FloresCase;

%Creation of DF
DF = full(df(mpc.bus,mpc.branch));

%% Flow Limits and such 
%Assuming all of the lines have same flow limit(can create vector) (MW)
Fmax = mpc.branch(:,6); %Fmax should be a b x 1 vector
%Pi is initial power flow inputs for each node (MW)
Pi = -1 * mpc.bus(:,3); 
Pmin = 1.05*Pi; 
Pmax = 0.95*Pi;
Pmax(1) = 1000; %this is substation node

%% Assign elasticities, different ways
%(a,b) with the formula r = a + (b-a).*rand(N,1).
a = -0.3;
b = -0.1;
%eps = a + (b-a).*rand(n,1);
eps = -0.3*ones(n,1);
eps = transpose(eps);
%% CK's Elasticity-Driven Cost Functions
t = 1;
% blu = zeros(24,8);
 
arr = cell(n,1);
slopes = ones(n,1);
b = 0.001*ones(n,1);
a = ones(n,1);

cons = [2:18 20:45];

for j = 1:length(cons)
    k = cons(j);
    a(k) = (LMP(t) * eps(k)) / bus_loads(t,k);
%     a(1) = 2;
%     a(8) = 6*a(4); Debugging numerical errors
    arr{k} = @(x) (b(k)*x^2) + (a(k)*x)+1; 
end

%% Generator inputs; these are not estimates, come from dataset
%switching the sign of their max generation, st - P is generation
Pmax(1) = 2.5;
Pmin(1) = 0;
Pmax(46) = 1.5;
Pmin(46) = 0;
Pmax(19) = 0.6;
Pmin(19) = 0; 
Pi(1) = 1*mpc.gen(1,2);
Pi(46) = 1*mpc.gen(2,2);
Pi(19) = 1*mpc.gen(3,2);

%Cost functions of generators, which is predetermined, not estimated, aka
%DO not change
arr{1} = @(P) 0.11*P.^2  + 261*P + 150;
arr{46} = @(P) 0.085*P.^2 + 88*P  + 600;
arr{19} = @(P) 0.1225*P.^2  + 87*P + 335;



%% Run the system using the generalized function
tic
[P_output,lambda_central, Po, lambda] = flores_dopf(DF,Fmax, Pi, Pmin, Pmax, arr);
toc 
time_DOPF = toc;
disp(toc)
%% Use MATPOWER!!! %In real life, Flores has an AC electricity system
addpath('matpower5.0\')
%Run MARPOWER DCOPF - just to verify 
%results = rundcopf(mpc,options);
results = rundcopf(mpc); 
lam_dcopf = results.bus(:,14);
P_OPF = -results.bus(:,3);
P_OPF(1) = P_OPF(1) + results.gen(1,2);
P_OPF(19) = P_OPF(19) + results.gen(2,2);
P_OPF(46) = P_OPF(46) + results.gen(3,2);
%shadow price
%output.bus(:,14)

%Run ACOPF just in case needed
resultsAC = runopf(mpc);
lam_acopf = resultsAC.bus(:,14);
P_ACOPF = -resultsAC.bus(:,3);
P_ACOPF(1) = P_ACOPF(1) + resultsAC.gen(1,2);
P_ACOPF(19) = P_ACOPF(19) + resultsAC.gen(2,2);
P_ACOPF(46) = P_ACOPF(46) + resultsAC.gen(3,2);


%% Graphs!

figure(1)
plot(1:1:46, P_output, 'linewidth', 2, 'Marker', '*','MarkerSize',3, 'linestyle', '-','Color','g')
hold on
plot(1:1:46, Po, 'linewidth', 2, 'Marker', 'o','MarkerSize',3, 'linestyle', '--','Color','m')
hold on
plot(1:1:46, P_OPF, 'linewidth', 2, 'Marker', '.', 'MarkerSize',3,'linestyle', '-.','Color','c')
%axis([0 46 0 (0.05+max(max([transpose(Po) P_output P_OPF])))])
axis tight
xlabel('Node number')
ylabel('MW')
title('Power Ouptut, All Consumers, Eps = -0.3')
legend('Centralized', 'Distributed','DC OPF')
ax = gca;
ax.FontSize = 12;
ax.FontWeight = 'bold';
xt1 = get(gca, 'XTick');
set(gca, 'FontSize', 15)
yt1 = get(gca, 'YTick');
set(gca, 'FontSize', 10)
%saveas(gcf,'C:\Users\sruth\Desktop\Thesis_Graphs\base_case_power_output_eps3_zoomed.png');

figure(2)
plot(2:1:46, -lambda_central(2:end), 'linewidth', 2, 'Marker', '*','MarkerSize',3, 'linestyle', '-','Color','g')
hold on
plot(2:1:46, -lambda(2:end), 'linewidth', 2, 'Marker', 'o', 'MarkerSize',3,'linestyle', '--','Color','m')
hold on
plot(2:1:46, lam_dcopf(2:end), 'linewidth', 2, 'Marker', '.', 'MarkerSize',3,'linestyle', '-.','Color','c')
hold on
plot(2:1:46, LMP(2:end), 'linewidth', 2,'MarkerSize',3,'linestyle', ':','Color','r')
axis([0 46 0 (5+(max(lam_dcopf)))])
%axis tight
xlabel('Node number')
ylabel('S/MWh')
title('Nodal Prices, Eps = -0.3')
legend('Centralized', 'Distributed','DCOPF','Actual LMP','location','southeast')
ax = gca;
ax.FontSize = 12;
ax.FontWeight = 'bold';
xt1 = get(gca, 'XTick');
set(gca, 'FontSize', 15)
yt1 = get(gca, 'YTick');
set(gca, 'FontSize', 15)
%saveas(gcf,'C:\Users\sruth\Desktop\Thesis_Graphs\base_case_prices_eps3.png');


% hold on
% G = graph(mpc.branch(:,1), mpc.branch(:,2));
% plot(G);
% title('Visual Representation of a 46-Bus Radial Distribution System')
% saveas(gcf,'C:\Users\sruth\Desktop\Thesis_Graphs\topo.png');
%xlim([0 46])
%ylim([-0.4 0.8])
%ylim([0 (5+max(lambda_central))])


%box off
rmpath(genpath('../'))


