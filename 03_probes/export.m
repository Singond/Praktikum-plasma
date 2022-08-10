pkg load report;

main;

xrange = [repmat({"-50:-30"}, 6, 1); "-60:-35"];
yrange = [repmat({"0.1:1000"}, 6, 1); "*:*"];

exec_eedf = cell(7, 1);
exec_eedf(7) = "set label 1 at graph 0.1,0.7";

k = 1;
for x = X
	gp = gnuplotter();
	gp.load("../plotsettings.gp");
	gp.plot(x.U, x.Im, 'w l ls 1 t "$\\iprobe$ (celkový)"');
##	if (columns(x.I) > 1)
##		for c = 1:columns(x.I)
##			if (c == 1)
##				title = "jednotlivá měření";
##			else
##				title = "";
##			endif
##			gp.plot(x.U, x.I(:,c), ['w l ls 1 dt 3 t "' title '"']);
##		endfor
##	endif
	gp.plot(x.U, x.Ii, 'w l lc "black" dt 2 t "$\\iion$ (iontový)"');
	gp.plot(x.U, x.Ie, 'w l ls 2 dt 4 t "$\\ielec$ (elektronový)"');
	gp.xlabel('potenciál sondy $\\potprobe\\,[\\si{\\volt}]$');
	gp.ylabel('sondový proud $\\iprobe\\,[\\si{\\micro\\ampere}]$');
	gp.exec("set key top left reverse Left samplen 2 height 1");
	gp.exec(sprintf("set label \
\"$\\\\idisch=\\\\SI{%.0f}{\\\\milli\\\\ampere}$\\n\
$\\\\pres=\\\\SI{%.0f}{\\\\pascal}$\\n\
$\\\\plpot=\\\\SI{%.0f}{\\\\volt}$\" \
		at graph 0.1,0.52",
		x.Id, x.p, x.Up));
	gp.export(sprintf("plots/vac-%d.tex", k), "epslatex", "size 8cm,6cm");

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
		set xtics 5 \n\
		set log y \n\
		set ytics nolog \n\
		set format y '$10^{%L}$' \n\
		unset ymtics \n\
		unset key \n\
	");
	gp.export(sprintf("plots/vac-log-%d.tex", k), "epslatex", "size 8cm,6cm");

	gp = gnuplotter();
	gp.load("../plotsettings.gp");
	gp.plot(-x.eedfu, x.eedf.*1e-18, 'w l ls 2');
	gp.xlabel('$\\enelec\\,[\\si\\electronvolt]$');
	gp.ylabel('$\\eedf\\,[\\SI{e18}{\\per\\metre\\cubed}]$');
	gp.exec("\
		unset key \n\
	");
	gp.exec(sprintf("set label 1 \
\"$\\\\idisch=\\\\SI{%.0f}{\\\\milli\\\\ampere}$\\n\
$\\\\pres=\\\\SI{%.0f}{\\\\pascal}$\\n\
$\\\\plpot=\\\\SI{%.0f}{\\\\volt}$\" \
		at graph 0.1,0.4",
		x.Id, x.p, x.Up));
	if (!isempty(exec_eedf{k}))
		gp.exec(exec_eedf{k});
	endif
	gp.export(sprintf("plots/eedf-%d.tex", k), "epslatex", "size 8cm,6cm");
	k++;
endfor
