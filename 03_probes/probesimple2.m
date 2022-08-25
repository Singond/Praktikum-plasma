pkg load signal;
pkg load singon-ext;
addpath octave;

common;

global ionmass = 40*amu;             # Ion mass (argon) [kg]
global probesurf = 2*pi*1e-4*8e-3;   # Probe surface area [m3]
global Ua = 1.0;                     # Alternating voltage added [V]

Id = [50 50 30];                     # Discharge current [mA]
p = [5 20 20];                       # Pressure [Pa]

U = struct();
I = struct();
I1 = struct();
I2 = struct();
S = struct();
X = struct();
Y = struct();
for k = 1:3
	U(k) = load_data(sprintf("data/2022-04-05/voltage%02d.txt", k + 4));
	I(k) = load_data(sprintf("data/2022-04-05/current%02d.txt", k + 4));
	## Align times now before separating data
	[U(k).timelinearized, I(k).timelinearized] = align(U(k), I(k));
	[I1(k), I2(k), S(k).sep] = separate_data(I(k), 30, 0.5);
	x = load_experiment(U(k), I1(k));
	y = load_experiment(U(k), I2(k));
	x.Uraw = y.Uraw *= -1;    # Apparently, the voltmeter polarity was wrong
	x.Id = y.Id = Id(k);
	x.p = y.p = p(k);
	X(k) = x;
	Y(k) = y;
endfor
clear k x y;

X(1).U = [];
X(1).I = [];
Y(1).U = [];
Y(1).I = [];
X(1) = extract_vacx(X(1), [29 207; 380 550], 500);
X(2) = extract_vacx(X(2), [20 195; 381 551], 500);
X(3) = extract_vacx(X(3), [20 212; 355 548], 500);
Y(1) = extract_vacx(Y(1), [29 207; 380 550], 500);
Y(2) = extract_vacx(Y(2), [20 195; 381 551], 500);
Y(3) = extract_vacx(Y(3), [20 212; 355 548], 500);

X = arrayfun(@(x, y) plasmaprops_eedf(x, y), X, Y);

Tea = [X.Tea]';
Tep = [X.Tep]';
