function [P_output,lambda_central, Po, lambda] = flores_dopf(DF,Fmax, Pi, Pmin, Pmax, arr)
%A Function to run the Flores system during different hours / different
%prices of the day


%% System Configuration; remains constant for Flores 
n = 46; %number of buses
np = [0; 1; 2; 3; 4; 5; 1; 1; 8; 9; 10; 11; 12; 13; 14; 15; 1; 17; 18; 19; 20; 21; 22; 23; 24; 25; 26; 18; 28; 28; 35; 31; 32; 33; 18; 35; 36; 37; 38; 39; 1; 41; 42; 43; 43; 1]; %Each node's Parent
tier_12 = [27];
tier_11 = [26];
tier_10 = [16 25];
tier_9 = [15 24 40];
tier_8 = [14 23 34 39];
tier_7 = [13 22 33 38];
tier_6 = [6 12 21 32 37];
tier_5 = [5 11 20 29 30 31 36 44 45];
tier_4 = [4 10 19 28 35 43];
tier_3 = [3 9 18 42];
tier_2 = [2 7 8 17 41 46];
tier_top = [1];

br1_mid = [5 4 3 2];
br3_mid = [15 14 13 12 11 10 9 8];
br4a_mid = [26 25 24 23 22 21 20 19];
br4c1_mid = [33 32 31];
br4c2_mid = [39 38 37 36];
br5_mid = [43 42 41];

leaves = [6 7 16 27 29 30 34 40 44 45 46];
br = [0 1 6 7 8 9 2 3 10 11 12 13 14 15 16 17 4 18 19 22 23 24 25 26 27 28 29 20 30 31 35 32 33 34 21 36 37 38 39 40 5 41 42 43 44 45];

chi = cell(n,1);
chi{1} = [2 7 8 17 41 46];
chi{2} = [3];
chi{3} = [4];
chi{4} = [5];
chi{5} = [6];
chi{6} = [];
chi{7} = [];
chi{8} = [9];
chi{9} = [10];
chi{10} = [11];
chi{11} = [12];
chi{12} = [13];
chi{13} = [14];
chi{14} = [15];
chi{15} = [16];
chi{16} = [];
chi{17} = [18];
chi{18} = [19 28 35];
chi{19} = [20];
chi{20} = [21];
chi{21} = [22];
chi{22} = [23];
chi{23} = [24];
chi{24} = [25];
chi{25} = [26];
chi{26} = [27];
chi{27} = [];
chi{28} = [29 30];
chi{29} = [];
chi{30} = [];
chi{31} = [32];
chi{32} = [33];
chi{33} = [34];
chi{34} = [];
chi{35} = [31 36];
chi{36} = [37];
chi{37} = [38];
chi{38} = [39];
chi{39} = [40];
chi{40} = [];
chi{41} = [42];
chi{42} = [43];
chi{43} = [44 45];
chi{44} = [];
chi{45} = [];
chi{46} = [];

%In theory, this shouldn't change
%br = [0:1:n-1]; %The branch above respective node
Po = zeros(1,n);
ch = cell(n,1);
n_lb = zeros(1,n);
n_ub = zeros(1,n);
bid_funcs = cell(n,1);
LinFac = cell(n,1);
QuadFac = cell(n,1);
y_fin = zeros(1,n);
lambda = zeros(1,n);


%% Centralized OPF 
disp("Centralized OPF")
% Key differences: inputs all constraints, uses all cost functions, and
% initial Pi for all nodes
fun = find_func(arr,n);
[P_output,lambda_temp] = centralized_g(fun,DF,Fmax,Pi,Pmin,Pmax);
lambda_central = repmat(lambda_temp.eqlin, 1, size(lambda,2));


%% Nested Aggregation!
disp("Nested Agg,generalized, let's goooo")

%% Calc bid func for all of the leaves

for i = 1:length(leaves)
    l = leaves(i);
    [bid_funcs{l},n_lb(l),n_ub(l), LinFac{l}, QuadFac{l}] = bid_leaf(l,br(l),arr{l},Pi,Pmin,Pmax,Fmax); 
end

%% Branch1, mid-nodes, on the way up
mid = br1_mid;
for i = 1:length(mid)
    n = mid(i);
