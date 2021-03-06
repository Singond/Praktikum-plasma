main;

function plot_rawdata(x)
	ax = plotyy(x.Utime, x.Uraw, x.Itime, x.Iraw);
	xlabel("time t [s]");
	ylabel(ax(1), "voltage U [V]");
	ylabel(ax(2), "current I [uA]");
endfunction

function plot_rawdata_all(X)
	for x = X
		figure();
		plot_rawdata(x);
	endfor
endfunction

function plot_vac(X)
	clf;
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
