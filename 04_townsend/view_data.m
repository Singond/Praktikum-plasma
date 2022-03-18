main;

clf;
hold on;
for k = 1:numel(E)
	ex = E(k);
	xx = linspace(min(ex.x), max(ex.x), 1000);
	cidx = get(gca, "colororderindex");
	plot(ex.x, ex.I, sprintf("d;%.0f V/mm;", ex.E));
	set(gca, "colororderindex", cidx);
	plot(xx, ex.I0 .* exp(ex.townsend*xx), sprintf(";fit;", ex.E));
endfor
xlabel("electrode distance x [mm]");
ylabel("discharge current I [pA]");
legend("location", "northwest");
hold off;
