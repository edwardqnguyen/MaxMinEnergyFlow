function mpc = caseMicro
%CASE9    Power flow data for Lincoln Lab microgrid
%   Please see CASEFORMAT for details on the case file format.
%
%   Based on data from Joe H. Chow's book, p. 70.

%   MATPOWER
%   $Id: case9.m 2408 2014-10-22 20:41:33Z ray $

%% MATPOWER Case Format : Version 2
mpc.version = '2';

%%-----  Power Flow Data  -----%%
%% system MVA base
mpc.baseMVA = 4;

%% bus data
Vmin = 0;
Vmax = 10;
%Init loads
%	bus_i	type	Pd	Qd	Gs	Bs	area	Vm	Va	baseKV	zone	Vmax	Vmin
mpc.bus = [
1	1	0	0	0	0	1	1	0	13.8	1	Vmax	Vmin
2	1	1.186425	0.61481875	0	0	1	1	0	0.46	1	Vmax	Vmin
3	1	0	0	0	0	1	1	0	13.8	1	Vmax	Vmin
4	1	0	0	0	0	1	1	0	13.8	1	Vmax	Vmin
5	1	0	0	0	0	1	1	0	4.16	1	Vmax	Vmin
6	1	0	0	0	0	1	1	0	13.8	1	Vmax	Vmin
7	1	0	0	0	0	1	1	0	13.8	1	Vmax	Vmin
8	1	0	0	0	0	1	1	0	4.16	1	Vmax	Vmin
9	1	0	0	0	0	1	1	0	4.16	1	Vmax	Vmin
10	1	0	0	0	0	1	1	0	4.16	1	Vmax	Vmin
11	1	0.22	0.01	0	0	1	1	0	0.46	1	Vmax	Vmin
12	1	0.14	0.09	0	0	1	1	0	0.46	1	Vmax	Vmin
13	1	0.16	0.09	0	0	1	1	0	0.46	1	Vmax	Vmin
14	1	0.706425	0.63981875	0	0	1	1	0	0.46	1	Vmax	Vmin
15	1	2.5	1.2	0	0	1	1	0	0.46	1	Vmax	Vmin
16	1	0.09	0.042	0	0	1	1	0	0.46	1	Vmax	Vmin
17	1	0.14	0.01	0	0	1	1	0	0.208	1	Vmax	Vmin
18	1	0.28	0.1	0	0	1	1	0	0.208	1	Vmax	Vmin
19	1	0.78	0.42	0	0	1	1	0	0.208	1	Vmax	Vmin
20	1	0	0	0	0	1	1	0	2.4	1	Vmax	Vmin
21	1	-0.5	-0.01*10	0	0	1	1	0	2.4	1	Vmax	Vmin
22	3	0	0	0	0	1	1	0	13.8	1	Vmax	Vmin
23	2	0	0	0	0	1	1	0	0.46	1	Vmax	Vmin
];
%%
%at t=7000sec
%	bus_i	type	Pd	Qd	Gs	Bs	area	Vm	Va	baseKV	zone	Vmax	Vmin
% mpc.bus = [
% 1	1	0	0	0	0	1	1	0	13.8	1	1.05	0.95
% 2	1	1.186425	0.61481875	0	0	1	1	0	0.46	1	1.05	0.95
% 3	1	0	0	0	0	1	1	0	13.8	1	1.05	0.95
% 4	1	0	0	0	0	1	1	0	13.8	1	1.05	0.95
% 5	1	0	0	0	0	1	1	0	4.16	1	1.05	0.95
% 6	1	0	0	0	0	1	1	0	13.8	1	1.05	0.95
% 7	1	0	0	0	0	1	1	0	13.8	1	1.05	0.95
% 8	1	0	0	0	0	1	1	0	4.16	1	1.05	0.95
% 9	1	0	0	0	0	1	1	0	4.16	1	1.05	0.95
% 10	1	0	0	0	0	1	1	0	4.16	1	1.05	0.95
% 11	1	0.26	0.015	0	0	1	1	0	0.46	1	1.05	0.95
% 12	1	0.25	0.11	0	0	1	1	0	0.46	1	1.05	0.95
% 13	1	0.2	0.1	0	0	1	1	0	0.46	1	1.05	0.95
% 14	1	0.886425	0.82981875	0	0	1	1	0	0.46	1	1.05	0.95
% 15	1	2.5	1.2	0	0	1	1	0	0.46	1	1.05	0.95
% 16	1	0.09	0.042	0	0	1	1	0	0.46	1	1.05	0.95
% 17	1	0.26	0.03	0	0	1	1	0	0.208	1	1.05	0.95
% 18	1	0.59	0.2	0	0	1	1	0	0.208	1	1.05	0.95
% 19	1	0.93	0.43	0	0	1	1	0	0.208	1	1.05	0.95
% 20	1	0	0	0	0	1	1	0	2.4	1	1.05	0.95
% 21	1	-0.8	-0.01	0	0	1	1	0	2.4	1	1.05	0.95
% 22	3	0	0	0	0	1	1	0	13.8	1	1.05	0.95
% 23	2	0	0	0	0	1	1	0	0.46	1	1.05	0.95
% ];
%%
%worst case loading
%	bus_i	type	Pd	Qd	Gs	Bs	area	Vm	Va	baseKV	zone	Vmax	Vmin
% mpc.bus = [
% 1	1	0	0	0	0	1	1	0	13.8	1	1.05	0.95
% 2	1	1.186425	0.61481875	0	0	1	1	0	0.46	1	1.05	0.95
% 3	1	0	0	0	0	1	1	0	13.8	1	1.05	0.95
% 4	1	0	0	0	0	1	1	0	13.8	1	1.05	0.95
% 5	1	0	0	0	0	1	1	0	4.16	1	1.05	0.95
% 6	1	0	0	0	0	1	1	0	13.8	1	1.05	0.95
% 7	1	0	0	0	0	1	1	0	13.8	1	1.05	0.95
% 8	1	0	0	0	0	1	1	0	4.16	1	1.05	0.95
% 9	1	0	0	0	0	1	1	0	4.16	1	1.05	0.95
% 10	1	0	0	0	0	1	1	0	4.16	1	1.05	0.95
% 11	1	0.28	0.015	0	0	1	1	0	0.46	1	1.05	0.95
% 12	1	0.25	0.11	0	0	1	1	0	0.46	1	1.05	0.95
% 13	1	0.21	0.1	0	0	1	1	0	0.46	1	1.05	0.95
% 14	1	0.996425	0.84981875	0	0	1	1	0	0.46	1	1.05	0.95
% 15	1	2.5	1.2	0	0	1	1	0	0.46	1	1.05	0.95
% 16	1	0.09	0.042	0	0	1	1	0	0.46	1	1.05	0.95
% 17	1	0.26	0.03	0	0	1	1	0	0.208	1	1.05	0.95
% 18	1	0.59	0.2	0	0	1	1	0	0.208	1	1.05	0.95
% 19	1	0.94	0.43	0	0	1	1	0	0.208	1	1.05	0.95
% 20	1	0	0	0	0	1	1	0	2.4	1	1.05	0.95
% 21	1	-1.75	-0.01	0	0	1	1	0	2.4	1	1.05	0.95
% 22	3	0	0	0	0	1	1	0	13.8	1	1.05	0.95
% 23	2	0	0	0	0	1	1	0	0.46	1	1.05	0.95
% ];



