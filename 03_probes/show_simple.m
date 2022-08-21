if (!exist("X"))
	probesimple1;
endif

fig = 1;
figure(fig++);
clf;
title("Total probe current");
plot_vac(X);

figure(fig++);
clf;
title("Electron current (log)");
hold on;
k = 1;
for x = X
	plot_logvac(x, k++)
endfor
hold off;

figure(fig++);
clf;
title("Electron current");
hold on;
k = 1;
for x = X
	plot(x.U, x.Ie,
		"displayname", sprintf("%.0f mA, %.0f Pa", x.Id, x.p));
	set(gca, "colororderindex", k);
	plot(x.U, x.Ies, "--", "handlevisibility", "off");
	k++;
endfor
xlabel("probe potential V_s [V]");
ylabel("electron current I_e [uA]");
legend location northwest;
hold off;

figure(fig++);
clf;
title("Second derivative of electron current");
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
xlabel("probe potential V_s [V]");
legend location northwest;
legend("numcolumns", 2);
hold off;

figure(fig++);
clf;
title("Electron energy distribution function");
hold on;
for x = X
	plot(abs(x.eedfu), x.eedf);
endfor
hold off;

figure(fig++);
clf;
title("Electron density");
hold on;
for x = X
	plot(x.Us, x.ne, "displayname", sprintf("%.0f mA, %.0f Pa", x.Id, x.p));
endfor
xlabel("probe voltage U_s [V]");
ylabel("electron density n_e [m^{-3}]");
hold off;
