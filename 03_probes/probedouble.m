addpath octave;

common;

Id = [0.03 50 50 50];                # Discharge current [mA]
p = [100 100 20 5];                  # Pressure [Pa]

U = struct();
I = struct();
X = struct();
for k = 1:4
	U(k) = load_data(sprintf("data/2022-04-05/voltage%02d.txt", k));
	I(k) = load_data(sprintf("data/2022-04-05/current%02d.txt", k));
	x = load_experiment(U(k), I(k));
	x.Id = Id(k);
	x.p = p(k);
	X(k) = x;
endfor

X(1).U = [];
X(1).I = [];
X(1) = extract_vacx(X(1), [9 278], 500);
X(2) = extract_vacx(X(2), [15 284; 319 576], 500);
X(3) = extract_vacx(X(3), [11 280; 289 556], 500);
X(4) = extract_vacx(X(4), [90 359; 365 633], 500);

X = arrayfun(@(x) plasmaprops_double(x), X);

