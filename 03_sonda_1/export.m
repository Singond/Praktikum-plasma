pkg load report;

main;

k = 1;
for x = X
	gp = gnuplotter();
	gp.load("../plotsettings.gp");
	gp.plot(x.Us, x.Im, 'w l ls 1 t "celkový proud $\\iprobe$"');
	if (columns(x.I) > 1)
		for c = 1:columns(x.I)
			if (c == 1)
				title = "jednotlivá měření";
			else
				title = "";
			endif
			gp.plot(x.Us, x.I(:,c), ['w l ls 1 dt 3 t "' title '"']);
		endfor
	endif
	gp.plot(x.Us, x.Ii, 'w l lc "black" dt 2 t "iontový proud $\\iion$"');
	gp.plot(x.Us, x.Ie, 'w l ls 2 t "elektronový proud $\\ielec$"');
	gp.xlabel('napětí $\\potprobe\\,[\\si{\\volt}]$');
	gp.ylabel('sondový proud $\\iprobe\\,[\\si{\\micro\\ampere}]$');
	gp.exec("set key top left");
	gp.exec(sprintf("set label \
\"$\\\\idisch=\\\\SI{%.0f}{\\\\micro\\\\ampere}$\\n\
$\\\\pres=\\\\SI{%.0f}{\\\\pascal}$\\n\
$\\\\plpot=\\\\SI{%.0f}{\\\\volt}$\" \
		at graph 0.2,0.5",
		x.Id, x.p, x.Up));
	gp.export(sprintf("plots/vac-%d.tex", k), "epslatex", "size 16cm,10cm");
	k++;
endfor
