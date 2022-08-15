if (!exist("X"))
	probesimple1;
endif

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
k = 1;
for x = X
	plot(x.U(1:end-2), x.didu2,
		"displayname", sprintf("%.0f mA, %.0f Pa", x.Id, x.p));
	set(gca, "colororderindex", k);
	plot(x.Upd, interp1(x.U(1:end-2), x.didu2, x.Upd), "^",
		"handlevisibility", "off");
	set(gca, "colororderindex", k);
	plot(x.Upa, interp1(x.U(1:end-2), x.didu2, x.Upa), "o",
		"handlevisibility", "off");
	k++;
endfor
set(gca, "colororderindex", 1);
plot(x.Upd, NA, "^", "displayname", "plasma potential V_p (by derivative)");
set(gca, "colororderindex", 1);
plot(x.Upd, NA, "o", "displayname", "plasma potential V_p (by asymptotes)");
legend location northwest;
legend("numcolumns", 2);
hold off;

figure(4);
clf;
title("Electron energy distribution function");
hold on;
for x = X
	plot(abs(x.eedfu), x.eedf);
endfor
hold off;

figure(5);
clf;
title("Electron density");
hold on;
for x = X
	plot(x.Us, x.ne, "displayname", sprintf("%.0f mA, %.0f Pa", x.Id, x.p));
endfor
xlabel("probe voltage U_s [V]");
ylabel("electron density n_e [m^{-3}]");
hold off;
