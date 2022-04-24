pkg load report;

main;

for x = X
	gp = gnuplotter();
	gp.load("../plotsettings.gp");
	yscale = 1e15;
	gp.plot(x.tr, yscale./x.n, sprintf("ls 1 t '%.0f Pa'", x.p));
	tt = linspace(min(x.tr), max(x.tr), 1000);
	gp.plot(tt, (x.invfit.a .* tt + 1/x.invfit.n) .* yscale, "w l ls 1 dt 2");
	gp.xlabel('čas $\\tm\\,[\\si{\\micro\\second}]$');
	gp.ylabel('$1/\\dens\\,[\\si{\\per\\metre\\cubed}]$');
	gp.exec(sprintf("set label \"\
$\\\\pres=\\\\SI{%.0f}{\\\\pascal}$\\n\
$\\\\recomb=\\\\SI{%g}{\\\\recombunit}$\
\" at graph 0.2,0.7",
		x.p, x.invfit.a));
	gp.exec("set key off");
	gp.exec("set lmargin 6");
	gp.export(sprintf("plots/fit-rec-%d.tex", x.p),
		"epslatex", "size 8cm,6cm");
	clear gp;

	gp = gnuplotter();
	gp.load("../plotsettings.gp");
	gp.plot(x.tr, log(x.n), sprintf("ls 1 t '%.0f Pa'", x.p));
	tt = linspace(min(x.tr), max(x.tr), 1000);
	gp.plot(tt, -x.logfit.DoL .* tt + log(x.logfit.n), "w l ls 1 dt 2");
	gp.xlabel('čas $\\tm\\,[\\si{\\micro\\second}]$');
	gp.ylabel('$\\ln\\dens$');
	gp.exec("set ytics 1");
	gp.exec(sprintf("set label \"\
$\\\\pres=\\\\SI{%.0f}{\\\\pascal}$\\n\
$\\\\doll=\\\\SI{%g}{\\\\dollunit}$\
\" at graph 0.2,0.3",
		x.p, x.logfit.DoL));
	gp.exec("set key off");
	gp.export(sprintf("plots/fit-log-%d.tex", x.p),
		"epslatex", "size 8cm,6cm");
end
clear gp;
