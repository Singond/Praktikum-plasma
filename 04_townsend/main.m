0;  # Not a function file

function D = process(file)
	data = dlmread(file, "", 1, 0);
	D.x = data(:,2);            # Electrode distance [mm]
	D.U = data(:,1);            # Applied voltage [V]
	D.Iall = data(:,3:5);       # Current data [pA]
	D.I = mean(D.Iall, 2);      # Average current [pA]
	D.Eall = D.U ./ D.x;        # Electric field intensity [V/mm]
	D.E = mean(D.Eall);         # Average electric field intensity [V/mm]

	## Fit log(I) = log(I_0) + alpha*x
	b = ols(log(D.I), [D.x, ones(size(D.x))]);
	D.townsend = b(1);
	D.I0 = exp(b(2));
endfunction

E(3) = process("data/data-01.tsv");
E(2) = process("data/data-02.tsv");
E(1) = process("data/data-03.tsv");
E(4) = process("data/data-04.tsv");
E(5) = process("data/data-05.tsv");
