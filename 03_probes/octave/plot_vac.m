function plot_vac(X)
	ax = gca();
	hold on;
	k = 1;
	for x = X
		color = get(ax, "colororder")(k++, :);
		first = true;
		for ii = x.I
			args = {};
			if (first)
				args(end+[1 2]) = {"displayname",...
					sprintf("%.0f mA, %.0f Pa", x.Id, x.p)};
			else
				args(end+[1 2]) = {"handlevisibility", "off"};
			endif
			plot(ax, x.U, ii, "color", color, args{:});
			first = false;
		endfor
	endfor
	hold off;
	xlabel(ax, "probe potential V_s [V]");
	ylabel(ax, "total probe current I_s [uA]");
	legend location northwest;
endfunction