%% generator data
%	bus	Pg	Qg	Qmax	Qmin	Vg	mBase	status	Pmax	Pmin	Pc1	Pc2	Qc1min	Qc1max	Qc2min	Qc2max	ramp_agc	ramp_10	ramp_30	ramp_q	apf
mpc.gen = [
%1	2	0	4	-4	1	4	1	4	0	0	0	0	0	0	0	0	0	0	0	0
% 21	1	0	4	-4	1.05	4	1	4	0	-4	0	0	0	0	0	0	0	0	0
22	4	0	5	-5	1.05	4	1	8	0	0	0	0	0	0	0	0	0	0	0;
23	1	0	5	-5	1.02	4	1	8	0	0	0	0	0	0	0	0	0	0	0;
];

%% branch data

%	fbus	tbus	r	x	b	rateA	rateB	rateC	ratio	angle	status	angmin	angmax
% mpc.branch = [
% 1    2    0.0124    0.2617    0.0100    1.0000    1.0000    1.0000         0         0    1.0000 -360.0000  360.0000
% 1    3    0.0218    0.1088    0.0042    1.0000    1.0000    1.0000         0         0    1.0000 -360.0000  360.0000
% 1    4    0.0082    0.0411    0.0016    1.0000    1.0000    1.0000         0         0    1.0000 -360.0000  360.0000
% 3    5    0.0244    0.2283    0.0087    1.0000    1.0000    1.0000         0         0    1.0000 -360.0000  360.0000
% 3   11    0.0298    0.3487    0.0133    1.0000    1.0000    1.0000         0         0    1.0000 -360.0000  360.0000
% 4    6    0.0165    0.0823    0.0031    1.0000    1.0000    1.0000         0         0    1.0000 -360.0000  360.0000
% 4    7    0.0002    0.0012    0.0000    1.0000    1.0000    1.0000         0         0    1.0000 -360.0000  360.0000
% 5    8    0.0012    0.0058    0.0002    1.0000    1.0000    1.0000         0         0    1.0000 -360.0000  360.0000
% 5    9    0.0008    0.0039    0.0001    1.0000    1.0000    1.0000         0         0    1.0000 -360.0000  360.0000
% 9   10    0.0020    0.0099    0.0004    1.0000    1.0000    1.0000         0         0    1.0000 -360.0000  360.0000
% 8   16    0.0108    0.4540    0.0173    1.0000    1.0000    1.0000         0         0    1.0000 -360.0000  360.0000
% 8   17    0.0215    0.5074    0.0194    1.0000    1.0000    1.0000         0         0    1.0000 -360.0000  360.0000
% 9   18    0.0215    0.3074    0.0117    1.0000    1.0000    1.0000         0         0    1.0000 -360.0000  360.0000
% 10   19    0.0195    0.2975    0.0114    1.0000    1.0000    1.0000         0         0    1.0000 -360.0000  360.0000
% 10   20    0.0054    0.1270    0.0049    1.0000    1.0000    1.0000         0         0    1.0000 -360.0000  360.0000
% 6   13    0.0188    0.6274    0.0240    1.0000    1.0000    1.0000         0         0    1.0000 -360.0000  360.0000
% 6   14    0.0560    0.4797    0.0183    1.0000    1.0000    1.0000         0         0    1.0000 -360.0000  360.0000
% 7   15    0.0030    0.1214    0.0046    1.0000    1.0000    1.0000         0         0    1.0000 -360.0000  360.0000
% 8   21         0    0.1000    0.0038    1.0000    1.0000    1.0000         0         0    1.0000 -360.0000  360.0000
% 4   12    0.0014    0.0070    0.0003    1.0000    1.0000    1.0000         0         0    1.0000 -360.0000  360.0000
% 7   22    0.0012    0.0059    0.0002    1.0000    1.0000    1.0000         0         0    1.0000 -360.0000  360.0000
% 2   23    0.0177    0.0882    0.0034    1.0000    1.0000    1.0000         0         0    1.0000 -360.0000  360.00000
% ];
%%
% mpc.branch=[1	2	0.012356522	0.261709075	0	7	7	7	0	0	1	-360	360
% 1	3	0.021782783	0.108784284	0	7	7	7	0	0	1	-360	360
% 1	4	0.008237681	0.041139383	0	7	7	7	0	0	1	-360	360
% 3	5	0.02436215	0.228332438	0	7	7	7	0	0	1	-360	360
% 3	11	0.029773333	0.348689486	0	7	7	7	0	0	1	-360	360
% 4	6	0.016475362	0.082278767	0	7	7	7	0	0	1	-360	360
% 4	7	0.000235362	0.001175411	0	7	7	7	0	0	1	-360	360
% 5	8	0.001171154	0.0058488	0	7	7	7	0	0	1	-360	360
% 5	9	0.000780769	0.0038992	0	7	7	7	0	0	1	-360	360
% 9	10	0.001990962	0.00994296	0	7	7	7	0	0	1	-360	360
% 8	16	0.010817048	0.45402087	0	7	7	7	0	0	1	-360	360
% 8	17	0.021510192	0.507422955	0	7	7	7	0	0	1	-360	360
% 9	18	0.021510192	0.307422955	0	7	7	7	0	0	1	-360	360
% 10	19	0.019519231	0.297479995	0	7	7	7	0	0	1	-360	360
% 10	20	0.005413333	0.127034452	0	7	7	7	0	0	1	-360	360
% 6	13	0.018828986	0.62736621	0	7	7	7	0	0	1	-360	360
% 6	14	0.056016232	0.479747807	0	7	7	7	0	0	1	-360	360
% 7	15	0.002953797	0.121418074	0	7	7	7	0	0	1	-360	360
% 8	21	0	0.1	0	7	7	7	0	0	1	-360	360
% 4	12	0.001406516	0.007024211	0	7	7	7	0	0	1	-360	360
% 7	22	0.001176812	0.005877055	0	7	7	7	0	0	1	-360	360
% 2	23	0.017652174	0.088155822	0	7	7	7	0	0	1	-360	360
% ];
scale = 10;%Make it 10 to have PF converged
scaler = 1;
%	fbus	tbus	r	x	b	rateA	rateB	rateC	ratio	angle	status	angmin	angmax
mpc.branch = [
1	2	0.0004*scaler	0.2671/scale	0.0001  	7	7	7	0	0	1	-360	360
1	3	0.0008*scaler	0.1182/scale	0.000176  	7	7	7	0	0	1	-360	360
1	4	0.0003*scaler	0.0447/scale	0.000067  	7	7	7	0	0	1	-360	360
3	5	0.001*scaler	0.264/scale	0.000234  	7	7	7	0	0	1	-360	360
3	11	0.02*scaler	3.196/scale	0.004467  	7	7	7	0	0	1	-360	360
4	6	0.0006*scaler	0.0894/scale	0.000133  	7	7	7	0	0	1	-360	360
4	7	0	0.0013/scale	0.000002  	7	7	7	0	0	1	-360	360
5	8	0.0001*scaler	0.0211/scale	0.000031  	7	7	7	0	0	1	-360	360
5	9	0.0001*scaler	0.0141/scale	0.000021  	7	7	7	0	0	1	-360	360
9	10	0.0002*scaler	0.0359/scale	0.000053  	7	7	7	0	0	1	-360	360
8	16	0.0098*scaler	1.8732/scale	0.002196  	7	7	7	0	0	1	-360	360
8	17	0.0472*scaler	7.4657/scale	0.010534  	7	7	7	0	0	1	-360	360
9	18	0.0472*scaler	7.2657/scale	0.010534  	7	7	7	0	0	1	-360	360
10	19	0.0469*scaler	7.2298/scale	0.010481  	7	7	7	0	0	1	-360	360
10	20	0.0011*scaler	0.269/scale	0.000252  	7	7	7	0	0	1	-360	360
6	13	0.0192*scaler	3.4144/scale	0.004295  	7	7	7	0	0	1	-360	360
6	14	0.0484*scaler	7.4511/scale	0.01081  	7	7	7	0	0	1	-360	360
7	15	0.0001*scaler	0.1227/scale	0.000024  	7	7	7	0	0	1	-360	360
8	21	0	0.1/scale	0.000037  	7	7	7	0	0	1	-360	360
4	12	0.0192*scaler	3.6762/scale	0.004288  	7	7	7	0	0	1	-360	360
7	22	0	0.0064/scale	0.00001  	7	7	7	0	0	1	-360	360
2	23	0.0192*scaler	2.8746/scale	0.004286  	7	7	7	0	0	1	-360	360
];

%%-----  OPF Data  -----%%
%% generator cost data
%	1	startup	shutdown	n	x1	y1	...	xn	yn
%	2	startup	shutdown	n	c(n-1)	...	c0
mpc.gencost = [
 %   2	1500	0	3	0.11	5	150;
% 	2	1500	0	3	0.11	5	150;
	2	1500	0	3	0.11	5	150;
    2	1500	0	3	0.11	5	150;
];

end 