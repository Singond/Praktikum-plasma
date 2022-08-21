function plot_separated(D, D1, D2, sep)
	color = get(gca, "colororderindex");
	plot(D.timelinearized, D.val, "");
	washold = ishold;
	hold on;
	set(gca, "colororderindex", color);
	plot(D.timelinearized, sep, "--");
	plot(D1.timelinearized, D1.val, "o");
	plot(D2.timelinearized, D2.val, "x");
	if (!washold)
		hold off;
	endif
endfunction
