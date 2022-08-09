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

figure(1);
clf;
title("V-A characteristics");
plot_vac(X);

figure(2);
clf;
title("V-A characteristics (log)");
hold on;
for x = X
	plot_logvac(x)
endfor
hold off;

figure(3);
clf;
title("Second derivative of V-A characteristic");
hold on;
for x = X
	plot(x.Us(1:end-2), diff(x.Ies(x.Us), 2) ./ diff(x.Us(1:end-1)).^2);
endfor
hold off;

figure(4);
clf;
title("Electron energy distribution function");
hold on;
for x = X
	plot(abs(x.eedfu), x.eedf);
endfor
hold off;
