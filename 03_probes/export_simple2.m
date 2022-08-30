pkg load report;

probesimple2;

xrange = {"-48:-36"; "-48:-36"; "-52:-40"};
yrange = {"1:100"; "1:100"; "1:100"};

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
$\\\\plpot=\\\\SI{%.0f}{\\\\volt}$\" \
		at graph 0.1,0.52",
		x.Id, x.p, x.Up));
	gp.export(sprintf("plots/simple2-vac-%d.tex", k),
		"epslatex", "size 8cm,6cm");

	gp = gnuplotter();
	gp.load("../plotsettings.gp");
	gp.plot(x.U, x.Ie, 'w l ls 2');
	gp.plot(x.U, x.bfit(x.U), 'w l ls 2 dt 2');
	gp.plot(x.U, x.cfit(x.U), 'w l ls 2 dt 3');
	gp.xlabel('potenciál sondy $\\potprobe\\,[\\si{\\volt}]$');
	gp.ylabel('elektronový proud $\\ielec\\,[\\si{\\micro\\ampere}]$');
	gp.exec(sprintf("set xrange [%s]", xrange{k}));
	gp.exec(sprintf("set yrange [%s]", yrange{k}));
	gp.exec("\
		set xtics 4 \n\
		set log y \n\
		set ytics nolog \n\
		set format y '$10^{%L}$' \n\
		unset ymtics \n\
		unset key \n\
	");
	gp.export(sprintf("plots/simple2-vac-log-%d.tex", k),
		"epslatex", "size 8cm,6cm");

	gp = gnuplotter();
	gp.load("../plotsettings.gp");
	gp.plot(x.eedfn_E, x.eedfn.*1e-19, 'w l ls 1 t "dle spočtené derivace"');
	gp.plot(x.eedfa_E, x.eedfa.*1e-19, 'w l ls 2 t "dle změřené derivace"');
	gp.plot(x.eedfa_E, x.mbfit.f(x.eedfa_E).*1e-19, sprintf(
		'w l ls 2 dt 2 t "$\\\\tempelec = \\\\SI{%.0f}{\\\\kelvin}$, $\\\\kappa = 1$ (M-B)"',
		x.mbfit.T));
	gp.plot(x.eedfa_E, x.drfit.f(x.eedfa_E).*1e-19, sprintf(
		'w l ls 2 dt 3 t "$\\\\tempelec = \\\\SI{%.0f}{\\\\kelvin}$, $\\\\kappa = 2$ (Druyv.)"',
		x.drfit.T));
	gp.plot(x.eedfa_E, x.gfit.f(x.eedfa_E).*1e-19, sprintf(
		'w l ls 2 dt 4 t "$\\\\tempelec = \\\\SI{%.0f}{\\\\kelvin}$, $\\\\kappa = \\\\num{%.2f}$"',
		x.gfit.T, x.gfit.kappa));
	gp.xlabel('energie $\\enelec\\,[\\si\\electronvolt]$');
	gp.ylabel('$\\eedf\\,[\\SI{e19}{\\per\\metre\\cubed}]$');
	gp.exec("\
		set lmargin 6 \n\
		set key outside center right reverse Left \n\
		set key samplen 2 \n\
		set key width -6 \n\
		set key height 4 \n\
		set key spacing 1.2 \n\
	");
	gp.exec(sprintf("set key title left \
\"$\\\\idisch=\\\\SI{%.0f}{\\\\milli\\\\ampere}$\\n\
$\\\\pres=\\\\SI{%.0f}{\\\\pascal}$\"",
		x.Id, x.p));
	if (!isempty(exec_eedf{k}))
		gp.exec(exec_eedf{k});
	endif
	gp.export(sprintf("plots/simple2-eedf-%d.tex", k),
		"epslatex", "size 16cm,7cm");

	k++;
endfor
