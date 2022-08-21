function plot_separated(D, D1, D2, sep)
	color = get(gca, "colororderindex");
	plot(D.timelinearized, D.val, "");
	washold = ishold;
	hold on;
	set(gca, "colororderindex", color);
	plot(D.timelinearized, sep, "--");

	if (isfield(D1, "timelinearized"))
		plot(D1.timelinearized, D1.val, "o");
	elseif (isfield(D1, "Itime"))
		plot(D1.Itime, -D1.Iraw, "o");
	endif
	if (isfield(D2, "timelinearized"))
		plot(D2.timelinearized, D2.val, "x");
	elseif (isfield(D2, "Itime"))
		plot(D2.Itime, -D2.Iraw, "x");
	endif

	if (!washold)
		hold off;
	endif
endfunction
