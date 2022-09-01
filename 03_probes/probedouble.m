addpath octave;

common;

Id = [0.03 50 50 50];                # Discharge current [mA]
p = [100 100 20 5];                  # Pressure [Pa]

U = struct();
I = struct();
D = struct();
for k = 1:4
	U(k) = load_data(sprintf("data/2022-04-05/voltage%02d.txt", k));
	I(k) = load_data(sprintf("data/2022-04-05/current%02d.txt", k));
	x = load_experiment(U(k), I(k));
	x.Id = Id(k);
	x.p = p(k);
	D(k) = x;
endfor

D(1).U = [];
D(1).I = [];
D(1) = extract_vacx(D(1), [9 278], 500);
D(2) = extract_vacx(D(2), [15 284; 319 576], 500);
D(3) = extract_vacx(D(3), [11 280; 289 556], 500);
D(4) = extract_vacx(D(4), [90 359; 365 633], 500);

D = arrayfun(@(x) plasmaprops_double(x), D);

