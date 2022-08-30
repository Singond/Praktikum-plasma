function plot_separated(S)
	if (ishold)
		color = get(gca, "colororderindex");
	else
		color = 1;
	endif
	washold = ishold;

	plot(S.all.timelinearized, S.all.val, "");
	hold on;
	set(gca, "colororderindex", color);
	plot(S.all.timelinearized, S.sep, "--");
	plot(S.upper.timelinearized, S.upper.val, "o");
	plot(S.lower.timelinearized, S.lower.val, "x");

	if (!washold)
		hold off;
	endif
endfunction