fun = @(P) arr{n}(P(1)) + bid_funcs{chi{n}(1)}(P(2));
[bid_funcs{n},n_lb(n),n_ub(n), LinFac{n}, QuadFac{n}] = bid_mid(n,br(n),chi{n},n_lb,n_ub,fun,Pi,Pmin,Pmax,Fmax);
end


%% Branch3, mid-nodes, on the way up
mid = br3_mid;

for i = 1:length(mid)
    n = mid(i);
fun = @(P) arr{n}(P(1)) + bid_funcs{chi{n}(1)}(P(2));
[bid_funcs{n},n_lb(n),n_ub(n), LinFac{n}, QuadFac{n}] = bid_mid(n,br(n),chi{n},n_lb,n_ub,fun,Pi,Pmin,Pmax,Fmax);
end

%% Branch4a, mid-nodes, on the way up
mid = br4a_mid;
%mid = [26    25    24    23    22    21    20];

for i = 1:length(mid)
    n = mid(i);
fun = @(P) arr{n}(P(1)) + bid_funcs{chi{n}(1)}(P(2));
[bid_funcs{n},n_lb(n),n_ub(n), LinFac{n}, QuadFac{n}] = bid_mid(n,br(n),chi{n},n_lb,n_ub,fun,Pi,Pmin,Pmax,Fmax);
end


%% Branch 4b
mid = 28;
for i = 1:length(mid)
    n = mid(i);

fun = @(P) arr{n}(P(1)) + bid_funcs{chi{n}(1)}(P(2)) + bid_funcs{chi{n}(2)}(P(3));

[bid_funcs{n},n_lb(n),n_ub(n), LinFac{n}, QuadFac{n}] = bid_mid(n,br(n),chi{n},n_lb,n_ub,fun,Pi,Pmin,Pmax,Fmax);
end

%% Branch4c1, mid-nodes, on the way up
mid = br4c1_mid;
%mid = [26    25    24    23    22    21    20];

for i = 1:length(mid)
    n = mid(i);
fun = @(P) arr{n}(P(1)) + bid_funcs{chi{n}(1)}(P(2));
[bid_funcs{n},n_lb(n),n_ub(n), LinFac{n}, QuadFac{n}] = bid_mid(n,br(n),chi{n},n_lb,n_ub,fun,Pi,Pmin,Pmax,Fmax);
end

%% Branch4c2, mid-nodes, on the way up
mid = br4c2_mid;
%mid = [26    25    24    23    22    21    20];

for i = 1:length(mid)
    n = mid(i);
fun = @(P) arr{n}(P(1)) + bid_funcs{chi{n}(1)}(P(2));
[bid_funcs{n},n_lb(n),n_ub(n)] = bid_mid(n,br(n),chi{n},n_lb,n_ub,fun,Pi,Pmin,Pmax,Fmax);
end

%% Branch 4c, convergence
mid = 35;
for i = 1:length(mid)
    n = mid(i);

fun = @(P) arr{n}(P(1)) + bid_funcs{chi{n}(1)}(P(2)) + bid_funcs{chi{n}(2)}(P(3));

[bid_funcs{n},n_lb(n),n_ub(n),LinFac{n}, QuadFac{n}] = bid_mid(n,br(n),chi{n},n_lb,n_ub,fun,Pi,Pmin,Pmax,Fmax);
end
%% Convergence of Branch 4abc

n = 18;
fun = @(P) arr{n}(P(1)) + bid_funcs{chi{n}(1)}(P(2)) + bid_funcs{chi{n}(2)}(P(3)) + bid_funcs{chi{n}(3)}(P(4));

[bid_funcs{n},n_lb(n),n_ub(n), LinFac{n}, QuadFac{n}] = bid_mid(n,br(n),chi{n},n_lb,n_ub,fun,Pi,Pmin,Pmax,Fmax);

%% Node 17

n = 17;
fun = @(P) arr{n}(P(1)) + bid_funcs{chi{n}(1)}(P(2));
[bid_funcs{n},n_lb(n),n_ub(n), LinFac{n}, QuadFac{n}] = bid_mid(n,br(n),chi{n},n_lb,n_ub,fun,Pi,Pmin,Pmax,Fmax);

%% Branch 5, on the way up 
mid = br5_mid;

