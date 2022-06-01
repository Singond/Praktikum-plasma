main;

figure(1);
clf;
title("Resonance frequency")
hold on;
for x = X
	plot(x.tr.*1e6, x.fr.*1e-6, sprintf("d;%.0f Pa;", x.p));
end
hold off;
xlabel("t [us]");
ylabel("f [MHz]");

figure(2);
clf;
title("Electron density (reciprocal)");
hold on;
for x = X
	c = get(gca, "colororderindex");
	plot(x.tr.*1e6, 1./x.n, sprintf("d;%.0f Pa;", x.p));
	set(gca, "colororderindex", c);
	tt = linspace(min(x.tr), max(x.tr), 1000);
	plot(tt.*1e6, x.invfit.a .* tt + 1/x.invfit.n, "displayname", ["x"]);
end
hold off;
xlabel("t [us]");
ylabel("1/n [m-3]");

figure(3);
clf;
title("Electron density (logarithmic)");
hold on;
for x = X
	c = get(gca, "colororderindex");
	plot(x.tr.*1e6, log(x.n), sprintf("d;%.0f Pa;", x.p));
	set(gca, "colororderindex", c);
	tt = linspace(min(x.tr), max(x.tr), 1000);
	plot(tt.*1e6, -x.logfit.DoL .* tt + log(x.logfit.n), "displayname", ["fit"]);
end
hold off;
xlabel("t [us]");
ylabel("log n");

figure(4);
clf;
title("Electron density");
hold on;
for x = X
	c = get(gca, "colororderindex");
	plot(x.tr.*1e6, x.n, sprintf("d;%.0f Pa;", x.p));
	set(gca, "colororderindex", c);
	tt = linspace(min(x.tr), max(x.tr), 1000);
	plot(tt.*1e6, densitymodel(tt, x.nlfit.DoL, x.nlfit.a, x.nlfit.c),
		"displayname", ["fit"]);
end
hold off;
xlabel("t [us]");
ylabel("n [m^{-3}]");

figure(5);
clf;
title("Electron density (reciprocal)");
hold on;
for x = X
	c = get(gca, "colororderindex");
	plot(x.tr.*1e6, 1./x.n, sprintf("d;%.0f Pa;", x.p));
	set(gca, "colororderindex", c);
	tt = linspace(min(x.tr), max(x.tr), 1000);
	plot(tt.*1e6, 1./densitymodel(tt, x.nlfit.DoL, x.nlfit.a, x.nlfit.c),
		"displayname", ["fit"]);
end
hold off;
xlabel("t [us]");
ylabel("n [m^{-3}]");

figure(6);
clf;
title("Electron density (logarithmic)");
hold on;
for x = X
	c = get(gca, "colororderindex");
	plot(x.tr.*1e6, log(x.n), sprintf("d;%.0f Pa;", x.p));
	set(gca, "colororderindex", c);
	tt = linspace(min(x.tr), max(x.tr), 1000);
	plot(tt.*1e6, log(densitymodel(tt, x.nlfit.DoL, x.nlfit.a, x.nlfit.c)),
		"displayname", ["fit"]);
end
hold off;
xlabel("t [us]");
ylabel("n [m^{-3}]");

figure(7);
clf;
title("Diffusion coefficient");
plot(p, D, "d");
pp = linspace(min(p), max(p), 1000)';
nn = pp / (kb * temp);
plot(pp, D_bolsig(nn));
xlabel("p [Pa]");
ylabel("D [m^2/s]");
