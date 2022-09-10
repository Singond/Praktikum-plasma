pkg load report;

probedouble;

k = 1;
for x = D
	gp = gnuplotter();
	gp.load("../plotsettings.gp");
	gp.plot(x.U, x.Im, 'w l ls 2 t "$\\iprobe$ (celkový)"');
	gp.plot(x.U, x.fita.f(x.U), 'w l ls 2 dt 2 t "$\\ielec$ (iontový)"');
	gp.plot(x.U, x.fitc.f(x.U), 'w l ls 2 dt 2 t ""');
	y = x.fitb.f(x.U);
	m = y >= min(x.Im) & y <= max(x.Im);
	gp.plot(x.U(m), x.fitb.f(x.U(m)), 'w l ls 1 dt 3 t ""');
	gp.plot([x.al; x.ar], [x.Ip2; x.Ip1], 'w p ls 2 pt 13 t ""');
	gp.exec("\
		set arrow nohead from first 0, graph 0 to first 0, graph 1 lc 'black' dt 2 \n\
		set arrow nohead from graph 0, first 0 to graph 1, first 0 lc 'black' dt 2 \n\
		");
	gp.xlabel('napětí sondy $\\udoubleprobe\\,[\\si{\\volt}]$');
	gp.ylabel('sondový proud $\\iprobe\\,[\\si{\\micro\\ampere}]$');
	gp.exec("\
		set xtics 4 \n\
		set key bottom right reverse Left samplen 2 height 1 \n\
		unset key \n\
	");
	gp.exec(sprintf("set label \
\"$\\\\idisch=\\\\SI{%g}{\\\\milli\\\\ampere}$\\n\
$\\\\pres=\\\\SI{%.0f}{\\\\pascal}$\" \
		at graph 0.1,0.9",
		x.Id, x.p));
	gp.export(sprintf("plots/double-vac-%d.tex", k),
		"epslatex", "size 8cm,6cm");

	k++;
endfor

gp = gnuplotter();
gp.load("../plotsettings.gp");
for k = 1:numel(D)
	x = D(k);
	gp.plot(x.U(1:10:end), x.Im(1:10:end), sprintf(
		'w p ls %d pt %d t "$\\\\SI{%g}{\\\\milli\\\\ampere}, \\\\SI{%g}{\\\\pascal}$"',
		k, 2 + k*2, x.Id, x.p));
	gp.plot(x.U, x.fitg.f(x.U), sprintf(
		'w l ls %d dt 1 t ""', k));
endfor
##gp.plot(nan, nan, 'w p ls 1 pt 4 t "data"');
##gp.plot(nan, nan, 'w l ls 1 dt 1 t "aproximace"');
gp.xlabel('napětí sondy $\\udoubleprobe\\,[\\si{\\volt}]$');
gp.ylabel('sondový proud $\\iprobe\\,[\\si{\\micro\\ampere}]$');
gp.exec("\
	set key top left reverse Left samplen 2 height 2 \n\
");
gp.export(sprintf("plots/double-fit.tex", k),
	"epslatex", "size 16cm,8cm");
