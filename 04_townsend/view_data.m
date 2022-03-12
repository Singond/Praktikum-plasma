main;

clf;
hold on;
for k = 1:numel(E)
	ex = E(k);
	plot(ex.x, ex.I, sprintf("d;%.0f V/mm;", ex.E));
endfor
xlabel("electrode distance x [mm]");
ylabel("discharge current I [pA]");
legend("location", "northwest");
hold off;
