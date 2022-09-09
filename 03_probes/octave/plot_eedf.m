function plot_eedf(x)
	if (ishold)
		coloridx = get(gca, "colororderindex");
	else
		coloridx = 1;
	endif
	color = get(gca, "colororder")(coloridx, :);

	## Use exactly one plot without color ("b") in third argument
	## to ensure advancing to the next color in palette.

	## Data
	plot(x.E, x.f, "", "color", color);

	## Maxwell-Boltzmann distribution fit
	plot(x.E, x.mbl.f(x.E), "b--", "color", color);
	if (isfield(x, "mbnl") && isfield(x.mbnl, "f"))
		plot(x.E, x.mbnl.f(x.E), "b--", "color", color);
	endif

	## Druyvesteyn distribution fit
	plot(x.E, x.drl.f(x.E), "b:", "color", color);
	if (isfield(x, "drnl") && isfield(x.drnl, "f"))
		## Have non-linear Druyvesteyn fit: Do not print linearized one
		plot(x.E, x.drnl.f(x.E), "b:", "color", color);
	endif

	## General distribution fit
	if (isfield(x, "gen") && isfield(x.gen, "f"))
		plot(x.E, x.gen.f(x.E), "b-.", "color", color);
	endif
endfunction
