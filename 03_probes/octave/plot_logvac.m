function plot_logvac(x)
	hold on;
	color = get(gca, "colororder")(get(gca, "colororderindex"), :);

	warning("off", "Octave:negative-data-log-axis");
	semilogy(x.U, x.Ie, "", "color", color);
	ub = x.U;
	semilogy(ub, x.bfit(ub), "--", "color", color);
	uc = x.U;
	semilogy(uc, x.cfit(uc), ":", "color", color);

	hold off;
	xlabel("voltage U [V]");
	ylabel("current I [uA]");
endfunction
