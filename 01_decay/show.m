main;

figure(1);
clf;
title("Resonance frequency")
hold on;
for x = X
	plot(x.tr, x.fr, sprintf("d;%.0f Pa;", x.p));
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
	plot(x.tr, 1./x.n, sprintf("d;%.0f Pa;", x.p));
	set(gca, "colororderindex", c);
	tt = linspace(min(x.tr), max(x.tr), 1000);
	plot(tt, x.invfit.a .* tt + 1/x.invfit.n, "displayname", ["x"]);
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
	plot(x.tr, log(x.n), sprintf("d;%.0f Pa;", x.p));
	set(gca, "colororderindex", c);
	tt = linspace(min(x.tr), max(x.tr), 1000);
	plot(tt, -x.logfit.DoL .* tt + log(x.logfit.n), "displayname", ["fit"]);
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
	plot(x.tr, x.n, sprintf("d;%.0f Pa;", x.p));
	set(gca, "colororderindex", c);
	tt = linspace(min(x.tr), max(x.tr), 1000);
	plot(tt, densitymodel(tt, x.nlfit.DoL, x.nlfit.a, x.nlfit.c),
		"displayname", ["fit"]);
end
hold off;
xlabel("t [us]");
ylabel("n [m^{-3}]");
