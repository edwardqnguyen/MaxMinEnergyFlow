%% Generalized Code to Run DOPF for Flores System, 46 Bus System, with DERs
%Code Written April 20, 2019
clear all
close all

%% Create DF for 46-Bus Flores System
%Case file
mpc = FloresCase;

%Creation of DF
DF = full(df(mpc.bus,mpc.branch));

%% Flow Limits and such 
n = 46;
%Assuming all of the lines have same flow limit(can create vector) (MW)
Fmax = mpc.branch(:,6); %Fmax should be a b x 1 vector
%Pi is initial power flow inputs for each node (MW)
Pi = -1 * mpc.bus(:,3); 
Pmin = 1.05*Pi; 
Pmax = 0.95*Pi;
%Pmax = zeros(size(Pi));
Pmax(1) = 1000; %this is substation node
%% Now, some houses have Rooftop Solar!
houses = [3 8 16 17 18 20 21 25 26 27 28 29 31 32 33 34 37 38 39 41 42 43 45]; 
randomize = transpose(round(rand(length(houses),1)));
%red_PV = nonzeros(houses .* randomize);
red_PV = houses;
num_h = length(red_PV);
total_PV = 0.275546019305119; %(MW)
per_h = total_PV / length(red_PV);

for h = 1:length(houses)
    Pi(h) = Pi(h) + per_h;
    if Pi(h) > 0
    Pmin(h) = 0.95*Pi(h); 
    Pmax(h) = 1.05*Pi(h);
    elseif Pi(h) < 0 
    Pmin(h) = 1.05*Pi(h); 
    Pmax(h) = 0.95*Pi(h);
    end
end
check = 5*ones(1,46);

for i = 1:46
    if Pi(i) < Pmax(i)
    if Pi(i) > Pmin(i)
        check(i) = 1;
    else
        check(i) = 0;
    end
    end
end

%% Now, there is EV Penetration!!
houses = [3 8 16 17 18 20 21 25 26 27 28 29 31 32 33 34 37 38 39 41 42 43 45]; 
randomize = transpose(round(rand(length(houses),1)));
red_EV = nonzeros(houses .* randomize);
%Introducing Flexible Load, In the textbook, 
%combined effects (page 283 is v useful)
%in thesis: say "oh well EV could be a price taker or not, depends on how
%you model them
% no more surplus electricity; because EV can charge at that time
%to begin, i will simply make some customers with a very high load; to see
%how the system responds. I think Power Injection is ~3 kW, let's estimate
%as 0.003 MW.

ev_load = 0.003;

for h = 1:length(red_EV)
    Pi(h) = Pi(h) - ev_load;
    if Pi(h) > 0
    Pmin(h) = 0.95*Pi(h); 
    Pmax(h) = 1.05*Pi(h);
    elseif Pi(h) < 0 
    Pmin(h) = 1.05*Pi(h); 
    Pmax(h) = 0.95*Pi(h);
    end
end
check3 = 5*ones(1,46);

for i = 1:46
    if Pi(i) < Pmax(i)
    if Pi(i) > Pmin(i)
        check3(i) = 1;
    else
        check3(i) = 0;
    end
    end
end




%% Assign elasticities, different ways
%(a,b) with the formula r = a + (b-a).*rand(N,1).
a = -0.3;
b = -0.1;
%eps = a + (b-a).*rand(n,1);
eps = -0.3*ones(n,1);
eps = transpose(eps);

%% Input Relevant Load / Price Data

%bus_loads = readtable('C:\Users\sruth\Desktop\P2P_Alg\39_Bus_data.csv', 'ReadVariableNames', true, 'ReadRowNames', true );
%bus_loads = csvread('C:\Users\sruth\Desktop\P2P_Alg\8_Bus_data_avg.csv',1,1);

%average bus loads
bus_loads = [0	5.460737971	3.412961232	8.53240308	21.50165576	5.460737971	8.53240308	1.706480616	10.75082788	8.53240308	5.460737971	8.53240308	5.460737971	6.825922464	5.460737971	0.682592246	0.682592246	2.730368986	0	3.412961232	3.413018058	5.460737971	13.65184493	13.65184493	3.412961232	3.412961232	1.706480616	1.706480616	1.706480616	5.460737971	0.853240308	0.853240308	1.706480616	3.412961232	17.06480616	6.824102673	2.730368986	1.706480616	0.853240308	8.53240308	1.706480616	0.853240308	3.414837678	8.53240308	1.706480616	0]; 

