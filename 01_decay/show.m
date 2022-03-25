main;

figure(1);
clf;
title("Resonance frequency")
hold on;
for x = X
	plot(gca, x.tr, x.fr, sprintf("d;%.0f Pa;", x.p));
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
	plot(gca, x.tr, 1./x.n, sprintf("d;%.0f Pa;", x.p));
	set(gca, "colororderindex", c);
	tt = linspace(min(x.tr), max(x.tr), 1000);
	plot(gca, tt, x.a_a .* tt + 1/x.n0_a, "displayname", ["x"]);
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
	plot(gca, x.tr, log(x.n), sprintf("d;%.0f Pa;", x.p));
	set(gca, "colororderindex", c);
	tt = linspace(min(x.tr), max(x.tr), 1000);
	plot(gca, tt, -x.DoL_b .* tt + log(x.n0_b), "displayname", ["fit"]);
end
hold off;
xlabel("t [us]");
ylabel("log n");