for i = 1:length(mid)
    n = mid(i);
if length(chi{n}) == 2
fun = @(P) arr{n}(P(1)) + bid_funcs{chi{n}(1)}(P(2)) + bid_funcs{chi{n}(2)}(P(3));
elseif length(chi{n}) == 1
fun = @(P) arr{n}(P(1)) + bid_funcs{chi{n}(1)}(P(2));
end

[bid_funcs{n},n_lb(n),n_ub(n), LinFac{n}, QuadFac{n}] = bid_mid(n,br(n),chi{n},n_lb,n_ub,fun,Pi,Pmin,Pmax,Fmax);
end

%% Downwards Dispatch Sweep
disp("We're going downnnnn")
%% Node 1
n = 1;
ch_lb = n_lb(chi{n});
ch_ub = n_ub(chi{n});

fun = @(P) arr{n}(P(1)) + bid_funcs{chi{n}(1)}(P(2)) + bid_funcs{chi{n}(2)}(P(3)) + bid_funcs{chi{n}(3)}(P(4)) + bid_funcs{chi{n}(4)}(P(5))...
    + bid_funcs{chi{n}(5)}(P(6)) + bid_funcs{chi{n}(6)}(P(7));

b = strsplit(char(arr{n}),'+');
Quad = str2double(extractBefore(extractAfter(b{1},'@(P)'),'*'));
Lin = str2double(extractBefore(b{2},'*'));
LinFacMat = [Lin, [LinFac{chi{n}(1:end)}]];
QuadFacMat = [Quad, [QuadFac{chi{n}(1:end)}]];
[Po(n),y_fin(chi{n}), lambda(chi{n})] = dis_down_ss(n,ch_lb, ch_ub,fun,Pi,Pmin,Pmax, LinFacMat, QuadFacMat);

%% Coming down to Tier 2
mid = tier_2;
%mid = 7;
for i = 1:length(mid)
    n = mid(i);
if isempty(chi{n})
    fun = @(P) arr{n}(P(1)) - lambda(n)*P(2);
elseif length(chi{n}) == 1
    fun = @(P) arr{n}(P(1)) + bid_funcs{chi{n}(1)}(P(2)) - lambda(n)*P(3);
elseif length(chi{n}) == 2
    fun = @(P) arr{n}(P(1)) + bid_funcs{chi{n}(1)}(P(2)) + bid_funcs{chi{n}(2)}(P(3)) - lambda(n)*P(4);
elseif length(chi{n}) == 3
    fun = @(P) arr{n}(P(1)) + bid_funcs{chi{n}(1)}(P(2)) + bid_funcs{chi{n}(2)}(P(3)) + bid_funcs{chi{n}(3)}(P(4)) - lambda(n)*P(5);
end

b = strsplit(char(arr{n}),'+');
Quad = str2double(extractBefore(extractAfter(b{1},'@(P)'),'*'));
Lin = str2double(extractBefore(b{2},'*'));
LinFacMat = [Lin, [LinFac{chi{n}(1:end)}], -lambda(n)];
QuadFacMat = [Quad, [QuadFac{chi{n}(1:end)}], 0.001];
[Po(n),y_fin(chi{n}), lambda(chi{n})] = dis_down_mid(n,br(n),np(n),chi{n},n_ub, n_lb,fun,Pi,Po,y_fin,Pmin,Pmax,DF,Fmax, lambda, LinFacMat, QuadFacMat);

end

%% Coming down to Tier 3
mid = tier_3;
%mid = 7;
for i = 1:length(mid)
    n = mid(i);
if isempty(chi{n})
    fun = @(P) arr{n}(P(1)) - lambda(n)*P(2);
elseif length(chi{n}) == 1
    fun = @(P) arr{n}(P(1)) + bid_funcs{chi{n}(1)}(P(2)) - lambda(n)*P(3);
elseif length(chi{n}) == 2
    fun = @(P) arr{n}(P(1)) + bid_funcs{chi{n}(1)}(P(2)) + bid_funcs{chi{n}(2)}(P(3)) - lambda(n)*P(4);
elseif length(chi{n}) == 3
    fun = @(P) arr{n}(P(1)) + bid_funcs{chi{n}(1)}(P(2)) + bid_funcs{chi{n}(2)}(P(3)) + bid_funcs{chi{n}(3)}(P(4)) - lambda(n)*P(5);