LMP = 252.802013699132 * ones(1,46); 

%% CK's Elasticity-Driven Cost Functions
t = 1;
% blu = zeros(24,8);
 
arr = cell(n,1);
b = 0.001*ones(n,1);
a = ones(n,1);

cons = [2:18 20:45];

for j = 1:length(cons)
    k = cons(j);
    a(k) = (LMP(k) * eps(k)) / bus_loads(t,k);
%     a(1) = 2;
%     a(8) = 6*a(4); Debugging numerical errors
    arr{k} = @(x) (b(k)*x^2) - (a(k)*x)+1; 
    % arr{k} = @(x) (b(k)*x^2) + (a(k)*x)+1;
end

%% Generator inputs; these are not estimates, come from dataset
%switching the sign of their max generation, st - P is generation
%in Flores, the wind energy is at Node 19, hydro plant is at Node 46,
%diesel is at Node 1
Pmax(1) = 2.5;
Pmin(1) = 0;
Pmax(46) = 1.5;
Pmin(46) = 0;
Pmax(19) = 1.8; %Original Pmax = 0.6 % DONT FORGET TO CHANGE IN CASE FILE AS WELL!
%"moderate Wind/solar case" uses 1.16 as the moderate, 2.2 as the maximum
Pmin(19) = 0; 
Pi(1) = 1*mpc.gen(1,2);
Pi(46) = 1*mpc.gen(2,2);
Pi(19) = 1*mpc.gen(3,2);

%Cost functions of generators, which is predetermined, not estimated, aka
%DO not change
arr{1} = @(P) 0.11*P.^2  + 261*P + 150;
arr{46} = @(P) 0.085*P.^2 + 88*P  + 600;
arr{19} = @(P) 0.1225*P.^2  + 87*P + 335;



%% Run the system using the generalized DOPF function
tic
[P_output,lambda_central, Po, lambda] = flores_dopf(DF,Fmax, Pi, Pmin, Pmax, arr);
toc 
time_DOPF = toc;
disp(toc)

%% sanity check

check2 = 5*ones(1,n);

for i = 1:length(check2)
    if (Po(i) - P_output(1)) < 0.001
        check2(i) = 1;
    else
        check2(i) = 0;
    end
end

    
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
%axis([0 46 -0.20 0.5])
xlabel('Node number')
ylabel('MW')
title(['Power Ouptut with ', num2str(num_h),' Rooftop PVs and EVs'])
legend('Centralized', 'Distributed','DC OPF')
ax = gca;
ax.FontSize = 12;
ax.FontWeight = 'bold';
xt1 = get(gca, 'XTick');
set(gca, 'FontSize', 15)
yt1 = get(gca, 'YTick');
set(gca, 'FontSize', 10)
saveas(gcf,'C:\Users\sruth\Desktop\Thesis_Graphs\power_output_EV.png');

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
ylabel('$/MWh')
title(['Nodal Prices with ',num2str(num_h),' Rooftop PVs and EVs'])
%legend('Centralized', 'Distributed','DCOPF','Actual LMP','location','southeast')
legend('Centralized', 'Distributed','DCOPF','Actual LMP','location','southeast')
ax = gca;
ax.FontSize = 12;
ax.FontWeight = 'bold';
xt1 = get(gca, 'XTick');
set(gca, 'FontSize', 15)
yt1 = get(gca, 'YTick');
set(gca, 'FontSize', 15)
saveas(gcf,'C:\Users\sruth\Desktop\Thesis_Graphs\prices_EV.png');


% hold on
% G = graph(mpc.branch(:,1), mpc.branch(:,2));
% plot(G);
% title('Visual Representation of a 46-Bus Radial Distribution System')
% saveas(gcf,'C:\Users\sruth\Desktop\Thesis_Graphs\topo.png');
%xlim([0 46])
%ylim([-0.4 0.8])
%ylim([0 (5+max(lambda_central))])


%box off


