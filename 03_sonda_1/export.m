pkg load report;

main;

k = 1;
for x = X
	gp = gnuplotter();
	gp.load("../plotsettings.gp");
	gp.plot(x.U, x.I(:,1), 'w l ls 1 t "jednotlivá měření"');
	if (columns(x.I) > 1)
		for c = 1:columns(x.I)
			gp.plot(x.U, x.I(:,c), 'w l ls 1 t ""');
		endfor
		gp.plot(x.U, mean(x.I, 2), 'w l ls 1 lc "black" t "průměr"');
	endif
	gp.xlabel('napětí $\\potprobe\\,[\\si{\\volt}]$');
	gp.ylabel('sondový proud $\\iprobe\,[\\si{\\micro\\ampere}]$');
	gp.exec("set key top left");
	gp.export(sprintf("plots/vac-%d.tex", k), "epslatex", "size 16cm,10cm");
	k++;
endfor
