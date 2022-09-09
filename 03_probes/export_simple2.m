pkg load report;

probesimple2;

xrange = {"-52:-36"; "-54:-38"; "-56:-40"};
yrange = {"0.1:100"; "0.1:100"; "0.1:100"};

exec_eedf = cell(7, 1);
exec_eedf(7) = "set label 1 at graph 0.1,0.7";

k = 1;
for x = X
	gp = gnuplotter();
	gp.load("../plotsettings.gp");
	gp.plot(x.U, x.Im, 'w l ls 1 t "$\\iprobe$ (celkový)"');
	gp.plot(x.U, x.Ii, 'w l lc "black" dt 2 t "$\\iion$ (iontový)"');
	gp.plot(x.U, x.Ie, 'w l ls 2 dt 4 t "$\\ielec$ (elektronový)"');
	gp.xlabel('potenciál sondy $\\potprobe\\,[\\si{\\volt}]$');
	gp.ylabel('sondový proud $\\iprobe\\,[\\si{\\micro\\ampere}]$');
	gp.exec("\
		set xtics 4 \n\
		set key top left reverse Left samplen 2 height 1 \n\
	");
	gp.exec(sprintf("set label \
\"$\\\\idisch=\\\\SI{%.0f}{\\\\milli\\\\ampere}$\\n\
$\\\\pres=\\\\SI{%.0f}{\\\\pascal}$\\n\
$\\\\plpotd=\\\\SI{%.0f}{\\\\volt}$\" \
		at graph 0.1,0.52",
		x.Id, x.p, x.Up));
	gp.export(sprintf("plots/simple2-vac-%d.tex", k),
		"epslatex", "size 8cm,6cm");

	gp = gnuplotter();
	gp.load("../plotsettings.gp");
	gp.plot(x.U, x.Ie, 'w l ls 2');
	gp.plot(x.U, x.bfit(x.U), 'w l ls 2 dt 2');
	gp.plot(x.U, x.cfit(x.U), 'w l ls 2 dt 3');
	gp.plot(x.Upa, x.bfit(x.Upa), 'w p ls 2');
	gp.xlabel('potenciál sondy $\\potprobe\\,[\\si{\\volt}]$');
	gp.ylabel('elektronový proud $\\ielec\\,[\\si{\\micro\\ampere}]$');
	gp.exec(sprintf("set xrange [%s]", xrange{k}));
	gp.exec(sprintf("set yrange [%s]", yrange{k}));
	gp.exec(sprintf(
		"set label \"$\\\\plpota=\\\\SI{%.1f}{\\\\volt}$\" at %g,%g",
		x.Upa, x.Upa, x.bfit(x.Upa) / 4));
	gp.exec("\
		set xtics 4 \n\
		set log y \n\
		set ytics nolog \n\
		set format y '$10^{%L}$' \n\
		unset key \n\
	");
	gp.export(sprintf("plots/simple2-vac-log-%d.tex", k),
		"epslatex", "size 8cm,6cm");

	gp = gnuplotter();
	gp.load("../plotsettings.gp");
	gp.plot(x.fitn.E, x.fitn.f.*1e-19, 'w l ls 1 axes x1y2 t "dle spočtené derivace"');
	gp.plot(x.fitn.E, x.fitn.mb.f(x.fitn.E).*1e-19, sprintf(
		'w l ls 1 dt 2 axes x1y2 t "$\\\\tempelec = \\\\SI{%.0f}{\\\\kelvin}$, $\\\\kappa = 1$ (M-B)"',
		x.fitn.mb.T));
	gp.plot(x.fitn.E, x.fitn.dr.f(x.fitn.E).*1e-19, sprintf(
		'w l ls 1 dt 3 axes x1y2 t "$\\\\tempelec = \\\\SI{%.0f}{\\\\kelvin}$, $\\\\kappa = 2$ (Druyv.)"',
		x.fitn.dr.T));
	if (isfield(x.fitn, "gen"))
		gp.plot(x.fitn.E, x.fitn.gen.f(x.fitn.E).*1e-19, sprintf(
			'w l ls 1 dt 4 axes x1y2 t "$\\\\tempelec = \\\\SI{%.0f}{\\\\kelvin}$, $\\\\kappa = \\\\num{%.2f}$"',
			x.fitn.gen.T, x.fitn.kappa));
	endif
	gp.plot(x.fita.E, x.fita.f.*1e-19, 'w l ls 2 t "dle změřené derivace"');
	gp.plot(x.fita.E, x.fita.mb.f(x.fita.E).*1e-19, sprintf(
		'w l ls 2 dt 2 t "$\\\\tempelec = \\\\SI{%.0f}{\\\\kelvin}$, $\\\\kappa = 1$ (M-B)"',
		x.fita.mb.T));
	gp.plot(x.fita.E, x.fita.dr.f(x.fita.E).*1e-19, sprintf(
		'w l ls 2 dt 3 t "$\\\\tempelec = \\\\SI{%.0f}{\\\\kelvin}$, $\\\\kappa = 2$ (Druyv.)"',
		x.fita.dr.T));
	if (isfield(x.fita, "gen"))
		gp.plot(x.fita.E, x.fita.gen.f(x.fita.E).*1e-19, sprintf(
			'w l ls 2 dt 4 t "$\\\\tempelec = \\\\SI{%.0f}{\\\\kelvin}$, $\\\\kappa = \\\\num{%.2f}$"',
			x.fita.gen.T, x.fita.kappa));
	endif
	gp.xlabel('energie $\\enelec\\,[\\si\\electronvolt]$');
	gp.ylabel('$\\eedf$');
	gp.exec("\
		set lmargin 2 \n\
		set rmargin 30 \n\
		unset ytics \n\
		unset y2tics \n\
		set key outside center right reverse Left \n\
		set key samplen 2 \n\
		set key width -6 \n\
		set key height 0 \n\
		set key spacing 1.2 \n\
		set key maxcols 1 \n\
	");
	gp.exec(sprintf("set label 1 left \
\"$\\\\idisch=\\\\SI{%.0f}{\\\\milli\\\\ampere}$\\n\
$\\\\pres=\\\\SI{%.0f}{\\\\pascal}$\" \
at graph 0.25,0.2",
		x.Id, x.p));
	if (!isempty(exec_eedf{k}))
		gp.exec(exec_eedf{k});
	endif
	gp.export(sprintf("plots/simple2-eedf-%d.tex", k),
		"epslatex", "size 16cm,7cm");

	k++;
endfor
