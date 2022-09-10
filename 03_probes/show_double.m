if (!exist("D"))
	probedouble;
endif

fig = 1;
figure(fig++);
clf;
hold on;
title("Intersection method");
for k = 1:numel(D)
	d = D(k);

	## Data
	set(gca, "colororderindex", k);
	plot(d.U, d.Im, "displayname", sprintf("%.0f mA, %.0f Pa", d.Id, d.p));

	## Left fit
	set(gca, "colororderindex", k);
	plot(d.U, d.fita.f(d.U), "--", "handlevisibility", "off");

	## Center fit
	y = d.fitb.f(d.U);
	m = y > min(d.Im) & y < max(d.Im);
	set(gca, "colororderindex", k);
	plot(d.U(m), y(m), "-.", "handlevisibility", "off");

	## Right fit
	set(gca, "colororderindex", k);
	plot(d.U, d.fitc.f(d.U), ":", "handlevisibility", "off");

	## Intersections
	set(gca, "colororderindex", k);
	plot([0; 0], [d.fita.beta(2); d.fitc.beta(2)], "+",
		"handlevisibility", "off");
	set(gca, "colororderindex", k);
	plot([d.ml; d.mr], d.fitb.f([d.ml; d.mr]), "x",
		"handlevisibility", "off");
	set(gca, "colororderindex", k);
	plot([d.al; d.ar], [d.Ip2; d.Ip1], "d",
		"handlevisibility", "off");

	k++;
endfor
hold off;
xlabel("probes voltage U_s [V]");
ylabel("total probe current I_s [uA]");
legend location northwest;

figure(fig++);
clf;
hold on;
title("General fit method");
for k = 1:numel(D)
	d = D(k);

	## Data
	set(gca, "colororderindex", k);
	plot(d.U, d.Im, "displayname", sprintf("%.0f mA, %.0f Pa", d.Id, d.p));

	## Fit
	set(gca, "colororderindex", k);
	plot(d.U, d.fitg.f(d.U), "--", "handlevisibility", "off");

	k++;
endfor
hold off;
xlabel("probes voltage U_s [V]");
ylabel("total probe current I_s [uA]");
legend location northwest;
