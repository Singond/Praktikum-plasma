pkg load report;

probedouble;

k = 1;
for x = D
	gp = gnuplotter();
	gp.load("../plotsettings.gp");
	gp.plot(x.U, x.Im, 'w l ls 1 t "$\\iprobe$ (celkový)"');
##	gp.plot(x.U, x.Ii, 'w l lc "black" dt 2 t "$\\iion$ (iontový)"');
##	gp.plot(x.U, x.Ie, 'w l ls 2 dt 4 t "$\\ielec$ (elektronový)"');
	gp.xlabel('potenciál sondy $\\potprobe\\,[\\si{\\volt}]$');
	gp.ylabel('sondový proud $\\iprobe\\,[\\si{\\micro\\ampere}]$');
	gp.exec("\
		set xtics 4 \n\
		set key top left reverse Left samplen 2 height 1 \n\
	");
	gp.export(sprintf("plots/double-vac-%d.tex", k),
		"epslatex", "size 8cm,6cm");

	k++;
endfor