end

b = strsplit(char(arr{n}),'+');
Quad = str2double(extractBefore(extractAfter(b{1},'@(P)'),'*'));
Lin = str2double(extractBefore(b{2},'*'));
LinFacMat = [Lin, [LinFac{chi{n}(1:end)}], -lambda(n)];
QuadFacMat = [Quad, [QuadFac{chi{n}(1:end)}], 0.001];
[Po(n),y_fin(chi{n}), lambda(chi{n})] = dis_down_mid(n,br(n),np(n),chi{n},n_ub, n_lb,fun,Pi,Po,y_fin,Pmin,Pmax,DF,Fmax, lambda, LinFacMat, QuadFacMat);

end

%% Coming down to Tier 4
mid = tier_4;
%mid = 7;
for i = 1:length(mid)
    n = mid(i);
if isempty(chi{n})
    fun = @(P) arr{n}(P(1)) - lambda(n)*P(2);
elseif length(chi{n}) == 1
    fun = @(P) arr{n}(P(1)) + bid_funcs{chi{n}(1)}(P(2))- lambda(n)*P(3);
elseif length(chi{n}) == 2
    fun = @(P) arr{n}(P(1)) + bid_funcs{chi{n}(1)}(P(2)) + bid_funcs{chi{n}(2)}(P(3))- lambda(n)*P(4);
elseif length(chi{n}) == 3
    fun = @(P) arr{n}(P(1)) + bid_funcs{chi{n}(1)}(P(2)) + bid_funcs{chi{n}(2)}(P(3)) + bid_funcs{chi{n}(3)}(P(4))- lambda(n)*P(5);
end

b = strsplit(char(arr{n}),'+');
Quad = str2double(extractBefore(extractAfter(b{1},'@(P)'),'*'));
Lin = str2double(extractBefore(b{2},'*'));
LinFacMat = [Lin, [LinFac{chi{n}(1:end)}], -lambda(n)];
QuadFacMat = [Quad, [QuadFac{chi{n}(1:end)}], 0.001];
[Po(n),y_fin(chi{n}), lambda(chi{n})] = dis_down_mid(n,br(n),np(n),chi{n},n_ub, n_lb,fun,Pi,Po,y_fin,Pmin,Pmax,DF,Fmax, lambda, LinFacMat, QuadFacMat);
end

%% Coming down to Tier 5
mid = tier_5;
%mid = 7;
for i = 1:length(mid)
    n = mid(i);
if isempty(chi{n})
    fun = @(P) arr{n}(P(1)) - lambda(n)*P(2);
elseif length(chi{n}) == 1
    fun = @(P) arr{n}(P(1)) + bid_funcs{chi{n}(1)}(P(2))- lambda(n)*P(3);
elseif length(chi{n}) == 2
    fun = @(P) arr{n}(P(1)) + bid_funcs{chi{n}(1)}(P(2)) + bid_funcs{chi{n}(2)}(P(3))- lambda(n)*P(4);
elseif length(chi{n}) == 3
    fun = @(P) arr{n}(P(1)) + bid_funcs{chi{n}(1)}(P(2)) + bid_funcs{chi{n}(2)}(P(3)) + bid_funcs{chi{n}(3)}(P(4))- lambda(n)*P(5);
end

b = strsplit(char(arr{n}),'+');
Quad = str2double(extractBefore(extractAfter(b{1},'@(P)'),'*'));
Lin = str2double(extractBefore(b{2},'*'));
LinFacMat = [Lin, [LinFac{chi{n}(1:end)}], -lambda(n)];
QuadFacMat = [Quad, [QuadFac{chi{n}(1:end)}], 0.001];
[Po(n),y_fin(chi{n}), lambda(chi{n})] = dis_down_mid(n,br(n),np(n),chi{n},n_ub, n_lb,fun,Pi,Po,y_fin,Pmin,Pmax,DF,Fmax, lambda, LinFacMat, QuadFacMat);

end

%% Coming down to Tier 6
mid = tier_6;
%mid = 7;
for i = 1:length(mid)
    n = mid(i);
if isempty(chi{n})
    fun = @(P) arr{n}(P(1))- lambda(n)*P(2);
