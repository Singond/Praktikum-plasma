function plot_eedf(x)
	color = get(gca, "colororder")(get(gca, "colororderindex"), :);
	plot(
		x.eedfa_E, x.eedfa, "", "color", color,
		x.eedfa_E, x.mbfit.f(x.eedfa_E), "b--", "color", color,
		x.eedfa_E, x.drfit.f(x.eedfa_E), "b:", "color", color,
		x.eedfa_E, x.gfit.f(x.eedfa_E), "b-.", "color", color
	);
endfunction
