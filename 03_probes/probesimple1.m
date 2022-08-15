pkg load signal;
pkg load singon-ext;
addpath octave;

common;

global ionmass = 40*amu;             # Ion mass (argon) [kg]
global probesurf = 2*pi*1e-4*8e-3;   # Probe surface area [m3]

Id = [50 40 30 50 50 50 50];  ## Discharge current [mA]
p = [50 50 50 20 10 5 100];   ## Pressure [Pa]

U = struct();
I = struct();
X = struct();
for k = 1:7
	U(k) = load_data(sprintf("data/2022-03-08/voltage%02d.txt", k));
	I(k) = load_data(sprintf("data/2022-03-08/current%02d.txt", k));
	x = load_experiment(U(k), I(k));
	x.Id = Id(k);
	x.p = p(k);
	X(k) = x;
endfor
clear U I k x;

X(1).U = [];
X(1).I = [];
X(1) = extract_vacx(X(1), [7 276; 288 555], 500);
X(2) = extract_vacx(X(2), [15 282; 288 557], 500);
X(3) = extract_vacx(X(3), [12 281; 288 558], 500);
X(4) = extract_vacx(X(4), [13 281; 291 560], 500);
X(5) = extract_vacx(X(5), [10 281; 315 583], 500);
X(6) = extract_vacx(X(6), [12 282; 288 556], 500);
X(7) = extract_vacx(X(7), [291 559], 500);

X = arrayfun(@(x) plasmaprops_simple(x), X);

Tea = [X.Tea]';
Tep = [X.Tep]';
