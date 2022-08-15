function plot_vac(X)
	ax = gca();
	hold on;
	for x = X
		color = get(ax, "colororder")(get(ax, "colororderindex"), :);
		first = true;
		for ii = x.I
			args = {};
			if (first)
				args(end+[1 2]) = {"displayname",...
					sprintf("%.0f mA, %.0f Pa", x.Id, x.p)};
			else
				args(end+[1 2]) = {"handlevisibility", "off"};
			endif
			plot(ax, x.Us, ii, "color", color, args{:});
			first = false;
		endfor
	endfor
	hold off;
	xlabel(ax, "voltage U [V]");
	ylabel(ax, "current I [uA]");
	legend location northwest;
endfunction
