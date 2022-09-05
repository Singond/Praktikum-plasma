if (!exist("D"))
	probedouble;
endif

fig = 1;
figure(fig++);
clf;
hold on;
title("Total probe current");
for k = 1:numel(D)
	d = D(k);

	## Data
	set(gca, "colororderindex", k);
	plot(d.U, d.Im);

	## Left fit
	set(gca, "colororderindex", k);
	plot(d.U, d.fita.f(d.U), "--");

	## Center fit
	y = d.fitb.f(d.U);
	m = y > min(d.Im) & y < max(d.Im);
	set(gca, "colororderindex", k);
	plot(d.U(m), y(m), "-.");

	## Right fit
	set(gca, "colororderindex", k);
	plot(d.U, d.fitc.f(d.U), ":");
	k++;
endfor
hold off;

