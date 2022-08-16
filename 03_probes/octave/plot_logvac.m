function plot_logvac(x, k = 0)
	hold on;
	if (k > 0)
		color = get(gca, "colororder")(k, :);
	else
		color = get(gca, "colororder")(get(gca, "colororderindex"), :);
	endif

	warning("off", "Octave:negative-data-log-axis");
	semilogy(x.U, x.Ie, "", "color", color);
	ub = x.U;
	semilogy(ub, x.bfit(ub), "--", "color", color);
	uc = x.U;
	semilogy(uc, x.cfit(uc), ":", "color", color);

	hold off;
	xlabel("probe potential V_s [V]");
	ylabel("electron current I_e [uA]");
endfunction