elseif length(chi{n}) == 1
    fun = @(P) arr{n}(P(1)) + bid_funcs{chi{n}(1)}(P(2))- lambda(n)*P(3);
elseif length(chi{n}) == 2
    fun = @(P) arr{n}(P(1)) + bid_funcs{chi{n}(1)}(P(2)) + bid_funcs{chi{n}(2)}(P(3))- lambda(n)*P(4);
elseif length(chi{n}) == 3
    fun = @(P) arr{n}(P(1)) + bid_funcs{chi{n}(1)}(P(2)) + bid_funcs{chi{n}(2)}(P(3)) + bid_funcs{chi{n}(3)}(P(4))- lambda(n)*P(5);
end

b = strsplit(char(arr{n}),'+');
Quad = str2double(extractBefore(extractAfter(b{1},'@(P)'),'*'));
Lin = str2double(extractBefore(b{2},'*'));
LinFacMat = [Lin, [LinFac{chi{n}(1:end)}], -lambda(n)];
QuadFacMat = [Quad, [QuadFac{chi{n}(1:end)}], 0.001];
[Po(n),y_fin(chi{n}), lambda(chi{n})] = dis_down_mid(n,br(n),np(n),chi{n},n_ub, n_lb,fun,Pi,Po,y_fin,Pmin,Pmax,DF,Fmax, lambda, LinFacMat, QuadFacMat);

end

%% Coming down to Tier 7
mid = tier_7;
%mid = 7;
for i = 1:length(mid)
    n = mid(i);
if isempty(chi{n})
    fun = @(P) arr{n}(P(1))- lambda(n)*P(2);
elseif length(chi{n}) == 1
    fun = @(P) arr{n}(P(1)) + bid_funcs{chi{n}(1)}(P(2))- lambda(n)*P(3);
elseif length(chi{n}) == 2
    fun = @(P) arr{n}(P(1)) + bid_funcs{chi{n}(1)}(P(2)) + bid_funcs{chi{n}(2)}(P(3))- lambda(n)*P(4);
elseif length(chi{n}) == 3
    fun = @(P) arr{n}(P(1)) + bid_funcs{chi{n}(1)}(P(2)) + bid_funcs{chi{n}(2)}(P(3)) + bid_funcs{chi{n}(3)}(P(4))- lambda(n)*P(5);
end

b = strsplit(char(arr{n}),'+');
Quad = str2double(extractBefore(extractAfter(b{1},'@(P)'),'*'));
Lin = str2double(extractBefore(b{2},'*'));
LinFacMat = [Lin, [LinFac{chi{n}(1:end)}], -lambda(n)];
QuadFacMat = [Quad, [QuadFac{chi{n}(1:end)}], 0.001];
[Po(n),y_fin(chi{n}), lambda(chi{n})] = dis_down_mid(n,br(n),np(n),chi{n},n_ub, n_lb,fun,Pi,Po,y_fin,Pmin,Pmax,DF,Fmax, lambda, LinFacMat, QuadFacMat);

end

%% Coming down to Tier 8
mid = tier_8;
%mid = 7;
for i = 1:length(mid)
    n = mid(i);
if isempty(chi{n})
    fun = @(P) arr{n}(P(1))- lambda(n)*P(2);
elseif length(chi{n}) == 1
    fun = @(P) arr{n}(P(1)) + bid_funcs{chi{n}(1)}(P(2))- lambda(n)*P(3);
end

b = strsplit(char(arr{n}),'+');
Quad = str2double(extractBefore(extractAfter(b{1},'@(P)'),'*'));
Lin = str2double(extractBefore(b{2},'*'));
LinFacMat = [Lin, [LinFac{chi{n}(1:end)}], -lambda(n)];
QuadFacMat = [Quad, [QuadFac{chi{n}(1:end)}], 0.001];
[Po(n),y_fin(chi{n}), lambda(chi{n})] = dis_down_mid(n,br(n),np(n),chi{n},n_ub, n_lb,fun,Pi,Po,y_fin,Pmin,Pmax,DF,Fmax, lambda, LinFacMat, QuadFacMat);

end

%% Coming down to Tier 9
mid = tier_9;
%mid = 7;
for i = 1:length(mid)
    n = mid(i);
