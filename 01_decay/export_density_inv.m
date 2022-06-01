pkg load report;

main;

gp = gnuplotter;
gp.load("../plotsettings.gp");
nscale = 1e-15;
for k = 1:numel(X)
	x = X(k);
	gp.plot(x.tr.*1e6, (1./x.n)./nscale,
		sprintf("w p ls %d t '\\SI{%.0f}{\\pascal}'", k, x.p));
	tt = linspace(min(x.tr), max(x.tr), 1000);
	gp.plot(tt.*1e6,
		(1./densitymodel(tt, x.nlfit.DoL, x.nlfit.a, x.nlfit.c))./nscale,
		sprintf("w l ls %d t ''", k));
endfor
gp.xlabel('čas $\\tm\\,[\\si{\\micro\\second}]$');
gp.exec("set key top right samplen 2 spacing 1.5 at graph 0.20,0.9");
gp.ylabel('$1/\\dens\\,[\\SI{e-15}{\\metre\\cubed}]$');
gp.export("plots/density-inv.tex", "epslatex", "size 17cm,11cm");
