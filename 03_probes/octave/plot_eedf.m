function plot_eedf(x)
	if (ishold)
		coloridx = get(gca, "colororderindex");
	else
		coloridx = 1;
	endif
	color = get(gca, "colororder")(coloridx, :);
	## Use exactly one plot without color ("b") in third argument
	## to ensure advancing to the next color in palette.
	plot(x.E, x.f, "", "color", color);
	plot(x.E, x.mb.f(x.E), "b--", "color", color);
	plot(x.E, x.dr.f(x.E), "b:", "color", color);
	if (isfield(x, "gen"))
		plot(x.E, x.gen.f(x.E), "b-.", "color", color);
	endif
endfunction