if isempty(chi{n})
    fun = @(P) arr{n}(P(1)) - lambda(n)*P(2);
elseif length(chi{n}) == 1
    fun = @(P) arr{n}(P(1)) + bid_funcs{chi{n}(1)}(P(2))- lambda(n)*P(3);
end

b = strsplit(char(arr{n}),'+');
Quad = str2double(extractBefore(extractAfter(b{1},'@(P)'),'*'));
Lin = str2double(extractBefore(b{2},'*'));
LinFacMat = [Lin, [LinFac{chi{n}(1:end)}], -lambda(n)];
QuadFacMat = [Quad, [QuadFac{chi{n}(1:end)}], 0.001];
[Po(n),y_fin(chi{n}), lambda(chi{n})] = dis_down_mid(n,br(n),np(n),chi{n},n_ub, n_lb,fun,Pi,Po,y_fin,Pmin,Pmax,DF,Fmax, lambda, LinFacMat, QuadFacMat);

end

%% Coming down to Tier 10
mid = tier_10;
%mid = 7;
for i = 1:length(mid)
    n = mid(i);
if isempty(chi{n})
    fun = @(P) arr{n}(P(1)) - lambda(n)*P(2);
elseif length(chi{n}) == 1
    fun = @(P) arr{n}(P(1)) + bid_funcs{chi{n}(1)}(P(2))- lambda(n)*P(3);
end

b = strsplit(char(arr{n}),'+');
Quad = str2double(extractBefore(extractAfter(b{1},'@(P)'),'*'));
Lin = str2double(extractBefore(b{2},'*'));
LinFacMat = [Lin, [LinFac{chi{n}(1:end)}], -lambda(n)];
QuadFacMat = [Quad, [QuadFac{chi{n}(1:end)}], 0.001];
[Po(n),y_fin(chi{n}), lambda(chi{n})] = dis_down_mid(n,br(n),np(n),chi{n},n_ub, n_lb,fun,Pi,Po,y_fin,Pmin,Pmax,DF,Fmax, lambda, LinFacMat, QuadFacMat);

end
%% Coming down to Tier 11
mid = tier_11;
%mid = 7;
for i = 1:length(mid)
    n = mid(i);
if isempty(chi{n})
    fun = @(P) arr{n}(P(1))- lambda(n)*P(2);
elseif length(chi{n}) == 1
    fun = @(P) arr{n}(P(1)) + bid_funcs{chi{n}(1)}(P(2))- lambda(n)*P(3);
end

b = strsplit(char(arr{n}),'+');
Quad = str2double(extractBefore(extractAfter(b{1},'@(P)'),'*'));
Lin = str2double(extractBefore(b{2},'*'));
LinFacMat = [Lin, [LinFac{chi{n}(1:end)}], -lambda(n)];
QuadFacMat = [Quad, [QuadFac{chi{n}(1:end)}], 0.001];
[Po(n),y_fin(chi{n}), lambda(chi{n})] = dis_down_mid(n,br(n),np(n),chi{n},n_ub, n_lb,fun,Pi,Po,y_fin,Pmin,Pmax,DF,Fmax, lambda, LinFacMat, QuadFacMat);

end

%% Coming down to Tier 12
mid = tier_12;
%mid = 7;
for i = 1:length(mid)
    n = mid(i);
if isempty(chi{n})
    fun = @(P) arr{n}(P(1))- lambda(n)*P(2);
elseif length(chi{n}) == 1
    fun = @(P) arr{n}(P(1)) + bid_funcs{chi{n}(1)}(P(2))- lambda(n)*P(3);
end

b = strsplit(char(arr{n}),'+');
Quad = str2double(extractBefore(extractAfter(b{1},'@(P)'),'*'));
Lin = str2double(extractBefore(b{2},'*'));
LinFacMat = [Lin, [LinFac{chi{n}(1:end)}], -lambda(n)];
QuadFacMat = [Quad, [QuadFac{chi{n}(1:end)}], 0.001];
[Po(n),y_fin(chi{n}), lambda(chi{n})] = dis_down_mid(n,br(n),np(n),chi{n},n_ub, n_lb,fun,Pi,Po,y_fin,Pmin,Pmax,DF,Fmax, lambda, LinFacMat, QuadFacMat);

end


end

