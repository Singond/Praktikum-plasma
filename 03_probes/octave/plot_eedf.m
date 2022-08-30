function plot_eedf(x)
	if (ishold)
		coloridx = get(gca, "colororderindex");
	else
		coloridx = 1;
	endif
	color = get(gca, "colororder")(coloridx, :);
	## Use exactly one plot without color ("b") in third argument
	## to ensure advancing to the next color in palette.
	plot(
		x.eedfa_E, x.eedfa, "", "color", color,
		x.eedfa_E, x.mbfit.f(x.eedfa_E), "b--", "color", color,
		x.eedfa_E, x.drfit.f(x.eedfa_E), "b:", "color", color,
		x.eedfa_E, x.gfit.f(x.eedfa_E), "b-.", "color", color
	);
endfunction
